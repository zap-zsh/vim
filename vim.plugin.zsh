#!/bin/sh
bindkey -v
export KEYTIMEOUT=25

VICMD=${VICMD:-'\e[1 q'}  # defaults to block
VIINS=${VIINS:-'\e[5 q'}  # defaults to beam

if [[ -o menucomplete ]]; then
  # Use vim keys in tab complete menu:
  bindkey -M menuselect '^h' vi-backward-char
  bindkey -M menuselect '^k' vi-up-line-or-history
  bindkey -M menuselect '^l' vi-forward-char
  bindkey -M menuselect '^j' vi-down-line-or-history
  bindkey -M menuselect '^[[Z' vi-up-line-or-history
fi

bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne ${VICMD};;      # block
        viins|main) echo -ne ${VIINS};; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne ${VIINS}
}
zle -N zle-line-init
echo -ne ${VIINS} # Use beam shape cursor on startup.
preexec() { echo -ne ${VIINS} ;} # Use beam shape cursor for each new prompt.

# emacs like keybindings
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line

# Add text objects for quotes and brackets.
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for m in viopp visual; do
  for c in {a,i}{\',\",\`}; do
      bindkey -M $m -- $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
      bindkey -M $m -- $c select-bracketed
  done
done

# Add surround like commands.
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround
# escape back into normal mode
if [[ -n "${VI_MODE_ESC_INSERT}" ]] then
    bindkey -M viins "${VI_MODE_ESC_INSERT}" vi-cmd-mode
fi
