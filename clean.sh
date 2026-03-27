#!/usr/bin/env bash
set -Eeuo pipefail

rm -rf debug
rm -rf release
make clean
make -f makefile.win32 clean
make -f makefile.win64 clean

