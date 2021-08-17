# -----------------------------------------------------------------------------
# Gradle wrapper utils
# -----------------------------------------------------------------------------
function __gradle_cmd() {
    local default_gradle_cmd="$(pwd)/gradlew"

    if [[ ! -x $default_gradle_cmd ]]; then
        default_gradle_cmd="$(git rev-parse --show-toplevel)/gradlew"
    fi

    gradle_cmd=$default_gradle_cmd
}

function __gradle_build_file() {
    local default_build_file_name="build.gradle"

    local default_build_file="$(pwd)/$default_build_file_name"
    if [[ ! -f $default_build_file ]]; then
        default_build_file="$(pwd)/build.gradle.kts"
    fi

    gradle_build_file=$default_build_file
}

function __gradle_cache_dir() {
    gradle_cache_dir="$(pwd)/.gradle/completion"
}

function __gradle_cache_name() {
    gradle_cache_name="main"
}

function __gradle_checksum_file_path() {
    __gradle_cache_dir
    __gradle_cache_name

    gradle_checksum_file_path="$gradle_cache_dir/${gradle_cache_name}.md5"
}

function __gradle_task_file_path() {
    __gradle_cache_dir
    __gradle_cache_name

    gradle_task_file_path="$gradle_cache_dir/${gradle_cache_name}.tasks"
}

function __gradle_init_cache() {
    __gradle_cache_dir
    mkdir -p $gradle_cache_dir
}

function __gradle_build_scripts() {
    gradle_build_scripts=( $(fd -t f "\.gradle(\.kts)?" $(pwd)) )
}

function __gradle_generate_checksum_file() {
    __gradle_checksum_file_path
    __gradle_build_scripts

    rm -f $gradle_checksum_file_path

    for script in $gradle_build_scripts; do
        md5sum $script >> $gradle_checksum_file_path
    done
}

function __gradle_generate_task_file() {
    __gradle_cmd
    __gradle_build_file
    __gradle_task_file_path

    rm -f $gradle_task_file_path

    if [[ ! -z "$($gradle_cmd --status 2>/dev/null | grep IDLE)" ]]; then
        gradle_tasks_output="$($gradle_cmd --daemon --build-file $gradle_build_file --console plain -q tasks --all 2>/dev/null)"
    else
        gradle_tasks_output="$($gradle_cmd --no-daemon --build-file $gradle_build_file --console plain -q tasks --all 2>/dev/null)"
    fi

    for task_line in ${(f)"$(printf "%s\n" "${gradle_tasks_output[@]}")"}; do
        if [[ $task_line =~ ^([[:lower:]][[:alnum:][:punct:]]*)([[:space:]]-[[:space:]]([[:print:]]*))? ]]; then
            local task_name="${match[1]}"
            local task_description="${match[3]}"

            # Simple task names
            echo -e "${task_name};${task_description}" >> $gradle_task_file_path
            # Qualified task names
            echo -e ":${task_name};${task_description}" >> $gradle_task_file_path
        fi
    done
}

function gw() {
    __gradle_cmd
    __gradle_build_file
    __gradle_cache_dir
    __gradle_cache_name
    __gradle_checksum_file_path
    __gradle_task_file_path
    __gradle_init_cache
    __gradle_build_scripts

    if [[ -x $gradle_cmd ]]; then
        if [[ ! -f $gradle_checksum_file_path || ! -f $gradle_task_file_path || $(wc -l < $gradle_checksum_file_path) != ${#gradle_build_scripts[@]} ]] || ! md5sum --check $gradle_checksum_file_path --status; then
            __gradle_generate_checksum_file
            __gradle_generate_task_file
        fi

        gradle_task=$(cat $gradle_task_file_path | cut -d ';' -f 1 | fzf --layout=reverse --query="$1" --preview "grep -E '^{};' $gradle_task_file_path | cut -d ';' -f 2")
        [[ -n $gradle_task ]] && echo $gradle_task
    else
        error_log "$gradle_cmd does not exist or is not executable!"
    fi
}
