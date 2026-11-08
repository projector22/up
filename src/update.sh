#!/bin/bash

set -euo pipefail

INSTALL_DIR=~/.up

cd "$INSTALL_DIR" || return 1

git pull

