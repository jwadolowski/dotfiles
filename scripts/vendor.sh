#!/usr/bin/env bash
#
# Materialize upstream content declared in vendor.yaml.
#
# CI runs this: Renovate bumps a revision in the manifest, the workflow re-runs
# the script and commits the result onto the same branch. Updates reach machines
# through `git pull`, not by running this by hand.
#
#   ./scripts/vendor.sh            Materialize at the recorded revisions.
#                                  Idempotent, and re-resolves 'pin' when 'ref'
#                                  moved underneath it. Use it to verify or
#                                  repair the tree.
#
#   ./scripts/vendor.sh --update   Resolve revisions forward first, then
#                                  materialize. Renovate normally owns this.
#
# Never runs installers: upstream dependency manifests are copied, not executed.

set -o errexit
set -o errtrace
set -o pipefail
set -o nounset

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="${REPO_ROOT}/vendor.yaml"

UPDATE=0
[[ ${1:-} == "--update" ]] && UPDATE=1

for cmd in yq jq curl rsync tar sed; do
  command -v "${cmd}" >/dev/null || {
    echo "missing required command: ${cmd}" >&2
    exit 1
  }
done

TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}"' EXIT

function api() {
  # GH_TOKEN lifts the anonymous 60 req/h limit to 1000 req/h when present.
  if [[ -n ${GH_TOKEN:-} ]]; then
    curl -fsSL -H "Authorization: Bearer ${GH_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" "$@"
  else
    curl -fsSL -H "X-GitHub-Api-Version: 2022-11-28" "$@"
  fi
}

function resolve_sha() {
  api "https://api.github.com/repos/${1}/commits/${2}" | jq -r '.sha'
}

function latest_tag() {
  # Highest semver-ish tag, ignoring prefixed release trains (e.g. 'bin-v1.2.3').
  api "https://api.github.com/repos/${1}/tags?per_page=100" |
    jq -r '.[].name | select(test("^v[0-9]+\\.[0-9]+\\.[0-9]+$"))' |
    sort -V | tail -1
}

# Under Actions this lands in the job summary; locally it just prints. Nothing
# is written into the working tree - the drift check compares a clean status.
function summary() {
  echo "$1"
  [[ -n ${GITHUB_STEP_SUMMARY:-} ]] && echo "$1" >>"${GITHUB_STEP_SUMMARY}"
  return 0
}

# The revision to materialize. Only --update moves a tag forward; a branch
# target keeps whatever Renovate wrote into 'ref'.
function target_ref() {
  local track="$1" repo="$2" ref="$3" newest
  if ((UPDATE)) && [[ ${track} == "tag" ]]; then
    newest="$(latest_tag "${repo}")"
    [[ -n ${newest} ]] && ref="${newest}"
  fi
  echo "${ref}"
}

# A tag bump leaves 'pin' stale, so tags are always re-resolved. A branch digest
# is authoritative as written - Renovate updates it directly.
function target_sha() {
  local track="$1" repo="$2" ref="$3" pin="$4"
  if ((UPDATE)) || [[ ${track} == "tag" ]]; then
    resolve_sha "${repo}" "${ref}"
  else
    echo "${pin}"
  fi
}

function fetch_target() {
  local repo="$1" sha="$2" dest="$3"
  mkdir -p "${dest}"
  api "https://api.github.com/repos/${repo}/tarball/${sha}" |
    tar -xz -C "${dest}" --strip-components=1
}

