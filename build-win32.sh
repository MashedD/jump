#!/usr/bin/env bash
set -Eeuo pipefail

make -f makefile.win32 -j$(nproc)

