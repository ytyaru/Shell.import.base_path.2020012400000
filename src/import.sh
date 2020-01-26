#!/usr/bin/env bash
Run() {
	. "$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/__commons.sh"
	local srcfile="$(SourceFile "$1")"
	local prefix="$(Prefix "$@")"
	local funcs="$(ListupFunctions "$srcfile")"
	. "$srcfile"
	for func in $(echo -e "$funcs"); do {
		RenameFunction "$func" "$prefix$func"
	} done
}
Run "$@"
