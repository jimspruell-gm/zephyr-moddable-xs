#!/usr/bin/env bash
set -euo pipefail

while IFS= read -r file; do
  [ -f "${file}" ] || continue
  if grep -nI -E ' +$' "${file}"; then
    echo "trailing whitespace detected in ${file}"
    exit 1
  fi
done < <(git ls-files)
