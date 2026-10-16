%ifndef DATA_ASM
%define DATA_ASM

; Zero-page memory layout
VAR_SNAKE_HEAD  equ 0x7E00
VAR_SNAKE_DIR   equ 0x7E02
VAR_TAIL_PTR    equ 0x7E04
VAR_HEAD_PTR    equ 0x7E06
VAR_FOOD_POS    equ 0x7E08
VAR_PREV_TICK   equ 0x7E0A
VAR_SCORE       equ 0x7E0C
SNAKE_BODY_BUF  equ 0x7E10

%endif