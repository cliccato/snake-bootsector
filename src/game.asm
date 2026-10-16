%ifndef GAME_ASM
%define GAME_ASM

init_game_state:
    mov ax, 0x0A0A      ; Light green background (0x0A)
    xor di, di
    mov cx, 32000
    rep stosw           

    mov al, 0x02        ; Dark green borders (0x02)
    mov di, 2560
    mov cx, di
    rep stosb           
    
    mov di, 61440
    mov cx, 2560
    rep stosb           
    
    mov cx, 22
    mov di, 5120
.borders:
    push cx
    push di
    call draw_block
    add di, 312
    call draw_block
    pop di
    add di, 2560
    pop cx
    loop .borders

    xor ax, ax
    mov word [VAR_SNAKE_DIR], ax
    mov word [VAR_TAIL_PTR], ax
    mov word [VAR_SCORE], ax
    mov word [VAR_HEAD_PTR], 4

    mov ax, 30880
    mov [VAR_SNAKE_HEAD], ax
    mov si, SNAKE_BODY_BUF
    mov [si + 4], ax
    sub ax, 8
    mov [si + 2], ax
    sub ax, 8
    mov [si], ax

    mov di, [si]
    mov al, 0x00        ; Black body (0x00)
    call draw_block
    mov di, [si + 2]
    call draw_block
    mov di, [si + 4]
    mov al, 0x18        ; Dark gray head (0x18)
    call draw_block

    call draw_score
    call spawn_food
    ret

draw_score:
    xor di, di
    mov ax, 0x0A0A      ; Light green HUD background
    mov cx, 1280
    rep stosw

    mov ah, 0x02
    xor bh, bh
    xor dx, dx
    int 0x10

    mov ax, [VAR_SCORE]
    mov cx, 10
    xor bx, bx
.div_loop:
    xor dx, dx
    div cx
    push dx
    inc bx
    test ax, ax
    jnz .div_loop

.print_loop:
    pop ax
    add al, '0'
    mov ah, 0x0E
    push bx
    mov bl, 0x02        ; FIX: Dark green score text (avoids BIOS 0x00 transparency bug)
    int 0x10
    pop bx
    dec bx
    jnz .print_loop
    ret

spawn_food:
.retry:
    in al, 0x40
    mov ah, al
    in al, 0x40
    xor ax, [0x046C]

    xor dx, dx
    mov cx, 836         
    div cx
    mov ax, dx
    mov cl, 38
    div cl              
    
    inc ah              
    add al, 2           

    mov bl, ah
    xor bh, bh
    shl bx, 3           

    xor ah, ah
    mov cx, 2560        
    mul cx              
    add ax, bx
    mov di, ax

    mov al, [es:di]
    cmp al, 0x0A        ; Check if empty space (light green)
    jne .retry          

    mov [VAR_FOOD_POS], di
    mov al, 0x28        ; Bright red food
    call draw_block
    ret

game_step:
    mov ax, [0x046C]
    cmp ax, [VAR_PREV_TICK]
    je .skip
    mov [VAR_PREV_TICK], ax

    mov bx, [VAR_SNAKE_DIR]
    test bx, bx 
    jz .skip

    mov di, [VAR_SNAKE_HEAD]
    add di, bx
    mov [VAR_SNAKE_HEAD], di

    mov al, [es:di]
    cmp al, 0x0A        ; Check if empty space
    je .empty           
    cmp al, 0x28
    je .ate             
    jmp game_over       

.empty:
    mov bx, [VAR_TAIL_PTR]
    mov di, [SNAKE_BODY_BUF + bx]
    mov al, 0x0A        ; Erase tail with light green
    call draw_block

    add bx, 2
    and bx, 0x07FE      
    mov [VAR_TAIL_PTR], bx
    jmp .advance
    
.ate:
    inc word [VAR_SCORE]
    call draw_score
    call spawn_food
    
.advance:
    mov bx, [VAR_HEAD_PTR]
    mov di, [SNAKE_BODY_BUF + bx]
    mov al, 0x00        ; Old head becomes black body
    call draw_block

    add bx, 2
    and bx, 0x07FE
    mov [VAR_HEAD_PTR], bx
    mov di, [VAR_SNAKE_HEAD]
    mov [SNAKE_BODY_BUF + bx], di

    mov al, 0x18        ; Draw new dark gray head
    call draw_block

.skip:
    ret

game_over:
.flush:
    mov ah, 0x01
    int 0x16            
    jz init_game_state  ; Restart instantly when buffer is clear
    xor ah, ah
    int 0x16            
    jmp .flush          

%endif