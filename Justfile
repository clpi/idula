# vim: set ft=make :

alias G  := git-push
alias b  := build
alias r  := run
alias i  := init
alias c  := compile
alias idlang:=./src
alias idpm:=./pkg/idpm/
alias itask:=./pkg/itask/
alias logos:=./pkg/logos/
alias ispec:=./pkg/ispec/
alias ispec:=./pkg/ispec/

cwd  :="/Users/clp/p/z/il/"
out  :="/Users/clp/p/z/il/out/"
pkgs :="/Users/clp/p/z/il/"
pkgs :="/Users/clp/p/z/il/"
idown:="/Users/clp/p/z/il/pkg/idown/"
idpm :="/Users/clp/p/z/il/pkg/idpm/"
ispec:="/Users/clp/p/z/il/pkg/ispec/"
itask:="/Users/clp/p/z/il/pkg/itask/"
logos:="/Users/clp/p/z/il/pkg/itask/"
output_dir:=${{out}}

default: build run test-src build-idown build-idpm build-idspec build-itask build-logos

run package="." arch=:
	 
	@echo "\x1b[33;1mBuilding ->\x1b0m \x1b[32m {{package}} with arch {{arch}}!"

	zig build run -- $HOME/p/z/il/res/is/build.is

test-src:
	echo "\x1b[33;1m ->\x1b0m  \x1b[32m BUILD!"
	zig test ./src/

build :
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
	cargo build -p idae

build-idown:

build-idpm:

build-idspec:

build-itask:

foo:
    #!/usr/bin/env bash
    set -euxo pipefail
    hello='Yo'
    echo "$hello from Bash!"
