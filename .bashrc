# shellcheck source=/dev/null
# enable bash-completion
[[ -f "$(brew --prefix)/etc/bash_completion" ]] && source "$(brew --prefix)/etc/bash_completion"

export PROMPT_DIRTRIM=2

source "${HOME}/.addons/set_term_title.sh"
source "${HOME}/.addons/helpers.sh"
source "${HOME}/.addons/d.sh"
PROMPT_COMMAND="set_title; wcr_hist${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
source "${HOME}/.addons/bash-powerline.sh"
set -o vi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export VISUAL=nvim

# add color to ls
export CLICOLOR=1

# optional settings
shopt -s globstar

# history settings
shopt -s histappend
export HISTIGNORE="?:pwd:ls:ls -lctr:cd:history:d *:"
# ignore spaces and dups
HISTCONTROL=ignoreboth
HISTSIZE=2048
HISTFILESIZE=4096

# setup perl
[[ -f ~/perl5/perlbrew/etc/bashrc ]] && source ~/perl5/perlbrew/etc/bashrc

# setup virtualenvwrapper python3
if [[ -f /usr/local/bin/python3 && -f /usr/local/bin/virtualenvwrapper.sh ]]; then
    export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/work/venvprojects
    source /usr/local/bin/virtualenvwrapper.sh
fi

# Set default blocksize for ls, df, du
# from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
export BLOCKSIZE=1k
# add local bin directory to path
export PATH=$PATH:$HOME/bin

# aliases
alias vi=nvim
alias h=history
alias ctagit="ctags --extra=q --languages=Perl --langmap=Perl:+.t ."
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
