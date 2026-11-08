#!/bin/bash

set -euo pipefail

INSTALL_DIR=~/.up
BIN_DIR=~/bin

if [[ -L "$BIN_DIR/up" ]]; then
	unlink "$BIN_DIR/up"
fi

if [[ -d "$INSTALL_DIR" ]]; then
	rm -rf "$INSTALL_DIR"
fi

