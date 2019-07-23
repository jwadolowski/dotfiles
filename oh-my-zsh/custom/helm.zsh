# https://github.com/kubernetes/kubernetes/issues/59078#issuecomment-363384825

function helm() {
    if ! type __start_doctl >/dev/null 2>&1; then
        source <(command helm completion zsh)
    fi

    command helm "$@"
}
