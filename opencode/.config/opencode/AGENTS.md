## General

Write all output in English - replies, code comments, commit messages, docs - even when
I write to you in another language. This overrides any language-matching rule elsewhere
in this file. Exception: I explicitly ask for another language.

## Web search

`websearch` tool disabled (Exa). For any web search need, use the `bx` skill
(Brave Search CLI via `bash`) instead - don't attempt `websearch` first.

## Build/test commands

Check for project-provided build/test entry points first (`Makefile`, task
runners, scripts) and prefer them over invoking compilers/test runners
directly. They usually encode the right flags, environment, and steps.

Attempt the preferred command even if dependencies might be missing. A
missing-tool error surfaces the actual requirement quickly. Fall back to
partial checks only if the preferred command fails, and report what was skipped.

## Terraform / Terragrunt

Never run `terraform init` / `tofu init` / `terragrunt init`, or anything that
triggers init implicitly (`terragrunt run-all`, `make init`, and similar
wrappers). State lives in a remote backend and init needs live credentials, so
it is not yours to run.

Anything that requires an initialized module is also off limits: `plan`,
`apply`, `destroy`, `refresh`, `import`, `validate`, `providers`, `output`,
`state *`, `show`. Do not work around this with `-backend=false`, `-upgrade`,
or by deleting `.terraform/`. Commands that work without init are fine:
`terraform fmt`, `terraform version`, `terragrunt hclfmt`. If a task genuinely
needs an initialized module, stop and ask me to run it.

Because `validate` and `providers` are off limits, registry lookup is the only
way to confirm an attribute actually exists before proposing it. The `terraform`
MCP server is wired up locally with the `registry` toolset - use it as the source
of truth instead of recalling schemas from memory: `get_provider_details`,
`get_latest_provider_version`, `search_providers` for providers, `search_modules`
and `get_module_details` for modules. All are read-only registry queries - no
state, no credentials, no cloud API calls - so run them freely without asking,
and prefer them over the `bx` skill for registry.terraform.io content.
