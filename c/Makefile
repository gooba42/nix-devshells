CC=gcc
CFLAGS=-Wall -Wextra -O2
SRC=$(wildcard src/*.c)
OBJ=$(SRC:.c=.o)
BIN=build/main

all: $(BIN)

$(BIN): $(OBJ)
	@mkdir -p build
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -rf build *.o src/*.o

test:
	@echo "No tests defined. Add your test targets here."

.PHONY: all clean test
