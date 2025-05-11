# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

zstyle ':omz:alpha:lib:git' async-prompt false
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="lambda-mod"
#ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="nerdfont-complete"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="nerdfont-complete"
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="nerdfont-complete"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS=""
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting fzf-zsh-plugin)

source $ZSH/oh-my-zsh.sh

# User configuration

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias l="ls"
alias gits="git status"
alias gitd="git diff"
#alias -g - --="cd -"
alias gitlogger="git log --branches --remotes --tags --graph --oneline --decorate"
alias open="open_command"
alias bat="batcat"
alias vim=nvim
alias fzf-edit="fzf --preview 'batcat --style=numbers --color=always {}' | xargs -n 1 nvim"

function mkcd(){
	mkdir "$1" && cd "$1"
}

function mvcd(){
	mv "$1" "$2" && cd "$2"
}

function up(){
	back="cd "
	if [[ $1 = "" ]]; then
		back+="../"
	else
		for ((i=0; i < $1; i++)) do
			back+="../"	
		done
	fi
	eval "$back"
}

function almightypush(){
	if [[ "$#" -eq 1 ]] && [[ $1 != "" ]];then
		git add -A
		git commit -m "$1"
		git push origin HEAD
		if [[ ! -f "$HOME/Downloads/push.mp4" ]];then
			youtube-dl "https://www.youtube.com/watch?v=aYAhC8zn42E" -o '$HOME/Downloads/push.%(ext)s'
		fi
		mpv $HOME/Downloads/push.mp4 --length=3 --really-quiet
	else
		echo "You need to pass a commit message in quotes \"\" as one argument"
	fi
}

function gitbrancher(){
	length=0
	typeset -l bN #zsh to enforce lowercase on all extension of bN
	bN=""
	if [[ $# -gt 1 ]]; then 
		length=${#2}
		bN="$2"
	elif [[ $# -eq 1 ]]; then
		length=${#1}
		bN="$1"
	else
		echo "Please pass a string branch name ex. \" test branch\""
		return
	fi
	for ((i=1; i < length; i++)) do
		if [[ "${bN:$i:1}" == " " && ("${bN:$i+1:1}" == "-" || "${bN:$i-1:1}" == "-") ]];then
			bN=${bN:0:$i}""${bN:$i+1}
		elif [[ "${bN:$i:1}" == " " ]];then
			bN=${bN:0:$i}"-"${bN:$i+1}		
		fi
	done
	#bN=`echo "$bN" | sed 's/./\L&/g'`
	while [ ! $# -eq 0 ]
	do
		case "$1" in
			--test | -t)
				echo "$bN"
				return
				exit
				;;
		esac
		shift
	done
	git checkout -b "$bN"
}

function kiryu(){
	ret=$?
	if [[ $ret -eq 127 ]] || [[ $ret -eq 1 ]];then
		if [[ ! -f "$HOME/Downloads/kiryu.mp4" ]];then
			youtube-dl "https://www.youtube.com/watch?v=YcAHHKY3Y0I" -o '$HOME/Downloads/kiryu.%(ext)s'
		fi
		mpv $HOME/Downloads/kiryu.mp4 --length=2 --really-quiet
	else 
		:
	fi
}
#use unset PROMPT_COMMAND to undo function call.
#PROMPT_COMMAND="kiryu"
#precmd() { eval "$PROMPT_COMMAND" }

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:/usr/local/go/bin:$PATH"
export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/nvim/mason/packages/jdtls/lombok.jar"

[ -f "/home/danny/.ghcup/env" ] && source "/home/danny/.ghcup/env" # ghcup-envfpath+=${ZDOTDIR:-~}/.zsh_functions
fpath+=${ZDOTDIR:-~}/.zsh_functions

export FZF_DEFAULT_COMMAND='rg --files --follow --hidden -g "!{**/node_modules/*,**/.git/*,**/target/*,**/build/*,**/.cargo/*}"'
export FZF_DEFAULT_OPTS='--preview "batcat --style=numbers --color=always {}" --preview-window right:50%:hidden:wrap --bind ctrl-/:toggle-preview'
#export FZF_ALT_C_COMMAND='rg --files --follow --hidden -g "!{**/node_modules/*,**/.git,**/target/*,**/build/*}" | find -type d'
export FZF_ALT_C_COMMAND='rsearch --name "**" --type d --exclude "node_modules,.git,target,build"'
#export FZF_ALT_C_COMMAND='find -type d \( -path "**/node_modules" -prune -o -path "**/.git" -prune -o -path "**/target" -prune -o -path "**/build" \) -o -print'
[ -f ~/.fzf.zsh ] && source ~/.fzf/fzf.zsh
