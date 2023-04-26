# Lines configured by zsh-newuser-install
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# Lines configured by zsh-newuser-install
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/kubaws/.zshrc'
alias ls='exa -la --icons'
alias grep='rg'
alias cd='z'
alias cat='bat'
alias find='fd'
alias untar='tar -zxvf '
alias wget='wget -c '

#alias nvimfzf='nvim -o `fzf --height 35% --border --exact`'
#alias ls='ls --color=auto -a | fzf --height 35% --border'
#alias search='eix -c | fzf --height 35% --border --exact'
export PATH="${PATH}:${HOME}/.local/bin/"


autoload -Uz compinit
compinit
# End of lines added by compinstall

#Gruvbox ####################################################


# History in cache directory:
# the detailed meaning of the below three variable can be found in `man zshparam`.
export HISTFILE=~/.histfile
export HISTSIZE=1000000   # the number of items for the internal history list
export SAVEHIST=1000000   # maximum number of items for the history file

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time

# Basic auto/tab complete:
autoload -U compinit promptinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion::complete:*' use-cache 1
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

#PS1="%B%{$fg[green]%}[%{$fg[green]%}🐾yeenden%}%~%{$fg[green]%}]%{$reset_color%}$%b "
# vi mode
if [[ $EUID -ne 0 ]]; then
   PROMPT="%{$fg[green]%}[🐾yeen %{$fg_bold[white]%}%~%{$fg[green]%}]%{$reset_color%} "
else
   PROMPT="%{$fg[red]%}[🐾yeen %{$fg_bold[white]%}%~%{$fg[red]%}]%{$reset_color%} "
fi
RPROMPT='[%T]'
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"


export MOZ_ENABLE_WAYLAND=1
export MOZ_USE_XINPUT2=1
export MOZ_WEBRENDER=1
export MOZ_ACCELERATED=1
export MOZ_DBUS_REMOTE=1
export MOZ_DISABLE_RDD_SANDBOX=1
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_QPA_PLATFORMTHEME=qt5ct 
export QT_QPA_PLATFORM=wayland
export XDG_SESSION_DESKTOP=wayland
export XDG_CURRENT_DESKTOP=wayland
export GDK_BACKEND="wayland,x11"
export GTK_BACKEND=wayland
export RTC_USE_PIPEWIRE=true
export SDL_VIDEODRIVER=wayland
export XDG_SESSION_TYPE=wayland
export QT_STYLE_OVERRIDE="Breeze"
export GTK_THEME="Breeze"
export CLUTTER_BACKEND=wayland
export XDG_CURRENT_DESKTOP=KDE
export GTK_USE_PORTAL=0
export _JAVA_AWT_WM_NONREPARENTING=1
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_ENGINE=wayland_egl
export VISUAL=nvim
export EDITOR="$VISUAL"

. /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
#alias emerge-update="sudo emerge --sync && sudo emerge --ask --verbose --update --deep --newuse @world"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

source /home/kubaws/.config/broot/launcher/bash/br
