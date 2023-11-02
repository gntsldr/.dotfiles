# Set the window title
function title()
{
   echo -n -e "\033]0;$*\007"
}
title $(hostname)

# Reset the window title after the ssh command
function ssh()
{
   /usr/bin/ssh "$@"
   title $(hostname)
}

# Reset the window title after the su command
function su()
{
   /bin/su "$@"
   title $(hostname)
}

#DISABLE_AUTO_TITLE="true"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/gntsldr/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# key bindings
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# Add aliases for color
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto'

# Start Starship
eval "$(starship init zsh)"

# Enable zsh-autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

autoload -U +X bashcompinit && bashcompinit

# Autocomplete for Terraform
complete -o nospace -C /usr/bin/terraform terraform

# Alias for dotfile management with git
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
