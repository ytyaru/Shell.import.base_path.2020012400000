#!/usr/bin/env bash
Run() {
	. "$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/__commons.sh"
	for file in "$@"; do {
		local prefix="$(Prefix "$file")"
		local srcfile="$(SourceFile "$file")"
		local funcs="$(ListupFunctions "$srcfile")"
		. "$srcfile"
		for func in $(echo -e "$funcs"); do {
			RenameFunction "$func" "$prefix$func"
		} done
	} done;
}
Run "$@"
