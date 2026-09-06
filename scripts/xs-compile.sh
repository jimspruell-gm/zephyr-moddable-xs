#!/usr/bin/env bash
set -euo pipefail

XSC_BIN="${XSC:-xsc}"
OUT_DIR="${1:-build/xs}"
shift || true

if [ "$#" -eq 0 ]; then
  set -- js/*.javascript js/*.js
fi

mkdir -p "${OUT_DIR}"

for source in "$@"; do
  if [ -f "${source}" ]; then
    "${XSC_BIN}" -c -o "${OUT_DIR}" "${source}"
  fi
done
