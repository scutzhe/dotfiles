fpath=($fpath /usr/share/doc/radare2/zsh)
# {{{ oh-my-zsh
# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="lambda"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode autojump command-not-found systemd archlinux shrink-path)

# User configuration

export PATH=$HOME/bin:$HOME/.local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh
# }}}

# {{{ custom stuffs
autoload bashcompinit
bashcompinit
setopt extended_glob
setopt no_histverify
setopt noincappendhistory
setopt nosharehistory
setopt magic_equal_subst

alias ls='ls --color=auto'
alias cm='cmake'
alias m='make'
alias grep="grep -P --color=auto"
alias jf='journalctl -f'
alias sudo='sudo '
alias a2='aria2c'
alias pc='proxychains -q'
alias pca='proxychains -q aria2c'
alias pcg='proxychains -q git clone'
alias site_deploy='stack exec -- site deploy'
alias site_build='stack exec -- site build'

mm () { make $* 2>&1 | sed -e 's/\(.*\)\b\([Ww]arning\)\(.*\)/\1\x1b[5;1;33m\2\x1b[0m\3/i' -e 's/\(.*\)\b\([Ee]rror\)\(.*\)/\1\x1b[5;1;31m\2\x1b[0m\3/' }
compdef mm=make
ghc () { stack --verbosity slient exec -- ghc $* }
ghci () { stack --verbosity slient exec -- ghci $* }
runhaskell () { stack --verbosity slient exec -- runhaskell $* }
ghc-pkg () { stack --verbosity slient exec -- ghc-pkg $* }
clash () { stack --verbosity slient exec -- clash $* }
n () {
	if [[ ${1##*.} == "hs" || ${1##*.} == "lhs" ]];
		then stack --verbosity slient exec -- nvim $*;
		else nvim $*;
	fi
}
bv() {
	xxd $* | n - -c "set ft=xxd"
}

compdef n=nvim
compdef bv=xxd

SAVEHIST=1000
HISTSIZE=1000
HISTFILE=~/.history

bindkey -v
bindkey "" history-beginning-search-backward
bindkey ""  history-beginning-search-forward
bindkey "." insert-last-word
bindkey -M viins 'kj' vi-cmd-mode
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line

export PATH=$PATH:$HOME/x-tools7h/arm-unknown-linux-gnueabihf/bin
export MANPAGER="nvim -c 'set ft=man' -c 'call clearmatches()' -"
export VIMRC="$HOME/.config/nvim/init.vim"

. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval /usr/share/bash-completion/completions/stack
eval /usr/share/bash-completion/completions/pandoc

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=white,underline'

## set konsole colorscheme
if [ "x"$KONSOLE_DBUS_SERVICE != "x" ]; then
  time_h=$(date +%H)
	if [ $((time_h)) -ge 18 ] || [ $((time_h)) -lt 6 ]; then
    konsoleprofile colors=Dracula
  fi
fi

## fzf
export FZF_DEFAULT_COMMAND='ag -g ""'
source /usr/share/fzf/completion.zsh

# fh - repeat history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fkill - kill process
fkill() {
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

# unique without sorting
uniqNoSort() {
	perl -ne 'print unless $seen{$_}++'
}

# filter file opened by nvim
ff() {
	filename=$(n --headless -c 'echo join(v:oldfiles, "\n")' +q |& \
		tr -d '' | uniqNoSort | fzf +s)
	[[ -n $filename ]] && print -z "n" "$filename"
}

# filter file content opened by nvim
ffc() {
	filename=$(n --headless -c 'echo join(v:oldfiles, "\n")' +q |&\
		grep -v "scp://|https?://|man://|ftp://" | tr -d '' |\
		uniqNoSort |\
		xargs -I{} sh -c "test -f '{}' && test -r '{}' && echo '{}'" |\
		xargs ag --nobreak --noheading . | fzf +s |\
		awk -F':' '{print $1, "+"$2}')
	args=("${(@s: :)filename}")
	[[ -n $args[1] ]] && print -z "n" $args
}

# }}}
