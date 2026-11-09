#!/bin/bash

##
# Linux Updater tool. Runs through a number of possible linuxy updating solutions and 
# if they are available, run each updater.
# 
# See:
#   https://github.com/projector22/up/blob/master/README.md
# 
# Arguments:
# - --skip-self-update
# - --skip-apt
# - --skip-snap
# - --skip-yum
# - --skip-dnf
# - --skip-pacman
# - --skip-flatpak
# - --skip-pihole
# - --include-pip
# - --skip-rclone
# - --skip-rustup
# - --set-ntfy _url_
#
# Author:
# Gareth Palmer [@projector22]
##


# Ask for Super User password immediately.

sudo ls >/dev/null
INSTALL_DIR="$HOME/.up"

if [[ -d "$INSTALL_DIR" ]]; then
  source "$INSTALL_DIR"/src/ntfy.sh

  # @see src/ntfy.sh
  prepare_config

else
  prinf "%s\n" "[ERROR] Script not installed correctly"
  exit 1
fi

# Set action variables.

SKIP_SELF_UPDATE=1
SKIP_APT=1
SKIP_SNAP=1
SKIP_YUM=1
SKIP_PACMAN=1
SKIP_FLATPAK=1
SKIP_PIHOLE=1
SKIP_RCLONE=1
SKIP_RUSTUP=1
SET_NTFY_URL=0

# Filter through the parsed arguments and change the action variables as needed

while [[ $# -gt 0 ]]; do
  case $1 in
    --skip-self-update)
      SKIP_SELF_UPDATE=0
    ;;
    --skip-apt)
      SKIP_APT=0
    ;;
    --skip-snap)
      SKIP_SNAP=0
    ;;
    --skip-yum)
      SKIP_YUM=0
    ;;
    --skip-dnf)
      SKIP_YUM=0
    ;;
    --skip-pacamn)
      SKIP_PACMAN=0
    ;;
    --skip-flatpak)
      SKIP_FLATPAK=0
    ;;
    --skip-pihole)
      SKIP_PIHOLE=0
    ;;
    --skip-rclone)
      SKIP_RCLONE=0
    ;;
    --skip-rustup)
      SKIP_RUSTUP=0
    ;;
    --set-ntfy)
      SET_NTFY_URL=1
      NEW_URL="$2"
    ;;
  esac
  shift
done

if [ $SET_NTFY_URL -ne 0 ] 
then
  set_ntfy_URL "$NTFY_URL" "$NEW_URL"
fi


printf "Checking for all available updates for your system."


# Update the LNS package as well as all the other subpackages used by LNS

if [ $SKIP_SELF_UPDATE -ne 0 ]
then

  lns --update

#   # Update LNS

#   printf "\n%s" "Updating LNS..."
#   cd ~/bin || exit 1
#   git pull


#   # Update UP specifically and restart the script (skipping this section if an update is detected)

#   printf "Updating this script..."
#   cd ~/bin/apps/up || exit 1
#   PREV=$(git rev-list HEAD -n 1)
#   git pull
#   if test "$PREV" != "$(git rev-list HEAD -n 1)"
#   then
#     echo "Script Updated"
#     cd ~/bin || exit 1
#     lns --update # Update the LNS called repos packages
#     up --skip-self-update "$@"
#     exit 0
#   fi
#   lns --update # Update the LNS called repos packages

#   ##
#   # TODO:
#   #    Detect if a new package exists in LNS and pull it.
#   ##
fi


# Update APT / NALA
if [ $SKIP_APT -ne 0 ]
then
  if hash nala 2>/dev/null; then
    # Update NALA
    # Repo: https://gitlab.com/volian/nala
    printf "\n%s\n" "NALA"
    sudo nala upgrade -yy
    sudo nala install --fix-broken
    sudo nala autoremove -yy
    sudo nala clean
  elif hash apt 2>/dev/null; then
    # Update APT
    printf "\n%s\n" "APT"
    sudo apt update
    sudo apt list --upgradable
    sudo apt --fix-broken install
    sudo apt full-upgrade -yy
    sudo apt autoremove -yy
    sudo apt clean -yy
  fi
fi

if [ $SKIP_SNAP -ne 0 ]
then
  # Update SNAP
  if hash snap 2>/dev/null; then
    printf "\n%s\n" "SNAP"
    sudo snap refresh
  fi
fi

# DNF / YUM
if [ $SKIP_YUM -ne 0 ]
then
  if hash dnf 2>/dev/null; then
    # Update DNF
    printf "\n%s\n" "DNF"
    sudo dnf update -yy
  elif hash yum 2>/dev/null; then
    # Update YUM
    printf "\n%s\n" "YUM"
    sudo yum update -yy
  fi
fi

# Pacman
if [ $SKIP_PACMAN -ne 0 ]
then
  if hash pacman 2>/dev/null; then
    printf "\n%s\n" "PACMAN"
    sudo pacman -Syu --noconfirm
  fi
fi

if [ $SKIP_FLATPAK -ne 0 ]
then
  # Update Flatpak
  if hash flatpak 2>/dev/null; then
    printf "\n%s\n" "FLATPAK"
    sudo flatpak update -yy
  fi
fi

if [ $SKIP_PIHOLE -ne 0 ]
then
  # Update PiHole
  if hash pihole 2>/dev/null; then
    printf "\n%s\n" "PIHOLE"
    pihole -up
  fi
fi

if [ $SKIP_RCLONE -ne 0 ]
then
  # Update rclone
  if hash rclone 2>/dev/null; then
    printf "\n%s\n" "RCLONE"
    sudo rclone selfupdate
  fi
fi

if [ $SKIP_RUSTUP -ne 0 ]
then
  # Update Rust
  if hash rustup 2>/dev/null; then
    printf "\n%s\n" "RUSTUP"
    rustup update stable
  fi
fi

if hash pipx 2>/dev/null; then
    printf "\n%s\n" "PIPX"
    pipx upgrade-all
fi

if [ -n "${NTFY_URL:-}" ]; then
  send_ntfy "$NTFY_URL" "System update complete ✅"
fi

printf "\n\n%s\n" "All update tasks complete"
