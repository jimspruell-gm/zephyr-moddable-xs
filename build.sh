#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "${ROOT_DIR}"

BOARD="${BOARD:-cc1352p1_launchxl}"
BUILD_DIR="${BUILD_DIR:-build}"
SIMPLELINK_SDK_DIR="${TI_SIMPLELINK_SDK_DIR:-${SIMPLELINK_SDK_DIR:-${ROOT_DIR}/simplelink_cc13xx_cc26xx_sdk}}"

make validate
make lint
make build BOARD="${BOARD}" BUILD_DIR="${BUILD_DIR}" SIMPLELINK_SDK_DIR="${SIMPLELINK_SDK_DIR}"
