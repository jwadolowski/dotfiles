# https://github.com/kubernetes/kubernetes/issues/59078#issuecomment-363384825

function kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi

    command kubectl "$@"
}
