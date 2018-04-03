######################################################################################################


# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


##-----------------------------------##
## ENVIRONMENTAL VARIABLES
##-----------------------------------##

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignorespace:ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend
export HISTTIMEFORMAT="%d %b %Y - %R "

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=2000

# set shopt to avoid spelling misstakes
shopt -s cdspell

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Bashschecks if the command in hash table exists before executing it.
# If not it proceeds to look into normal path search.
shopt -s checkhash

## saves multiline commands as one line in one history entry
shopt -s cmdhist

#If set, the extended pattern matching features are enabled. ?,*,+,@,!(patern-list)
shopt -s extglob

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

## If enabled, and the cmdhist option is enabled, multi-line commands are saved to the history with embedded newlines rather than using semicolon separators where possible.
shopt -s lithist

## Others shopt set by default are:
    #complete_fullquote	on
    #expand_aliases 	on
    #extquote       	on
    #force_fignore  	on
    #interactive_comments	on
    #progcomp       	on
    #promptvars     	on
    #sourcepath     	on


## set umask to make sharing of folders easier. Un-comment if that's needed
#umask  0002

## set PATH so it includes user's private bin if it exists. Unmark if it is not in .profile file.
 if [[ -d "$HOME/bin" && ":PATH:" != *":$HOME/bin:"* ]]; then
     PATH="$PATH:$HOME/bin"
 fi


alias vim='nvim'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(\cat /etc/debian_chroot)
fi


##---------------
##add screnfetch
if [ -f ~/bin/screenfetch.sh ]; then
	if [[ -d /etc/apt ]]; then
    screenfetch.sh -D "LinuxMint" -L
	elif [[ -f /etc/pacman.d/antergos-mirrorlist ]]; then
    screenfetch.sh -D "Antergos"
	elif [[ -d /etc/pacman.d ]]; then
    screenfetch.sh -D "Arch"
  else
  	    screenfetch.sh
	fi
fi


## Set LS_COLORS, colorize man pages and set alias for colors
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## Read in colors variables found in .colors.sh script and set a LS_COLORS env variable
# if this couses problems and interference with other variables, comment out below if statement of remove .colors from home directory
if [[ -x ~/bin/.colors.sh ]]; then
  . ~/bin/.colors.sh
fi

##---------------------------
## PS1 values and colors
##----------------------------
#To set the original PS1 value
#PS1="\[\e]0;\u@\h \w\a\]\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w $\[\033[00m\] "


## GIT PROMPT till PS1 ##
prompt_git() {
    local s='';
    local branchName='';

    # Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}

##----------------------------
## Uncomment for a colored prompt, if the terminal has the capability; turned
## off by default to not distract the user: the focus in a terminal window
## should be on the output of commands, not on the prompt
#force_color_prompt=yes

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm|xterm-color|*-256color) force_color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [[ ${EUID} == 0 ]] ; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
    else
#     PS1='\n\n\[\e]0;\u@\h \w\a\]\[\033[0;32m\]\u\[\033[01;35m\]@\[\033[01;32m\]\h\[\033[00m\] \[\033[0;36m\]\w $\[\033[00m\] '
#     PS1='\n\n\[\e]0;\u@\h \w\a\]\[${bold}\]\[${green}\]\u\[${lightpurple}\]@\[${lightgreen}\]\h \[${lightblue}\]\w $\[${default}\] '
     PS1="\n\n\[${bold}\]\[${green}\]\u\[${lightpurple}\]@\[${lightgreen}\]\h " # user and hostname
     PS1+="\[${yellow}\]\w/"  # Working directory
     PS1+="\$(prompt_git \"\[${white}\] > on \[${blue}\]\" \"\[${red}\]\") "  # Git-promten
   ## Prompt alt 1
    # PS1+="\[${lightblue}\]$\[${default}\] " # Prompten
   ## Prompt alt 2
     # PS1+="\n  \[${lightblue}\]$\[${default}\] " # Prompten
   ## Prompt alt 3
     # PS1+="\[${lightblue}\]$\[${default}\]" # Prompten
     # PS1+="\n \[${lightblue}\]⟹\[${default}\] " # Prompten
   ## Prompt alt 4
      PS1+="\[${lightgreen}\]$" # Prompten
      PS1+="\n \[${red}\]❱\[${default}\] " # Prompten
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h \w \$ '
fi
unset color_prompt force_color_prompt


# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

##--------------------------------------##
# Alias definitions.
##------------------------------------##

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

## Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -x /usr/bin/mint-fortune ]; then
     /usr/bin/mint-fortune
fi


## To tell if the file was read
echo "The .bashrc file was successfully read"
