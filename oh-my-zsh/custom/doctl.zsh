# https://github.com/kubernetes/kubernetes/issues/59078#issuecomment-363384825

function doctl() {
    if ! type __start_doctl >/dev/null 2>&1; then
        source <(command doctl completion zsh)
    fi

    command doctl "$@"
}
