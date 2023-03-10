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


# Ask for Super User password immediately.

sudo ls >/dev/null


# Set action variables.

SKIP_SELF_UPDATE=1
SKIP_APT=1
SKIP_SNAP=1
SKIP_YUM=1
SKIP_FLATPAK=1
SKIP_PIHOLE=1
SKIP_PIP=1
SKIP_RCLONE=1


# Filter through the parsed arguments and change the action variables as needed

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


# Update the LNS package as well as all the other subpackages used by LNS

if [ $SKIP_SELF_UPDATE -ne 0 ]
then

  # Update LNS

  printf "\nUpdating LNS..."
  cd ~/bin
  git pull


  # Update UP specifically and restart the script (skipping this section if an update is detected)

  printf "Updating this script..."
  cd ~/bin/apps/up
  prev=$(git rev-list HEAD -n 1)
  git pull
  if test $prev != $(git rev-list HEAD -n 1)
  then
    echo "Script Updated"
    cd ~/bin
    lns --update # Update the LNS called repos packages
    up --skip-self-update $@
    exit 0
  fi
  lns --update # Update the LNS called repos packages

  ##
  # TODO:
  #    Detect if a new package exists in LNS and pull it.
  ##
fi


# Update APT / NALA
if [ $SKIP_APT -ne 0 ]
then
  if hash nala 2>/dev/null; then
    # Update NALA
    # Repo: https://gitlab.com/volian/nala
    printf "\nNALA\n"
    sudo nala upgrade -yy
    sudo nala install --fix-broken
    sudo nala autoremove -yy
    sudo nala clean
  elif hash apt 2>/dev/null; then
    # Update APT
    printf "\nAPT\n"
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
    printf "\nSNAP\n"
    sudo snap refresh
  fi
fi

if [ $SKIP_YUM -ne 0 ]
then
  # Update YUM
  if hash yum 2>/dev/null; then
    printf "\nYUM\n"
    sudo yum update -yy
  fi
fi

if [ $SKIP_FLATPAK -ne 0 ]
then
  # Update Flatpak
  if hash flatpak 2>/dev/null; then
    printf "\nFLATPAK\n"
    sudo flatpak update -yy
  fi
fi

if [ $SKIP_PIHOLE -ne 0 ]
then
  # Update PiHole
  if hash pihole 2>/dev/null; then
    printf "\nPIHOLE\n"
    pihole -up
  fi
fi

if [ $SKIP_RCLONE -ne 0 ]
then
  # Update rclone
  if hash rclone 2>/dev/null; then
    printf "\nRCLONE\n"
    sudo rclone selfupdate
  fi
fi

if [ $SKIP_PIP -ne 0 ]
then
  # Check if any PIP3 updates exist.
  if hash pip3 2>/dev/null; then
    printf "\nPIP3\nrun pip3 install -U APPNAME to update an individual package\n\n"
    pip3 list --outdated
    # pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 
  fi
fi

printf "\n\nAll update tasks complete\n"
