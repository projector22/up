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
# - --skip-flatpak
# - --skip-pihole
# - --skip-pip
# - --skip-rclone
#
# Author:
# Gareth Palmer [@projector22]
##

SKIP_SELF_UPDATE=1
SKIP_APT=1
SKIP_SNAP=1
SKIP_YUM=1
SKIP_FLATPAK=1
SKIP_PIHOLE=1
SKIP_PIP=1
SKIP_RCLONE=1


while [ "$1" != "" ]; do
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
    --skip-flatpak)
      SKIP_FLATPAK=0
    ;;
    --skip-pihole)
      SKIP_PIHOLE=0
    ;;
    --skip-pip)
      SKIP_PIP=0
    ;;
    --skip-rclone)
      SKIP_RCLONE=0
    ;;
  esac
  shift
done

printf "Checking for all available updates for your system."

# if [ $SKIP_SELF_UPDATE -ne 0 ]
# then
#   printf "\nUpdating this script..."
#   cd ~/bin
#   prev=$(git rev-list HEAD -n 1)
#   git pull
#   if test $prev != $(git rev-list HEAD -n 1)
#   then
#     echo "Script Updated"
#     up --skip-self-update $@
#     exit 0
#   fi
# fi

if [ $SKIP_APT -ne 0 ]
then
  if hash nala 2>/dev/null; then
    # Repo: https://gitlab.com/volian/nala
    printf "\n\nNALA"
    sudo nala upgrade -yy
    sudo nala install --fix-broken
    sudo nala autoremove -yy
    sudo nala clean
  elif hash apt 2>/dev/null; then
    printf "\n\nAPT"
    sudo apt update
    sudo apt list --upgradable
    sudo apt --fix-broken install
    sudo apt full-upgrade -yy
    sudo apt autoremove -yy
    sudo apt clean -yy
    printf "Apt update task complete"
  fi
fi

if [ $SKIP_SNAP -ne 0 ]
then
  if hash snap 2>/dev/null; then
    printf "\n\nSNAP\n"
    sudo snap refresh
    printf "snap update task complete"
  fi
fi

if [ $SKIP_YUM -ne 0 ]
then
  if hash yum 2>/dev/null; then
    printf "\n\nYUM"
    sudo yum update -yy
    printf "yum update task complete"
  fi
fi

if [ $SKIP_FLATPAK -ne 0 ]
then
  if hash flatpak 2>/dev/null; then
    printf "\n\nFLATPAK"
    sudo flatpak update -yy
    printf "flatpak update task complete"
  fi
fi

if [ $SKIP_PIHOLE -ne 0 ]
then
  if hash pihole 2>/dev/null; then
    printf "\n\nPIHOLE"
    pihole -up
    printf "pihole update task complete"
  fi
fi

if [ $SKIP_RCLONE -ne 0 ]
then
  if hash rclone 2>/dev/null; then
    printf "\n\nRCLONE"
    sudo rclone selfupdate
    printf "rclone update task complete"
  fi
fi

if [ $SKIP_PIP -ne 0 ]
then
  if hash pip3 2>/dev/null; then
    printf "\n\nPIP3\nrun pip3 install -U APPNAME to update an individual package\n\n"
    pip3 list --outdated
    # pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 
  fi
fi

printf "\nAll updates complete\n"
