#!/usr/bin/env bash
SelfPath() { echo "$(__Join "$(SelfParent)" "$(SelfName)")"; }
SelfParent() { echo "$(__Parent "${BASH_SOURCE:-0}")"; }
SelfName() { echo "$(__Name "${BASH_SOURCE:-0}")"; }
SelfExt() { echo "$(__Ext "${BASH_SOURCE:-0}")"; }
SelfNameId() { echo "$(__NameId "${BASH_SOURCE:-0}")"; } # WithoutExt
CallerPath() { echo "$(__Join "$(CallerParent)" "$(CallerName)")"; }
CallerParent() { echo "$(__Parent "$0")"; }
CallerName() { echo "$(__Name "$0")"; }
CallerExt() { echo "$(__Ext "$0")"; }
CallerNameId() { echo "$(__NameId "$0")"; } # WithoutExt
__Join() { args=("$@"); echo "$(IFS="${args[0]}"; echo "${args[*]:1:${#args[@]}}")"; }
__Parent() { echo "$(cd "$(dirname "$1")"; pwd)"; }
__Name() { echo "$(basename "$1")"; }
__Ext() { local n="$(__Name "$1")"; echo "${n##*.}"; }
__NameId() { local n="$(__Name "$1")"; echo "${n%.*}"; }
ListupFunctions() {
	for file in "$@"; do (
		env -i bash -c '. '"'""$file""'"'; echo "$(declare -F -p | cut -d " " -f 3)";'
	) done
}
RenameFunction() { # $1:old_func_name, $2:new_func_name
	[ "$1" = "$2" ] && return;
	declare -F "$1" > /dev/null || return 1
	eval "$(echo "${2}()"; declare -f ${1} | tail -n +2)"
	unset -f "$1"
}
SourceFile() {
	BaseDir() {
	#	IsRelativePath() { [[ "$1" =~ ^\./.*$ ]] || [[ "$1" =~ ^\.\./.*$ ]]; } 
		IsRelativePath() { [[ "$1" =~ ^\./.*$ ]]; }
		IsAbsolutePath() { [[ "$1" =~ ^/.*$ ]]; }
		IsRelativePath "$1" && { echo "$(CallerParent)"; return; }
		IsAbsolutePath "$1" && { echo ''; return; }
		echo "${BASH_IMPORT_DIR:-$(CallerParent)}"
	}
	RemoveRelativePrefix() { [ './' = "$1" ] && echo "${1:2:${#1}}" || echo "$1"; }
	local base="$(BaseDir "$1")"
	[ -n "$base" ] && echo "${base%/}/$(RemoveRelativePrefix "$1")" || echo "$1" 
}
Prefix() { # augs:$@ pattern1: import a.sh, pattern2: import a.sh as alias, pattern3: import sub/sub1/a.sh 1
	IsInt() { test 0 -eq $1 > /dev/null 2>&1 || expr $1 + 0 > /dev/null 2>&1; }
	# https://stackoverflow.com/questions/15226720/bash-regex-to-match-dots-and-characters
	IsAliasPrefix() { test 2 -le $# -a 'as' = "$1" && [[ "$2" =~ ^[-a-zA-Z0-9_.]+$ ]]; }
	IsPartialPrefix() { test '-' = "${1:0:1}" && $(IsInt "${1:1:${#1}}"); }
	local SEP='/'; local DOT='.'; local SPACE=' '; local SPACE_TO='-';
	__SlashToDot() { echo "${1//$SEP/$DOT}"; }
	__SpaceToHyphen() { echo "${1//$SPACE/$SPACE_TO}"; }
	__AppendDot() { [ -n "$1" ] && echo "$1$DOT" || echo "$1"; }
	__Abs() { [ 0 -gt $1 ] && echo "$(($1 * -1))" || echo "$1"; }
	DirName() {
		InChar() { [ "`echo $1 | grep $2`" ] ; }
		InSlash() { InChar "$1" '/'; }
		IsShFile() { [[ "$1" = *\.sh ]]; }
		IsDirAndFile() { IsShFile "$1" && InSlash "$1"; }
		IsFileOnly() { IsShFile "$1" && ! InSlash "$1"; }
		local dir_names="$1"
		IsDirAndFile "$1" && dir_names="$(dirname "$dir_names")"
		IsFileOnly "$1" && dir_names=''
		[ '/' = "${dir_names:0:1}" ] && dir_names="${dir_names:1:${#dir_names}}"
		[ '.' = "$dir_names" ] && dir_names=''
		dir_names="$(__SlashToDot "$(__SpaceToHyphen "$dir_names")")"
		echo "$(__AppendDot "$dir_names")"
	}
	FileName() {
		local filename="$(__SpaceToHyphen "$(__NameId "$1")")"
		echo "$(__AppendDot "$filename")"
	}
	PartialPrefix() {
		local path="$1"; local prefix_depth="$(__Abs "$2")";
		[ 0 -eq $prefix_depth ] && { echo ''; return; }
		[ 1 -eq $prefix_depth ] && { echo "$(FileName "$1")"; return; }
		local dir_names="$(DirName "$1")"
		dir_names="${dir_names:0:${#dir_names}}"
		dir_names=( ${dir_names//$DOT/$SPACE} )
		local len=$(( $prefix_depth - 1 ))
		[ $len -ge ${#dir_names[@]} ] && { echo "$(DirName "$1")$(FileName "$1")"; return; }
		local idx=$(( ($len     ) * -1 ))
		targets=( ${dir_names[@]:$idx:$len} )
		targets+=( $(FileName "$1") )
		echo "$(IFS=$DOT; echo "${targets[*]}")"
	}
	FullPrefix() { echo "$(DirName "$1")$(FileName "$1")"; }
	IsAliasPrefix "${@:2:$#}" && { echo "$(__AppendDot "$3")"; return; }
	IsPartialPrefix "$2" && { echo "$(PartialPrefix "$1" "$2")"; return; }
	echo "$(FullPrefix "$1")"
}
