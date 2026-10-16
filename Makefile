ASM       := nasm
QEMU      := qemu-system-i386
SRC       := src/boot.asm src/data.asm src/video.asm src/input.asm src/game.asm
TARGET    := snake512.bin

.PHONY: all run check clean disassemble

all: $(TARGET) check

$(TARGET): $(SRC)
	$(ASM) -f bin src/boot.asm -o $(TARGET)

check: $(TARGET)
	@SIZE=$$(stat -c%s $(TARGET) 2>/dev/null || stat -f%z $(TARGET)); \
	echo "Target binary size: $$SIZE bytes"; \
	if [ "$$SIZE" -eq 512 ]; then \
		echo "SUCCESS: Exactly 512 bytes (Single Boot Sector)."; \
	else \
		echo "ERROR: Size constraint failed! Expected 512 bytes, got $$SIZE."; \
		exit 1; \
	fi
	@echo "Checking boot signature (0x55 0xAA at offset 510)..."
	@python3 -c "b = open('$(TARGET)', 'rb').read(); assert b[510:512] == b'\x55\xaa', 'Invalid MBR signature'; print('Signature OK: 0xAA55 verified.')"

run: $(TARGET)
	$(QEMU) -drive format=raw,file=$(TARGET),index=0,if=floppy

disassemble: $(TARGET)
	ndisasm -b 16 $(TARGET)

clean:
	rm -f $(TARGET)