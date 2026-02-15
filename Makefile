# --------------------
# Toolchain
# --------------------
CC      := gcc
OBJCOPY := objcopy
STRIP   := strip

CFLAGS  := -Wall -g  -fno-omit-frame-pointer
INCLUDES:= -Iinclude

# --------------------
# Project layout
# --------------------
BUILD_DIR := build
OBJ_DIR   := $(BUILD_DIR)/obj
BIN_DIR   := $(BUILD_DIR)/bin

APP       := $(BIN_DIR)/app
APP_DBG   := $(BIN_DIR)/app.debug

SRC_MAIN := examples/linux/main.c
SRC_CORE := src/core/ledger_core.c

OBJS := \
	$(OBJ_DIR)/main.o \
	$(OBJ_DIR)/ledger_core.o

# --------------------
# Phony targets
# --------------------
.PHONY: build run clean debug-split

# --------------------
# Top-level targets
# --------------------
build: $(APP)

run: $(APP)
	./$(APP)

clean:
	rm -rf $(BUILD_DIR)

# --------------------
# Infrastructure
# --------------------
$(OBJ_DIR) $(BIN_DIR):
	mkdir -p $@

# --------------------
# Compile rules
# --------------------
$(OBJ_DIR)/main.o: $(SRC_MAIN) | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJ_DIR)/ledger_core.o: $(SRC_CORE) | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# --------------------
# Link ELF
# --------------------
$(APP): $(OBJS) | $(BIN_DIR)
	$(CC) $(OBJS) -o $@
	$(MAKE) debug-split

# --------------------
# DWARF split
# --------------------
debug-split:
	$(OBJCOPY) --only-keep-debug $(APP) $(APP_DBG)
	$(STRIP) --strip-debug $(APP)
	$(OBJCOPY) --add-gnu-debuglink=$(APP_DBG) $(APP)
