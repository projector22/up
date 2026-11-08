#!/bin/bash

set -euo pipefail

INSTALL_DIR=~/.up
REPO=https://github.com/projector22/up.git
BIN_DIR=~/bin

mkdir -p "$INSTALL_DIR"

cd "$INSTALL_DIR"

git clone "$REPO" .

mkdir -p "~/$BIN_DIR"

chmod +x "$INSTALL_DIR/up.sh"

ln -s "$INSTALL_DIR/up.sh" "$BIN_DIR/"

printf "%s\n" "Done..."

