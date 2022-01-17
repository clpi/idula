# vim: set ft=make :

alias G  := git-push
alias b  := build
alias r  := run
alias i  := init
alias c  := compile

output_dir:="./"

default: build run test_file_parse

run:
	echo "\x1b[33;1m ->\x1b0m  \x1b[32m BUILD!"
	zig build run -- $HOME/p/z/il/res/is/build.is

test_file_parse:
	echo "\x1b[33;1m ->\x1b0m  \x1b[32m BUILD!"
	zig test ./src/

build:
	echo "\x1b[33;1m ->\x1b0m  \x1b[32m BUILD!"
	zig build

init:
	echo "\x1b[33;1m ->\x1b0m  \x1b[32m Init!\x1b[0m Run the init cmd to tet package setup"
	mkdir "testdir" && cd "$_"
	zig build run -- init "new-proj"
	zig build run -- init               # -> shoudl produce project in the current working directory
	

compile:
	echo "\x1b[33;1m ->\x1b0m  \x1b[32m BUILD!"
	zig build

publish_wapm:
	echo ""

publish:
	echo ""

git-push:
	echo ""

install:
	echo "Installing the idula ecosystem:"

daemon:
	echo "Daemonize the idula background process"
