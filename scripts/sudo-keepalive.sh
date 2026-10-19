#! /bin/bash
# Source this file, then call keep_sudo_alive.

# Prompts for sudo once, then refreshes it until the calling script exits.
keep_sudo_alive() {
  sudo -v
  while true; do
    sudo -n true
    sleep 50
    kill -0 "$$" 2>/dev/null || exit
  done 2>/dev/null &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT
}
