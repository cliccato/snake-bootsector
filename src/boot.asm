[org 0x7C00]
[bits 16]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    call init_video_mode
    call init_game_state

main_loop:
    call process_input
    call game_step
    hlt
    jmp main_loop

%include "src/data.asm"
%include "src/video.asm"
%include "src/input.asm"
%include "src/game.asm"

times 510 - ($ - $$) db 0
dw 0xAA55