# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '+' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' menu select=long
zstyle ':completion:*' prompt 'maybe..'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/jason/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=500
setopt notify
bindkey -v
# End of lines configured by zsh-newuser-install

# Function keys

bindkey "\e[1~" beginning-of-line
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line

bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line

# Digital arguments
bindkey "^[1" digit-argument
bindkey "^[2" digit-argument
bindkey "^[3" digit-argument
bindkey "^[4" digit-argument
bindkey "^[5" digit-argument
bindkey "^[-" digit-argument

# Some key bind modification
bindkey "^P" vi-up-line-or-history
bindkey "^N" vi-down-line-or-history
bindkey '\e[1~'   beginning-of-line  # Linux console
bindkey '\e[H'    beginning-of-line  # xterm
bindkey '\eOH'    beginning-of-line  # gnome-terminal
bindkey '\e[2~'   overwrite-mode     # Linux console, xterm, gnome-terminal
bindkey '\e[3~'   delete-char        # Linux console, xterm, gnome-terminal
bindkey '\e[4~'   end-of-line        # Linux console
bindkey '\e[F'    end-of-line        # xterm
bindkey '\eOF'    end-of-line        # gnome-terminal

# Load the prompt string, as well as the colors
if [[ -f ~/.zshprompt ]]; then
	. ~/.zshprompt
fi

# I use same aliases and env files as bash.
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [[ -f ~/.bash_aliases ]]; then
    . ~/.bash_aliases
fi

# Environment variables definitions
# I put all the env configuaration into a separate file to make .bashrc
# clear and easy to modify
if [[ -f ~/.bashenv ]]; then
    . ~/.bashenv
fi

# SSH agent deamon
# Key for cvs server
keychain ~/.ssh/id_rsa >/dev/null 2>&1
source "~/.keychain/`hostname`-sh" > /dev/null

# Shortcuts for directory
# hash -d docsis='/home/jason/Projects/Docsis_Transponder/under_cvs'
