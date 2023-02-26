# Prefer coreutils binaries over built-in macOS ones
export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

# Add gnu-sed to the PATH
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:${PATH}"

# Add GNU grep to the PATH
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

# Prefer curl installed via brew
export PATH="/usr/local/opt/curl/bin:${PATH}"

# https://github.com/Homebrew/homebrew-core/issues/14669#issuecomment-353399229
export PATH="/usr/local/sbin:${PATH}"

# Use node.js 16 by default
export PATH="/usr/local/opt/node@16/bin:$PATH"
