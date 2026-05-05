#!/usr/bin/env bash
# Theme: colors and ASCII helpers for presentation-grade output.
# Source this file: source _runner/theme.sh

# Disable if NO_COLOR is set
if [ -n "${NO_COLOR:-}" ]; then
  C_RESET=""; C_BOLD=""; C_DIM=""
  C_CYAN=""; C_YELLOW=""; C_GREEN=""; C_RED=""; C_MAGENTA=""; C_GREY=""
else
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_DIM=$'\033[2m'
  C_CYAN=$'\033[36m'
  C_YELLOW=$'\033[33m'
  C_GREEN=$'\033[32m'
  C_RED=$'\033[31m'
  C_MAGENTA=$'\033[35m'
  C_GREY=$'\033[90m'
fi

# Brand: Bilanciarsi/UniBO co-brand greens
C_BRAND="$C_CYAN"
C_ACCENT="$C_GREEN"

clear_screen() {
  printf '\033[2J\033[H'
}

# Box-drawn banner. Args: title subtitle
banner() {
  local title="$1"
  local subtitle="${2:-}"
  local width=72
  local line
  printf -v line '%*s' "$width" ''
  line=${line// /─}

  echo
  echo "${C_BRAND}┌${line}┐${C_RESET}"
  printf "${C_BRAND}│${C_RESET}  ${C_BOLD}%-$((width - 2))s${C_RESET}${C_BRAND}│${C_RESET}\n" "$title"
  if [ -n "$subtitle" ]; then
    printf "${C_BRAND}│${C_RESET}  ${C_GREY}%-$((width - 2))s${C_RESET}${C_BRAND}│${C_RESET}\n" "$subtitle"
  fi
  echo "${C_BRAND}└${line}┘${C_RESET}"
  echo
}

# Section header (smaller than banner)
section() {
  echo
  echo "${C_ACCENT}▌${C_BOLD} $1${C_RESET}"
  echo
}

# Narrative paragraph in grey
narrate() {
  echo "${C_GREY}  $1${C_RESET}"
}

# Show command before running
show_cmd() {
  echo
  echo "  ${C_YELLOW}\$ $*${C_RESET}"
  echo
}

# Status lines
status_ok() { echo "  ${C_GREEN}✓${C_RESET} $1"; }
status_warn() { echo "  ${C_YELLOW}!${C_RESET} $1"; }
status_err() { echo "  ${C_RED}✗${C_RESET} $1"; }
status_info() { echo "  ${C_CYAN}i${C_RESET} $1"; }

# Pause for invio
pause() {
  echo
  echo "${C_DIM}  [premi invio per continuare]${C_RESET}"
  read -r _ < /dev/tty || true
}

# Pause with custom prompt
pause_msg() {
  echo
  echo "${C_DIM}  [premi invio per $1]${C_RESET}"
  read -r _ < /dev/tty || true
}

# Big ASCII number/label for emphasis (printed in accent color)
big_label() {
  echo
  echo "${C_ACCENT}${C_BOLD}  ▶ $1${C_RESET}"
  echo
}
