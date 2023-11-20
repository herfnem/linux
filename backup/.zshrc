# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="anup"


# Add wisely, as too many plugins slow down shell startup.
plugins=(git
  zsh-autosuggestions  
  zsh-syntax-highlighting
  )

source $ZSH/oh-my-zsh.sh

# On-demand rehash
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd

precmd(){
	precmd(){
		echo 
	}
}

#oh-my-zsh
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="nautilus ~/.oh-my-zsh"

# exa --icons
# ls
alias ls='exa --icons -la'
alias l='exa --icons -lh'
alias ll='exa --icons -lah'
alias la='exa --icons -A'
alias lm='exa --icons -m'
alias lr='exa --icons -R'
alias lg='exa --icons -l --group-directories-first'

#ZSH STARTUP APPS
neofetch

#Package Manager ALIAS
#alias sudo='sudo '
#alias apt='\nala'
#alias dapt='\apt'

#MY ALIAS
alias vscode='code-insiders'
alias venv='python3 -m venv venv && source venv/bin/activate'
alias gc='git clone'
alias vim='nvim'
alias cls='clear && neofetch'
alias sufile='sudo nautilus'

alias hyprconfig='nvim ~/.config/hypr/hyprland.conf'
alias wbarconfig='nvim ~/.config/waybar/config'

#My Path Alias
alias download='cd ~/Downloads/'
alias coding='cd ~/Desktop/Coding/'
alias cdtest='cd ~/Downloads/zx'

#Distrobox
alias archlinux='distrobox enter archlinux'

#CUSTOM PATHS
export PATH="/home/neko/Software/node-v20.9.0-linux-x64/bin:$PATH"

# bun completions
[ -s "/home/neko/.bun/_bun" ] && source "/home/neko/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH=$PATH:/home/neko/.spicetify
