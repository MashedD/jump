#!/usr/bin/env bash
set -Eeuo pipefail

make -f makefile.win64 -j$(nproc)

