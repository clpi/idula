#compdef idl

function _idl {
    local -a __subcommands
    local line state

    __subcommands=(
	"build:Build an Idla project or file"
	"init:Initialize a new project or workspace"
    )

    _arguments -C \
	"1: :->subcommand" \
	"*::arg:-> args"

}
