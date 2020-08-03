# eval "$(chef shell-init zsh)"
#
# ^ that's ridiculously slow, so let's use pre-rendered version instead

export PATH="/opt/chef-workstation/bin:${HOME}/.chefdk/gem/ruby/2.7.0/bin:/opt/chef-workstation/embedded/bin:${PATH}:/opt/chef-workstation/gitbin"
export GEM_ROOT="/opt/chef-workstation/embedded/lib/ruby/gems/2.7.0"
export GEM_HOME="${HOME}/.chefdk/gem/ruby/2.7.0"
export GEM_PATH="${HOME}/.chefdk/gem/ruby/2.7.0:/opt/chef-workstation/embedded/lib/ruby/gems/2.7.0"
function _chef() {

  local -a _1st_arguments
  _1st_arguments=(
      'exec:Runs the command in context of the embedded ruby'
      'env:Prints environment variables used by Chef Workstation'
      'gem:Runs the `gem` command in context of the embedded Ruby'
      'generate:Generate a new repository, cookbook, or other component'
      'shell-init:Initialize your shell to use Chef Workstation as your primary Ruby'
      'install:Install cookbooks from a Policyfile and generate a locked cookbook set'
      'update:Updates a Policyfile.lock.json with latest run_list and cookbooks'
      'push:Push a local policy lock to a policy group on the Chef Infra Server'
      'push-archive:Push a policy archive to a policy group on the Chef Infra Server'
      'show-policy:Show policyfile objects on the Chef Infra Server'
      'diff:Generate an itemized diff of two Policyfile lock documents'
      'export:Export a policy lock as a Chef Infra Zero code repo'
      'clean-policy-revisions:Delete unused policy revisions on the Chef Infra Server'
      'clean-policy-cookbooks:Delete unused policyfile cookbooks on the Chef Infra Server'
      'delete-policy-group:Delete a policy group on the Chef Infra Server'
      'delete-policy:Delete all revisions of a policy on the Chef Infra Server'
      'undelete:Undo a delete command'
      'describe-cookbook:Prints cookbook checksum information used for cookbook identifier'
      'provision:Provision VMs and clusters via cookbook'
    )

  _arguments \
    '(-v --version)'{-v,--version}'[version information]' \
    '*:: :->subcmds' && return 0

  if (( CURRENT == 1 )); then
    _describe -t commands "chef subcommand" _1st_arguments
    return
  fi
}

compdef _chef chef
