if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent -t 1d > $XDG_RUNTIME_DIR/ssh-agent.env
fi

if [[ ! $SSH_AUTH_SOCK ]]; then
    source $XDG_RUNTIME_DIR/ssh-agent.env >/dev/null
fi

if [[ $(tty) == /dev/tty1 ]]; then
#for sway's output to be handled by journald
      exec systemd-cat --identifier=sway sway
fi
