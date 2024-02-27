# -----------------------------------------------------------------------------
# Brew-provided binaries
# -----------------------------------------------------------------------------
BREW_PREFIX=$(brew --prefix)

# Prefer coreutils binaries over built-in macOS ones
export PATH="${BREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH}"

# Add gnu-sed to the PATH
export PATH="${BREW_PREFIX}/opt/gnu-sed/libexec/gnubin:${PATH}"

# Add GNU grep to the PATH
export PATH="${BREW_PREFIX}/opt/grep/libexec/gnubin:${PATH}"

# Add GNU find to the PATH
export PATH="${BREW_PREFIX}/opt/findutils/libexec/gnubin:$PATH"

# Prefer curl installed via brew
export PATH="${BREW_PREFIX}/opt/curl/bin:${PATH}"

# https://github.com/Homebrew/homebrew-core/issues/14669#issuecomment-353399229
export PATH="${BREW_PREFIX}/sbin:${PATH}"

# -----------------------------------------------------------------------------
# Local binaries
# -----------------------------------------------------------------------------
export PATH="${HOME}/bin:${PATH}"

# -----------------------------------------------------------------------------
# Golang
# -----------------------------------------------------------------------------
export GOPATH="${HOME}/go"
export PATH="${GOPATH}/bin:${PATH}"
