ShowHead() { echo "===== ${FUNCNAME[1]} ====="; }
TestImports() {
	ShowHead
	. ./imports.sh lib.sh sub/lib2.sh 'sub/su b/li b3.sh'
	#MyLib
	lib.MyLib
	lib.MyLibA
	sub.lib2.MyLib2
	sub.su-b.li-b3.MyLib3
	unset -f lib.MyLib; unset -f lib.MyLibA; unset -f sub.lib2.MyLib2; unset -f sub.su-b.li-b3.MyLib3;
}
TestImport() {
	ShowHead
	. ./import.sh lib.sh 
	lib.MyLib
	lib.MyLibA
	. ./import.sh sub/lib2.sh
	sub.lib2.MyLib2
	. ./import.sh 'sub/su b/li b3.sh'
	sub.su-b.li-b3.MyLib3
}
TestImportAliasPrefixShallow() {
	ShowHead
	. ./import.sh lib.sh as L
	L.MyLib
	L.MyLibA
	. ./import.sh sub/lib2.sh as L2
	L2.MyLib2
	. ./import.sh 'sub/su b/li b3.sh' as L3
	L3.MyLib3
}
TestImportAliasPrefixDeep() {
	ShowHead
	. ./import.sh lib.sh as A.B.C
	A.B.C.MyLib
	A.B.C.MyLibA
	. ./import.sh sub/lib2.sh as A.B.C
	A.B.C.MyLib2
	. ./import.sh 'sub/su b/li b3.sh' as A.B.C
	A.B.C.MyLib3
}
TestImportPartialPrefix0() {
	ShowHead
	. ./import.sh lib.sh -0
	MyLib
	MyLibA
	. ./import.sh sub/lib2.sh -0
	MyLib2
	. ./import.sh 'sub/su b/li b3.sh' -0
	MyLib3
	. ./import.sh 'sub/su b/sub4/lib4.sh' -0
	MyLib4
}
TestImportPartialPrefix1() {
	ShowHead
	. ./import.sh lib.sh -1
	lib.MyLib
	lib.MyLibA
	. ./import.sh sub/lib2.sh -1
	lib2.MyLib2
	. ./import.sh 'sub/su b/li b3.sh' -1
	li-b3.MyLib3
	. ./import.sh 'sub/su b/sub4/lib4.sh' -1
	lib4.MyLib4
}
TestImportPartialPrefix2() {
	ShowHead
	. ./import.sh lib.sh -2
	lib.MyLib
	lib.MyLibA
	. ./import.sh sub/lib2.sh -2
	sub.lib2.MyLib2
	. ./import.sh 'sub/su b/li b3.sh' -2
	su-b.li-b3.MyLib3
	. ./import.sh 'sub/su b/sub4/lib4.sh' -2
	sub4.lib4.MyLib4
}
TestImportPartialPrefix3() {
	ShowHead
	. ./import.sh lib.sh -3
	lib.MyLib
	lib.MyLibA
	. ./import.sh sub/lib2.sh -3
	sub.lib2.MyLib2
	. ./import.sh 'sub/su b/li b3.sh' -3
	sub.su-b.li-b3.MyLib3
	. ./import.sh 'sub/su b/sub4/lib4.sh' -3
	su-b.sub4.lib4.MyLib4
}
TestImportPartialPrefix4() {
	ShowHead
	. ./import.sh lib.sh -4
	lib.MyLib
	lib.MyLibA
	. ./import.sh sub/lib2.sh -4
	sub.lib2.MyLib2
	. ./import.sh 'sub/su b/li b3.sh' -4
	sub.su-b.li-b3.MyLib3
	. ./import.sh 'sub/su b/sub4/lib4.sh' -4
	sub.su-b.sub4.lib4.MyLib4
}
TestImportsBASH_IMPORT_DIR_set_env() {
	ShowHead
	BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages" . ./imports.sh lib.sh sub/lib2.sh 'sub/su b/li b3.sh' 'sub/su b/sub4/lib4.sh'
	lib.F1
	lib.F2
	sub.lib2.F1
	sub.su-b.li-b3.F1
	sub.su-b.sub4.lib4.F1
}
TestImportsBASH_IMPORT_DIR_export() {
	ShowHead
	export BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages"
	. ./imports.sh lib.sh sub/lib2.sh 'sub/su b/li b3.sh'
	lib.F1
	lib.F2
	sub.lib2.F1
	sub.su-b.li-b3.F1
	sub.su-b.sub4.lib4.F1
	unset BASH_IMPORT_DIR
}
TestImportBASH_IMPORT_DIR_set_env() {
	ShowHead
	BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages" . ./import.sh lib.sh
	lib.F1
	lib.F2
	unset -f lib.F1 lib.F2
	BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages" . ./import.sh sub/lib2.sh
	sub.lib2.F1
	unset -f sub.lib2.F1
	BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages" . ./import.sh 'sub/su b/li b3.sh'
	sub.su-b.li-b3.F1
	unset -f sub.su-b.li-b3.F1
	BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages" . ./import.sh 'sub/su b/sub4/lib4.sh'
	sub.su-b.sub4.lib4.F1
	unset -f sub.su-b.sub4.lib4.F1
}
TestImportBASH_IMPORT_DIR_export() {
	ShowHead
	export BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages"
	. ./import.sh lib.sh
	lib.F1
	lib.F2
	. ./import.sh sub/lib2.sh
	sub.lib2.F1
	. ./import.sh 'sub/su b/li b3.sh'
	sub.su-b.li-b3.F1
	. ./import.sh 'sub/su b/sub4/lib4.sh'
	sub.su-b.sub4.lib4.F1
	unset BASH_IMPORT_DIR
}
TestImportBASH_IMPORT_DIR_AliasPrefixShallow() {
	ShowHead
	export BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages"
	. ./import.sh lib.sh as L
	L.F1
	L.F2
	. ./import.sh sub/lib2.sh as L2
	L2.F1
	. ./import.sh 'sub/su b/li b3.sh' as L3
	L3.F1
	. ./import.sh 'sub/su b/sub4/lib4.sh' as L4
	L4.F1
	unset BASH_IMPORT_DIR
}
TestImportBASH_IMPORT_DIR_AliasPrefixDeep() {
	ShowHead
	export BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages"
	. ./import.sh lib.sh as A.B.C
	A.B.C.F1
	A.B.C.F2
	. ./import.sh sub/lib2.sh as D.E.F
	D.E.F.F1
	. ./import.sh 'sub/su b/li b3.sh' as G.H.I
	G.H.I.F1
	. ./import.sh 'sub/su b/sub4/lib4.sh' as J.K.L
	J.K.L.F1
	unset BASH_IMPORT_DIR
}
TestImportBASH_IMPORT_DIR_PartialPrefix0() {
	ShowHead
	export BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages"
	. ./import.sh lib.sh -0
	F1
	F2
	unset -f F1 F2
	. ./import.sh sub/lib2.sh -0
	F1
	unset -f F1
	. ./import.sh 'sub/su b/li b3.sh' -0
	F1
	unset -f F1
	. ./import.sh 'sub/su b/sub4/lib4.sh' -0
	F1
	unset -f F1
	unset BASH_IMPORT_DIR
}
TestImportBASH_IMPORT_DIR_PartialPrefix1() {
	ShowHead
	export BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages"
	. ./import.sh lib.sh -1
	lib.F1
	lib.F2
	. ./import.sh sub/lib2.sh -1
	lib2.F1
	. ./import.sh 'sub/su b/li b3.sh' -1
	li-b3.F1
	. ./import.sh 'sub/su b/sub4/lib4.sh' -1
	lib4.F1
	unset BASH_IMPORT_DIR
}
TestImportBASH_IMPORT_DIR_PartialPrefix2() {
	ShowHead
	export BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages"
	. ./import.sh lib.sh -2
	lib.F1
	lib.F2
	. ./import.sh sub/lib2.sh -2
	sub.lib2.F1
	. ./import.sh 'sub/su b/li b3.sh' -2
	su-b.li-b3.F1
	. ./import.sh 'sub/su b/sub4/lib4.sh' -2
	sub4.lib4.F1
	unset BASH_IMPORT_DIR
}
TestImportBASH_IMPORT_DIR_PartialPrefix3() {
	ShowHead
	export BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages"
	. ./import.sh lib.sh -3
	lib.F1
	lib.F2
	. ./import.sh sub/lib2.sh -3
	sub.lib2.F1
	. ./import.sh 'sub/su b/li b3.sh' -3
	sub.su-b.li-b3.F1
	. ./import.sh 'sub/su b/sub4/lib4.sh' -3
	su-b.sub4.lib4.F1
	unset BASH_IMPORT_DIR
}
TestImportBASH_IMPORT_DIR_PartialPrefix4() {
	ShowHead
	export BASH_IMPORT_DIR="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/packages"
	. ./import.sh lib.sh -4
	lib.F1
	lib.F2
	. ./import.sh sub/lib2.sh -4
	sub.lib2.F1
	. ./import.sh 'sub/su b/li b3.sh' -4
	sub.su-b.li-b3.F1
	. ./import.sh 'sub/su b/sub4/lib4.sh' -4
	sub.su-b.sub4.lib4.F1
	unset BASH_IMPORT_DIR
}
TestImportsAbs() {
	ShowHead
	local abs="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/abs"
	local absd="${abs//\//.}"; local absd="${absd// //-}"; absd="${absd:1:${#absd}}"
	. ./imports.sh "$abs/lib.sh" "$abs/sub/lib2.sh" "$abs/sub/su b/li b3.sh" "$abs/sub/su b/sub4/lib4.sh"
	echo "\$abs: $abs"
	echo "\$absd: $absd"
	#${absd}.A1
	${absd}.lib.A1
	${absd}.lib.A2
	${absd}.sub.lib2.A1
	${absd}.sub.su-b.li-b3.A1
}
TestImportAbs() {
	ShowHead
	local abs="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/abs"
	local absd="${abs//\//.}"; local absd="${absd// //-}"; absd="${absd:1:${#absd}}"
	. ./import.sh "$abs/lib.sh"
	${absd}.lib.A1
	${absd}.lib.A2
	. ./import.sh "$abs/sub/lib2.sh"
	${absd}.sub.lib2.A1
	. ./import.sh "$abs/sub/su b/li b3.sh"
	${absd}.sub.su-b.li-b3.A1
}
TestImportAbsAliasPrefixShallow() {
	ShowHead
	local abs="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/abs"
	local absd="${abs//\//.}"; local absd="${absd// //-}"; absd="${absd:1:${#absd}}"
	. ./import.sh "$abs/lib.sh" as L
	L.A1
	L.A2
	. ./import.sh "$abs/sub/lib2.sh" as L2
	L2.A1
	. ./import.sh "$abs/sub/su b/li b3.sh" as L3
	L3.A1
}
TestImportAbsAliasPrefixDeep() {
	ShowHead
	local abs="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/abs"
	local absd="${abs//\//.}"; local absd="${absd// //-}"; absd="${absd:1:${#absd}}"
	. ./import.sh "$abs/lib.sh" as A.B.C
	A.B.C.A1
	A.B.C.A2
	unset -f A.B.C.A1 A.B.C.A2
	. ./import.sh "$abs/sub/lib2.sh" as A.B.C
	A.B.C.A1
	unset -f A.B.C.A1
	. ./import.sh "$abs/sub/su b/li b3.sh" as A.B.C
	A.B.C.A1
	unset -f A.B.C.A1
}
TestImportAbsPartialPrefix0() {
	ShowHead
	local abs="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/abs"
	local absd="${abs//\//.}"; local absd="${absd// //-}"; absd="${absd:1:${#absd}}"
	. ./import.sh "$abs/lib.sh" -0
	A1
	unset -f A1
	. ./import.sh "$abs/sub/lib2.sh" -0
	A1
	unset -f A1
	. ./import.sh "$abs/sub/su b/li b3.sh" -0
	A1
	unset -f A1
	. ./import.sh "$abs/sub/su b/sub4/lib4.sh" -0
	A1
	unset -f A1
}
TestImportAbsPartialPrefix1() {
	ShowHead
	local abs="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/abs"
	local absd="${abs//\//.}"; local absd="${absd// //-}"; absd="${absd:1:${#absd}}"
	. ./import.sh "$abs/lib.sh" -1
	lib.A1
	. ./import.sh "$abs/sub/lib2.sh" -1
	lib2.A1
	. ./import.sh "$abs/sub/su b/li b3.sh" -1
	li-b3.A1
	. ./import.sh "$abs/sub/su b/sub4/lib4.sh" -1
	lib4.A1
}
TestImportAbsPartialPrefix2() {
	ShowHead
	local abs="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/abs"
	local absd="${absd// //-}"; absd="${absd:1:${#absd}}"; absd=( ${abs//\// } ); #absd="$(IFS='.'; echo "${absd[*]}")"
	Join() { a=( "$@" ); echo "$(IFS='.'; echo "${a[*]}")"; }
	echo "absd: $absd"
	. ./import.sh "$abs/lib.sh" -2
	$(Join "${absd[@]:-1:1}").lib.A1
	. ./import.sh "$abs/sub/lib2.sh" -2
	sub.lib2.A1
	. ./import.sh "$abs/sub/su b/li b3.sh" -2
	su-b.li-b3.A1
	. ./import.sh "$abs/sub/su b/sub4/lib4.sh" -2
	sub4.lib4.A1
}
TestImportAbsPartialPrefix3() {
	ShowHead
	local abs="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/abs"
	local absd="${absd// //-}"; absd="${absd:1:${#absd}}"; absd=( ${abs//\// } ); #absd="$(IFS='.'; echo "${absd[*]}")"
	Join() { a=( "$@" ); echo "$(IFS='.'; echo "${a[*]}")"; }
	. ./import.sh "$abs/lib.sh" -3
	$(Join "${absd[@]:-2:2}").lib.A1
	. ./import.sh "$abs/sub/lib2.sh" -3
	$(Join "${absd[@]:-1:1}").sub.lib2.A1
	. ./import.sh "$abs/sub/su b/li b3.sh" -3
	sub.su-b.li-b3.A1
	. ./import.sh "$abs/sub/su b/sub4/lib4.sh" -3
	su-b.sub4.lib4.A1
}
TestImportAbsPartialPrefix4() {
	ShowHead
	local abs="$(cd "$(dirname "${BASH_SOURCE:-0}")"; pwd)/abs"
	local absd="${absd// //-}"; absd="${absd:1:${#absd}}"; absd=( ${abs//\// } ); #absd="$(IFS='.'; echo "${absd[*]}")"
	Join() { a=( "$@" ); echo "$(IFS='.'; echo "${a[*]}")"; }
	. ./import.sh "$abs/lib.sh" -4
	$(Join "${absd[@]:-3:3}").lib.A1
	. ./import.sh "$abs/sub/lib2.sh" -4
	$(Join "${absd[@]:-2:2}").sub.lib2.A1
	. ./import.sh "$abs/sub/su b/li b3.sh" -4
	$(Join "${absd[@]:-1:1}").sub.su-b.li-b3.A1
	. ./import.sh "$abs/sub/su b/sub4/lib4.sh" -4
	sub.su-b.sub4.lib4.A1
}
CallTestRelativePath() {
	TestImports
	CallImport() {
		TestImport
		TestImportAliasPrefixShallow
		TestImportAliasPrefixDeep
		TestImportPartialPrefix0
		TestImportPartialPrefix1
		TestImportPartialPrefix2
		TestImportPartialPrefix3
		TestImportPartialPrefix4
	}
	CallImport
}
CallTestBASH_IMPORT_DIR() {
	TestImportsBASH_IMPORT_DIR_set_env
	TestImportsBASH_IMPORT_DIR_export
	CallImport() {
		TestImportBASH_IMPORT_DIR_set_env
		TestImportBASH_IMPORT_DIR_export
		TestImportBASH_IMPORT_DIR_AliasPrefixShallow
		TestImportBASH_IMPORT_DIR_AliasPrefixDeep
		TestImportBASH_IMPORT_DIR_PartialPrefix0
		TestImportBASH_IMPORT_DIR_PartialPrefix1
		TestImportBASH_IMPORT_DIR_PartialPrefix2
		TestImportBASH_IMPORT_DIR_PartialPrefix3
		TestImportBASH_IMPORT_DIR_PartialPrefix4
	}
	CallImport
}
CallTestAbsolutePath() {
	TestImportsAbs
	CallImport() {
		TestImportAbs
		TestImportAbsAliasPrefixShallow
		TestImportAbsAliasPrefixDeep
		TestImportAbsPartialPrefix0
		TestImportAbsPartialPrefix1
		TestImportAbsPartialPrefix2
		TestImportAbsPartialPrefix3
		TestImportAbsPartialPrefix4
	}
	CallImport
}
CallTestRelativePath
CallTestBASH_IMPORT_DIR
CallTestAbsolutePath

