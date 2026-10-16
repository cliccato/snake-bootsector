# Snake Bootsector

A fully playable bare-metal Snake game written in x86 assembly, fitting entirely within a single 512-byte boot sector. No operating system required.

## Features
- **Bare-metal execution**: Runs directly on the hardware (16-bit x86 Real Mode).
- **Extremely small**: The entire game logic, graphics, and input handling fit in exactly 512 bytes.
- **Custom graphics**: Uses VGA Mode 13h with a minimal, retro color palette.
- **Full gameplay**: Includes score tracking, food spawning, and collision detection (walls and self).

## Build and Run

To compile and play the game, you need `nasm` (assembler) and `qemu-system-i386` (emulator).

```bash
# Compile the binary and run it immediately in QEMU
make run

# Or just compile and verify the 512-byte size constraint
make
```

## Controls
- **Arrow Keys**: Change direction
- **Any Key (on Game Over)**: Instantly restart the game

---

<sub>*Inspired by [eklavya-raj/flappy-512](https://github.com/eklavya-raj/flappy-512).*</sub>