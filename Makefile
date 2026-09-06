BOARD ?= cc1352p1_launchxl
BUILD_DIR ?= build
WEST ?= west
XSC ?= xsc
SIMPLELINK_SDK_DIR ?= $(CURDIR)/simplelink_cc13xx_cc26xx_sdk

JS_SOURCES := $(wildcard js/*.javascript js/*.js)
JS_BASENAMES := $(basename $(notdir $(JS_SOURCES)))
XS_C_DIR := $(BUILD_DIR)/xs
XS_C_SOURCES := $(addprefix $(XS_C_DIR)/,$(addsuffix .c,$(JS_BASENAMES)))

.PHONY: all xs build clean validate print-config help

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
		-DTI_SIMPLELINK_SDK_DIR=$(abspath $(SIMPLELINK_SDK_DIR))

validate:
	@test -f CMakeLists.txt
	@test -f prj.conf
	@test -d src
	@test -d js
	@test -d drivers
	@test -d boards
	@test -f .github/workflows/build.yml

print-config:
	@echo "BOARD=$(BOARD)"
	@echo "BUILD_DIR=$(BUILD_DIR)"
	@echo "WEST=$(WEST)"
	@echo "XSC=$(XSC)"
	@echo "SIMPLELINK_SDK_DIR=$(SIMPLELINK_SDK_DIR)"
	@echo "JS_SOURCES=$(JS_SOURCES)"

clean:
	rm -rf $(BUILD_DIR)

help:
	@echo "Targets:"
	@echo "  make xs        # compile js/*.javascript and js/*.js to C with xsc"
	@echo "  make build     # run west build for $(BOARD)"
	@echo "  make validate  # validate project structure"
	@echo "  make clean"
