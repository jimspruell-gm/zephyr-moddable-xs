# zephyr-moddable-xs

Zephyr + Moddable XS integration scaffold for TI CC1352P1 LaunchXL boards.

## Overview

This project wires the Moddable XS JavaScript toolchain (`xsc`) into a Zephyr
application build for TI CC13xx/CC26xx platforms.

Use cases:
- Rapid embedded prototyping in JavaScript
- Native Zephyr driver startup with XS-native bindings
- CI validation for Zephyr + XS build wiring

## Architecture

```text
JavaScript sources (js/, examples/)
        │
        ├─ xsc compiler (Makefile/build.sh/scripts/xs-compile.sh)
        ▼
Generated C stubs (build/xs/*.c)
        │
        ├─ Zephyr app sources (src/*.c)
        ├─ Board/driver integration (drivers/*.c, boards/*.conf, overlay)
        ▼
Zephyr CMake build (west build)
        ▼
Firmware image for cc1352p1_launchxl
```

## Prerequisites

- Zephyr SDK / West matching your Zephyr workspace (recommended Zephyr `v3.7+`)
- Moddable SDK / XS tools (recommended 5.x+, `xsc` available on `PATH`)
- TI SimpleLink CC13xx/CC26xx SDK installed locally (tested with 7.x layout)
- Toolchain required by your Zephyr setup

## Repository Layout

- `CMakeLists.txt` - Zephyr app integration + XS generated source inclusion
- `Makefile` - local developer workflow (`xs`, `build`, `validate`, `lint`)
- `build.sh` - CI/automation entrypoint
- `scripts/xs-compile.sh` - reusable XS compile helper
- `src/` - Zephyr app entry and XS native registration
- `drivers/` - CC1352P1 init + XS-visible native bindings
- `boards/` - board-specific Zephyr config/overlay
- `examples/` - sample JavaScript programs

## Setup

1. Initialize Zephyr environment (example):
   ```bash
   source ~/zephyrproject/.venv/bin/activate
   west zephyr-export
   ```
2. Ensure tools are available:
   ```bash
   west --version
   xsc -h
   ```
3. Configure TI SDK path (default expects local `simplelink_cc13xx_cc26xx_sdk/`):
   ```bash
   export TI_SIMPLELINK_SDK_DIR=/absolute/path/to/simplelink_cc13xx_cc26xx_sdk
   ```

## Build

Run structure and lint checks:

```bash
make validate
make lint
```

Compile JavaScript to C:

```bash
make xs
```

Build Zephyr firmware:

```bash
make build BOARD=cc1352p1_launchxl TI_SIMPLELINK_SDK_DIR="$TI_SIMPLELINK_SDK_DIR"
```

Or use automation script:

```bash
./build.sh
```

## Configuration Guide

Supported build variables:

- `BOARD` (default: `cc1352p1_launchxl`)
- `BUILD_DIR` (default: `build`)
- `XSC` (default: `xsc`)
- `WEST` (default: `west`)
- `SIMPLELINK_SDK_DIR` / `TI_SIMPLELINK_SDK_DIR`
- `TI_DRIVER_LIBRARIES` (semicolon-separated CMake list)

Example:

```bash
make build \
  BOARD=cc1352p1_launchxl \
  SIMPLELINK_SDK_DIR=/opt/ti/simplelink_cc13xx_cc26xx_sdk_7_xx_xx_xx \
  TI_DRIVER_LIBRARIES="drivers;ti_utils_runtime"
```

## Examples

- `examples/hello-world.js` - basic logging
- `examples/blink-led.js` - LED toggle logic
- `examples/uart-echo.js` - UART echo flow

To compile a specific example without mixing in other `js/*.js` files:

```bash
rm -f js/*.js
cp examples/hello-world.js js/main.js
make xs
```

Or compile directly via helper script:

```bash
./scripts/xs-compile.sh build/xs examples/hello-world.js
```

## Troubleshooting

- `xsc: command not found`
  - Install Moddable tools and ensure `xsc` is on `PATH`.
- `west: command not found`
  - Activate your Zephyr environment before building.
- Missing TI headers/libraries
  - Verify `TI_SIMPLELINK_SDK_DIR` and `TI_DRIVER_LIBRARIES`.
- Duplicate JS basename error
  - Remove same-name files across `.js` and `.javascript` in `js/`.

## Contributing

See `CONTRIBUTING.md`.
