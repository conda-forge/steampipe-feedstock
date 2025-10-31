#!/bin/sh
set -eux

# Use installed Go, don't download newer versions
export GOTOOLCHAIN=local
export OUTPUT_DIR="$PREFIX/bin"
mkdir -p "$OUTPUT_DIR"
make build

# Cross-compilation: check correct architecture was built
if [ -n "$GOARCH" ]; then
  if [ "$GOOS" = darwin ]; then
    if [ "$GOARCH" = arm64 ]; then
      PATTERN="Mach-O.+arm64"
    else
      PATTERN="Mach-O.+x86_64"
    fi
  else
    if [ "$GOARCH" = arm64 ]; then
      PATTERN="ELF.+aarch64"
    else
      PATTERN="ELF.+x86-64"
    fi
  fi

  file $PREFIX/bin/steampipe | grep -E "$PATTERN"
fi

# Complains about steampipe being AGPL-3.0
go-licenses save . --save_path=./license-files || true
test -d license-files/github.com
