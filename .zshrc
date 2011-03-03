## Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac

#viキーバインド
bindkey -v

## export
# PATH
#
export PATH=/sbin:/usr/sbin:/opt/local/bin:/opt/local/sbin/:~/scripts:$PATH
export MANPATH=/opt/local/man:$MANPATH

## Default shell configuration
#
# set prompt
#
autoload colors
colors
case ${UID} in
0)
    PROMPT="%{${}%}$(echo @${HOST%%.*}) %B%{${}%}%/#%{${}%}%b "
    PROMPT2="%B%{${}%}%_#%{${}%}%b "
    SPROMPT="%B%{${}%}%r is correct? [n,y,a,e]:%{${}%}%b "
    ;;
*)
    PROMPT="%{${}%}%/%%%{${}%} "
    PROMPT2="%{${}%}%_%%%{${}%} "
    SPROMPT="%{${}%}%r is correct? [n,y,a,e]:%{${}%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="%{${}%}$(echo @${HOST%%.*}) ${PROMPT}"
    ;;
esac

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd
setopt pushd_ignore_dups          # 同ディレクトリを履歴に追加しない

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed
setopt list_types                 # 補完一覧ファイル種別表示

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt hist_reduce_blanks         # スペース排除
setopt EXTENDED_HISTORY           # zshの開始終了を記録


#履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

## Completion configuration
#
fpath=(${HOME}/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit -u

## zsh editor
#
autoload zed


## Prediction configuration
#
#autoload predict-on
#predict-off


## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
darwin*)
    export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
    alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
    alias ls="ls -G -w"
    ;;
linux*)
    export EDITOR=vim
    alias ls="ls --color"
    ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -la"

alias du="du -h"
alias df="df -h"

alias su="su -l"

alias vi="vim"
alias view="vim -R"

alias srr="screen -D -R"
#tmux
alias ta="tmux attach"
function atmux() {
    if tmux ls >/dev/null 2>&1; then
        tmux attach
    else
        tmux
    fi
}

type -p tmux >/dev/null
if [ $? -eq 0 -a -z "${TMUX}" -a -n "${SSH_CONNECTION}" -a ${TERM} -ne "screen" ]; then
    atmux
fi

#git shortcuts
alias ci="git commit --interactive"
alias cm="git commit"
alias pull="git pull"
alias push="git push"
alias gl="git hist"
alias co="git checkout"
alias add="git add"
alias gs="git status"
alias gd="git diff"
alias gb="git branch"

## terminal configuration
#

case "${TERM}" in
xterm|xterm-color|screen)
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    zstyle list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm-color)
    stty erase '^H'
    export LSCOLORS=exfxcxdxbxegedabagacad
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    zstyle list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
kterm)
    stty erase '^H'
    ;;
cons25)
    unset LANG
    export LSCOLORS=ExFxCxdxBxegedabagacad
    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    zstyle list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
jfbterm-color)
    export LSCOLORS=gxFxCxdxBxegedabagacad
    export LS_COLORS='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    zstyle list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
    ;;
esac

# set terminal title including current directory
#
case "${TERM}" in
xterm|xterm-color|kterm|kterm-color)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

#補完数が多い時に許可を聞く閾値
LISTMAX=100

# bashmarks(directry bookmark)を有効化
source ~/dotfiles/bashmarks/bashmarks.sh

