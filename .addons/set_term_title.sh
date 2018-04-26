#!/usr/bin/env bash

# reverse a path string
# /dir0/dir1/dir2 => dir2\\ndir1\\ndir0\\n
reverse_path() {
    [[ -n ${1##*/} ]] && echo -en "${1##*/}\\n"
    [[ -z "${1%/*}" ]] && return 1
    reverse_path "${1%/*}"
}

trim_path() {
    local _max=$1; shift
	local _cnt=0
	while read -r _dir; do
		((_cnt++))
		if (( _cnt <= _max )); then
			_trimmed="/$_dir$_trimmed"
		else
			_trimmed="...$_trimmed"
			break
		fi
	done < <(reverse_path "$*")
	echo "$_trimmed"
}

format_path() {
	case "$PWD" in
	$HOME)
		echo "~"
		;;
	$HOME/*)
        local _path
		_path="$(trim_path "$PROMPT_DIRTRIM" "${PWD/$HOME/}")"
        [[ "$_path" == ...* ]] && echo "~/$_path"
        [[ "$_path" == /* ]] && echo "~$_path"
		;;
	*)
		trim_path "$PROMPT_DIRTRIM" "$PWD"
		;;
	esac
}

# set terminal title
set_title() {
	local _PATH=
	_PATH=$(format_path)
    [[ $ITERM_SESSION_ID ]] && echo -ne "\\033];$USER@$HOSTNAME $_PATH\\007"
    return 0
}
