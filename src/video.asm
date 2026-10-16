%ifndef VIDEO_ASM
%define VIDEO_ASM

init_video_mode:
    mov ax, 0x0013
    int 0x10
    push 0xA000
    pop es
    ret

; Draw 8x8 block
draw_block:
    push di
    mov dx, 8           
.row:
    mov cx, 8           
    rep stosb
    add di, 312
    dec dx
    jnz .row
    pop di
    ret

%endif