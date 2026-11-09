#!/bin/bash

set -euo pipefail

INSTALL_DIR="$HOME"/.up

cd "$INSTALL_DIR" || return 1

git pull

