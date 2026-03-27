#!/usr/bin/env bash
set -Eeuo pipefail

make -f makefile.win64 -j$(nproc)
chmod -x release/gamex86_64.dll

