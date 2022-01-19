PROJECT_NAME=idleset
LLVM_SRC_ROOT=$(cwd)/out/llvm/src/
LLVM_OBJ_ROOT=$(cwd)/out/llvm/obj/
PROJ_SRC_ROOT=$(CWD)
PROJ_OBJ_ROOT=$(CWD)/out/obj/
PROJ_INSTALL_ROOT=$(CWD)/out
LEVEL=


# .DEFAULT_GOAL := set-out-dir zig zig-init-newdir zig-init-samedir build-c build-cpp -build-rust build-nim
default: set-out-dir zig zig-init-newdir zig-init-samedir build-c build-cpp -build-rust build-nim

# default: set-out-dir zig zig-init-newdir zig-init-samedir build-c build-cpp -build-rust build-nim

SHELL := zsh
.ONESHELL :
.SHELLFLAGS := -eu -o pipefall -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
CC = zig cc
C++ = zig c++

CFLAGS = -g -Wall
NIMOPTS = "--threads:on --opt:speed --backend C"

ifeq (0, ${MAKELEVEL})
     arch := $(shell arch)
     cwd := $(shell pwd)
endif


CWD="/Users/clp/p/z/il/"
OUT="/Users/clp/p/z/il/out/"
MFILE="$(CWD)Makefile"

CDIR="/Users/clp/p/z/il/ext/c/"
CPPDIR="/Users/clp/p/z/il/ext/c/"
NIMDIR="/Users/clp/p/z/il/ext/c/"
RUSTDIR="/Users/clp/p/z/il/crates//"

PDIR="$(CWD)proj/"
WDIR="$(CWD)workspace/"
# NOTE: What prefixes all commands issued to the IDL CLI
idl="zig build run -- "





# NOTE: Just tests to see if idl run works fine
zig:
	zig build run -- 
	zig build run -- run "$(CWD)Makefile"
	mkdir -p $(PDIR)

# NOTE: Toggles the "bench" flag and tests specifically notable files
zig-bench:
	zig build run -- 
	zig build run -- run "$(CWD)Makefile"
	mkdir -p $(PDIR)

# NOTE: Performs all tests within the src/ zig dir
zig-test-all:
	zig build run -- 
	zig build run -- run "$(CWD)Makefile"
	mkdir -p $(PDIR)

# NOTE: Tests to see if idl init properly generates project layout
zig-init-newdir:
	zig build run -- init $(PDIR) # -> should cd into the pdir
	exa --icons
	rm -rf $(PDIR)

# NOTE: Tests to see if idl init properly generates project layout with no specified dir (ie. cwd)
zig-init-samedir:
	mkdir -p $(PWD) && cd $(PWD)
	zig build run -- init  # should have same #(PWD as pwd
	exa --icons
	cd $(CWD) && rm -rf $(PWD)

# NOTE: Compiles C files and puts into output folder
build-c:
	cd /Users/clp/p/z/il/ext/c/
	zig cc './main.c' -o ."../../out/"

build-cpp:
	cd /Users/clp/p/z/il/ext/cpp/
	zig c++ './main.c' -o ."../../out/"

build-nim:
	cd /Users/clp/p/z/il/ext/nim/
	nim c --out:"../../out/" $(CWD)

build-rust:
	cargo build --release
	cp -r $(CWD)/crates/

target:
	<tab> fzf

set-out-dir:
	mkdir -p $(cwd)/out/pkg
	mkdir -p $(cwd)/out/lib
	mkdir -p $(cwd)/out/etc
	mkdir -p $(CWD)/out/obj
	mkdir -p $(cwd)/llvm/src
	mkdir -p $(cwd)/llvm/obj

gitpush:
	git add --a 
	git commit -m "Adding more changes"
	git push gh master

g-dev:
	git switch -b dev
g-prod:
	git switch -b prod


	
# Chris P, January 17, 2022
# Trying out Cmake for, basically, the first time. 
#
# Makefile for Idula
