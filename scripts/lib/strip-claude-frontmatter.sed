# Drop Claude-only keys from vendored agent frontmatter so opencode can load it.
# Mirrors bin/lib/opencode-agent.js in JuliusBrussee/caveman, which that
# project's installer applies for the same reason.
#
# Runs only on files starting with a '---' fence (see scripts/vendor.sh), which
# is what anchors the range to frontmatter and leaves the body alone.

2,/^---$/ {
  # `tools: [Read, Grep]` - opencode wants an object map and aborts the entire
  # config load on the array form. The range also covers an indented list.
  /^tools[ \t]*:/,/^[^ \t]/ {
    /^tools[ \t]*:/d
    /^[ \t]/d
  }

  # Any `model:` at all. Upstream picks models for Claude Code, which names no
  # provider this setup has - and frontmatter wins over opencode.jsonc, so a
  # value left here would silently override the per-agent model set there.
  # Dropping it makes opencode.jsonc the only place models are chosen.
  /^model[ \t]*:/d
}
