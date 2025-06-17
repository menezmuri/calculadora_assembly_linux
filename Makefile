# Makefile para calculadora_fp (Assembly x86_64 com NASM e GCC)

ASM = nasm
ASMFLAGS = -g -F dwarf -f elf64
LD = gcc
LDFLAGS = -g -no-pie
SRC = calculadora_fp.asm
OBJ = calculadora_fp.o
BIN = calculadora_fp

all: $(BIN)

$(OBJ): $(SRC)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BIN): $(OBJ)
	$(LD) $(LDFLAGS) $< -o $@

run: $(BIN)
	./$(BIN)

clean:
	rm -f $(OBJ) $(BIN)