function copy_entry() {
  local src="$1" to="$2" include="$3" exclude="$4"
  local dest="${REPO_ROOT}/${to}" child pattern skip

  if [[ -d ${src} && -z ${include} ]]; then
    # Copy each child separately: the destination is shared with other upstreams
    # and with local content, so --delete must never be scoped at its root.
    for child in "${src}"/*; do
      [[ -e ${child} || -L ${child} ]] || continue
      skip=0
      for pattern in ${exclude}; do
        # shellcheck disable=SC2053
        [[ $(basename "${child}") == ${pattern} ]] && {
          skip=1
          break
        }
      done
      ((skip)) && continue
      rsync -a --delete "${child}" "${dest}/"
    done
  elif [[ -d ${src} ]]; then
    mkdir -p "${dest}"
    for pattern in ${include}; do
      # --delete prunes files upstream removed from inside each copied
      # directory. It is a no-op when the pattern matches plain files.
      # shellcheck disable=SC2086
      rsync -a --delete ${src}/${pattern} "${dest}/"
    done
  else
    mkdir -p "$(dirname "${dest}")"
    rsync -a "${src}" "${dest}"
  fi
}

# Upstream content written for another harness is rewritten in place, so the
# vendored copy is what this repo actually deploys - no post-stow fixups.
function apply_patch() {
  local to="$1" patch="$2" name="$3"
  local script="${REPO_ROOT}/scripts/lib/${patch}.sed"
  local dest="${REPO_ROOT}/${to}" target targets=()

  [[ -f ${script} ]] || {
    echo "${name}: unknown patch '${patch}'" >&2
    exit 1
  }

  if [[ -d ${dest} ]]; then
    mapfile -t targets < <(find "${dest}" -type f -name '*.md')
  else
    targets=("${dest}")
  fi

  for target in "${targets[@]}"; do
    # The scripts edit frontmatter and their line ranges assume it exists; a
    # file without an opening fence is passed through untouched.
    [[ $(head -n 1 "${target}") == "---" ]] || continue
    sed -f "${script}" "${target}" >"${TMP}/patched" || {
      echo "${name}: patch '${patch}' failed on ${target}" >&2
      exit 1
    }
    cmp -s "${TMP}/patched" "${target}" || {
      cat "${TMP}/patched" >"${target}"
      echo "    patched ${target#"${REPO_ROOT}/"}"
    }
  done
}

count="$(yq '.targets | length' "${MANIFEST}")"
for ((i = 0; i < count; i++)); do
  name="$(yq -r ".targets[${i}].name" "${MANIFEST}")"
  repo="$(yq -r ".targets[${i}].repo" "${MANIFEST}")"
  track="$(yq -r ".targets[${i}].track" "${MANIFEST}")"
  ref="$(target_ref "${track}" "${repo}" "$(yq -r ".targets[${i}].ref" "${MANIFEST}")")"
  sha="$(target_sha "${track}" "${repo}" "${ref}" "$(yq -r ".targets[${i}].pin" "${MANIFEST}")")"

  [[ -n ${sha} && ${sha} != "null" ]] || {
    echo "${name}: could not resolve ${ref}" >&2
    exit 1
  }

  summary "==> ${name}: ${repo}@${ref} (${sha:0:12})"

  src="${TMP}/${name}"
  fetch_target "${repo}" "${sha}" "${src}"

  copies="$(yq ".targets[${i}].copy | length" "${MANIFEST}")"
  for ((c = 0; c < copies; c++)); do
    from="$(yq -r ".targets[${i}].copy[${c}].from" "${MANIFEST}")"
    to="$(yq -r ".targets[${i}].copy[${c}].to" "${MANIFEST}")"
    include="$(yq -r ".targets[${i}].copy[${c}].include // [] | join(\" \")" "${MANIFEST}")"
    exclude="$(yq -r ".targets[${i}].copy[${c}].exclude // [] | join(\" \")" "${MANIFEST}")"
    patch="$(yq -r ".targets[${i}].copy[${c}].patch // \"\"" "${MANIFEST}")"

    [[ -e "${src}/${from}" ]] || {
      echo "${name}: '${from}' missing upstream" >&2
      exit 1
    }

    copy_entry "${src}/${from}" "${to}" "${include}" "${exclude}"
    [[ -n ${patch} ]] && apply_patch "${to}" "${patch}" "${name}"
  done

  yq -i ".targets[${i}].ref = \"${ref}\" | .targets[${i}].pin = \"${sha}\"" "${MANIFEST}"
done

echo
echo "done - review 'git diff' before committing"
