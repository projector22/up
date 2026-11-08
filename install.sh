#!/bin/bash

set -euo pipefail

INSTALL_DIR=~/.up
REPO=https://github.com/projector22/up.git
BIN_DIR=~/bin

mkdir -p "$INSTALL_DIR"

cd "$INSTALL_DIR"

printf "%s\n" "Cloning..."
git clone "$REPO" . > /dev/null

mkdir -p "~/$BIN_DIR"

chmod +x "$INSTALL_DIR/up.sh"


if [[ -L "$BIN_PATH/up" ]]; then
	unlink "$BIN_PATH/up"
fi
ln -s "$INSTALL_DIR/up.sh" "$BIN_DIR/up"

printf "%s\n" "Done..."

