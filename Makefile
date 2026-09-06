BOARD ?= cc1352p1_launchxl
BUILD_DIR ?= build
WEST ?= west
XSC ?= xsc
SIMPLELINK_SDK_DIR ?= $(CURDIR)/simplelink_cc13xx_cc26xx_sdk
TI_DRIVER_LIBRARIES ?=
TI_DRIVER_LIBRARIES_ESCAPED := $(subst ;,\;,$(TI_DRIVER_LIBRARIES))

JS_FILES_JAVASCRIPT := $(wildcard js/*.javascript)
JS_FILES_JS := $(wildcard js/*.js)
JS_BASENAMES_JAVASCRIPT := $(basename $(notdir $(JS_FILES_JAVASCRIPT)))
JS_BASENAMES_JS := $(basename $(notdir $(JS_FILES_JS)))
DUPLICATE_JS_BASENAMES := $(filter $(JS_BASENAMES_JS),$(JS_BASENAMES_JAVASCRIPT))
ifneq ($(strip $(DUPLICATE_JS_BASENAMES)),)
$(error Duplicate JS basenames across extensions: $(DUPLICATE_JS_BASENAMES))
endif

JS_SOURCES := $(JS_FILES_JAVASCRIPT) $(JS_FILES_JS)
JS_BASENAMES := $(basename $(notdir $(JS_SOURCES)))
XS_C_DIR := $(BUILD_DIR)/xs
XS_C_SOURCES := $(addprefix $(XS_C_DIR)/,$(addsuffix .c,$(JS_BASENAMES)))

.PHONY: all xs build clean validate lint print-config help

all: build

xs: $(XS_C_SOURCES)

$(XS_C_DIR):
	mkdir -p $@

$(XS_C_DIR)/%.c: js/%.javascript | $(XS_C_DIR)
	$(XSC) -c -o $(XS_C_DIR) $<

$(XS_C_DIR)/%.c: js/%.js | $(XS_C_DIR)
	$(XSC) -c -o $(XS_C_DIR) $<

build: xs
	$(WEST) build -b $(BOARD) -d $(BUILD_DIR)/zephyr $(CURDIR) -- \
		-DAPP_XS_GENERATED_DIR=$(abspath $(XS_C_DIR)) \
		-DTI_SIMPLELINK_SDK_DIR=$(abspath $(SIMPLELINK_SDK_DIR)) \
		-DTI_DRIVER_LIBRARIES=$(TI_DRIVER_LIBRARIES_ESCAPED)

validate:
	@test -f CMakeLists.txt
	@test -f prj.conf
	@test -f build.sh
	@test -f package.json
	@test -f LICENSE
	@test -f CONTRIBUTING.md
	@test -f .editorconfig
	@test -d src
	@test -d js
	@test -d examples
	@test -d drivers
	@test -d boards
	@test -f boards/cc1352p1_launchxl.conf
	@test -f drivers/cc1352p1.c
	@test -f drivers/cc1352p1.h
	@test -f scripts/xs-compile.sh
	@test -f examples/hello-world.js
	@test -f examples/blink-led.js
	@test -f examples/uart-echo.js
	@test -f .github/workflows/build.yml

lint:
	./scripts/check-format.sh
	./scripts/check-js-syntax.sh

print-config:
	@echo "BOARD=$(BOARD)"
	@echo "BUILD_DIR=$(BUILD_DIR)"
	@echo "WEST=$(WEST)"
	@echo "XSC=$(XSC)"
	@echo "SIMPLELINK_SDK_DIR=$(SIMPLELINK_SDK_DIR)"
	@echo "TI_DRIVER_LIBRARIES=$(TI_DRIVER_LIBRARIES)"
	@echo "JS_SOURCES=$(JS_SOURCES)"

clean:
	rm -rf $(BUILD_DIR)
	mkdir -p build
	touch build/.gitkeep

help:
	@echo "Targets:"
	@echo "  make xs        # compile js/*.javascript and js/*.js to C with xsc"
	@echo "  make build     # run west build for $(BOARD)"
	@echo "  make validate  # validate project structure"
	@echo "  make lint      # run formatting and JS syntax checks"
	@echo "  make clean"
