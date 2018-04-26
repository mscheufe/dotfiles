#!/usr/bin/env bash

# write; clear and read history from HISTFILE
wcr_hist() { history -a; history -c; history -r; }

# clear .bash_history
clear_history() { echo /dev/null >.bash_history; }

# ql: Opens any file in MacOS Quicklook Preview
ql() { qlmanage -p "$*" >& /dev/null; }

# cdf:  'Cd's to frontmost window of MacOS Finder
cdf() {
    currFolderPath=$( /usr/bin/osascript <<EOT
    tell application "Finder"
        try
            set currFolder to (folder of the front window as alias)
        on error
            set currFolder to (path to desktop folder as alias)
        end try
        POSIX path of currFolder
    end tell
EOT
    )
    echo "cd to \"$currFolderPath\""
    cd "$currFolderPath" || exit 1
}

# start nvim-qt with all arguments considered to be files
gnvim() {
    local _files=()
    for f in "$@"
    do
        [[ -f $f || -d $f ]] && printf -v "_files[i++]" "%s" "$(realpath "$f")"
    done
    open -n -a /usr/local/bin/nvim-qt --args --qwindowgeometry 970x650+150+50  -- "${_files[@]}"
}

# Change iterm2 profile. Usage it2prof ProfileName (case sensitive)
it2prof() { echo -e "\\033]50;SetProfile=$1\\a"; }

# create tags file for perl
create_tags() {
    local lang=
    lang=${1:?"Please provide argument (perl), exiting"}
    if [[ $lang == perl ]]; then
        if [[ -n $PERLBREW_PERL ]]; then
            local cwd="$PWD"
            cd >/dev/null || return 1
            local tagfile=${HOME}/.tags/perl/tags
            local perlbrew_lib="$PERLBREW_ROOT/perls/${PERLBREW_PERL}/lib"
            local perlbrew_default="${PERLBREW_PATH%%bin:*}lib"
            ctags --extra=q --languages=Perl --langmap=Perl:+.t "$perlbrew_default" "$perlbrew_lib"
            [[ ! -d ${tagfile%tags} ]] && mkdir -p "${tagfile%tags}"
            mv tags "$tagfile"
            cd "$cwd" || return 1
        else
            echo "No active perlbrew environment found, nothing to do"
            return 1
        fi
    else
        echo "Creating tags for language \"$lang\" not supproted, exiting"
        return 1
    fi
    return 0
}
