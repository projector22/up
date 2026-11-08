#!/bin/bash

set -euo pipefail

INSTALL_DIR=~/.up
REPO=https://github.com/projector22/up.git
BIN_DIR=~/bin

if [[ -d "$INSTALL_DIR" ]]; then
	rm -rf "$INSTALL_DIR"
fi
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

printf "%s" "Installing..."
git clone "$REPO" . >/dev/null 2>&1

mkdir -p "$BIN_DIR"

chmod +x "$INSTALL_DIR/up.sh"


if [[ -L "$BIN_DIR/up" ]]; then
	unlink "$BIN_DIR/up"
fi
ln -s "$INSTALL_DIR/up.sh" "$BIN_DIR/up"

printf " %s\n" "Done"

