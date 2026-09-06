#!/usr/bin/env bash
set -euo pipefail

if ! command -v node >/dev/null 2>&1; then
  echo "node not found; skipping JS syntax checks"
  exit 0
fi

for file in js/*.js examples/*.js; do
  if [ -f "${file}" ]; then
    node --check "${file}"
  fi
done

for file in js/*.javascript; do
  if [ -f "${file}" ]; then
    tmp_file="$(mktemp /tmp/xs-js-XXXXXX.js)"
    cp "${file}" "${tmp_file}"
    node --check "${tmp_file}"
    rm -f "${tmp_file}"
  fi
done
