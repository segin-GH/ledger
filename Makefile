CC = gcc
CFLAGS = -Wall
INCLUDES = -Iinclude

BUILD_DIR := build
OBJ_DIR   := $(BUILD_DIR)/obj
BIN_DIR   := $(BUILD_DIR)/bin
APP       := $(BIN_DIR)/app

SRC_MAIN := examples/linux/main.c
SRC_CORE := src/core/ledger_core.c

OBJS := \
	$(OBJ_DIR)/main.o \
	$(OBJ_DIR)/ledger_core.o

.PHONY: build run clean

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
# Build rules
# --------------------

$(OBJ_DIR)/main.o: $(SRC_MAIN) | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(OBJ_DIR)/ledger_core.o: $(SRC_CORE) | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(APP): $(OBJS) | $(BIN_DIR)
	$(CC) $(OBJS) -o $@
