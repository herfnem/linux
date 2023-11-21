# neko.zsh-theme

MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}"
local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%} "
local virtualenv_info='$(virtualenv_prompt_info)'
local git_info='$(git_prompt_info)'
local git_status='$(git_prompt_status)'

ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[239]}➤%{$reset_color%} ${FG[255]}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} [Added ✚]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} [Modified ✹]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} [Deleted ✖]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} [Renamed ➜]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} [Unmerged ═]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} [Untracked ✭]%{$reset_color%}"

function prompt_char() {
  command git branch &>/dev/null && echo "%{$fg[green]%}○%{$reset_color%}" && return
  command hg root &>/dev/null && echo "%{$fg_bold[red]%}☿%{$reset_color%}" && return
  command darcs show repo &>/dev/null && echo "%{$fg_bold[green]%}❉%{$reset_color%}" && return
  echo "%{$fg[cyan]%}◯%{$reset_color%}"
}

ZSH_THEME_RUBY_PROMPT_PREFIX=" ${FG[239]}using${FG[243]} ‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

export VIRTUAL_ENV_DISABLE_PROMPT=1
ZSH_THEME_VIRTUALENV_PREFIX=" ${fg[yellow]}("
ZSH_THEME_VIRTUALENV_SUFFIX=")%{$reset_color%}"


function virtualenv_prompt_info {
  [[ -n ${VIRTUAL_ENV} ]] || return
  echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

function box_name {
  local box="${SHORT_HOST:-$HOST}"
  [[ -f ~/.box-name ]] && box="$(< ~/.box-name)"
  echo "${box:gs/%/%%}"
}

PROMPT="╭─${FG[040]}%n${FG[239]}%{$fg_bold[yellow]%}@${FG[033]}$(box_name) ${FG[239]}in %{$fg[cyan]%}%~${ruby_env}${virtualenv_info}%b${git_info}${git_status}
╰─$(prompt_char)%{$reset_color%} "


################################Another Layout####################################

# function virtualenv_prompt_info {
#   [[ -n ${VIRTUAL_ENV} ]] || return
#   echo "${ZSH_THEME_VIRTUALENV_PREFIX:=[}${VIRTUAL_ENV:t}${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
# }

# function prompt_char {
#   command git branch &>/dev/null && echo "⚡" || echo '○'
# }

# function box_name {
#   local box="${SHORT_HOST:-$HOST}"
#   [[ -f ~/.box-name ]] && box="$(< ~/.box-name)"
#   echo "${box:gs/%/%%}"
# }

# local ruby_env='$(ruby_prompt_info)'
# local git_info='$(git_prompt_info)'
# local virtualenv_info='$(virtualenv_prompt_info)'
# local prompt_char='$(prompt_char)'

# PROMPT="╭─${FG[040]}%n${FG[239]}%{$fg_bold[yellow]%}@${FG[033]}$(box_name) ${FG[239]}in %{$fg[cyan]%}%~${ruby_env}${virtualenv_info}%b${git_info}
# ╰─${prompt_char}%{$reset_color%} "

# ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[239]}➤%{$reset_color%} ${FG[255]}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="${FG[202]}✘"
# ZSH_THEME_GIT_PROMPT_CLEAN="${FG[040]}✔"
# ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}!"

# ZSH_THEME_RUBY_PROMPT_PREFIX=" ${FG[239]}using${FG[243]} ‹"
# ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

# export VIRTUAL_ENV_DISABLE_PROMPT=1
# ZSH_THEME_VIRTUALENV_PREFIX=" ${fg[yellow]}("
# ZSH_THEME_VIRTUALENV_SUFFIX=")%{$reset_color%}"
