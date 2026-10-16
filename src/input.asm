%ifndef INPUT_ASM
%define INPUT_ASM

process_input:
    mov ah, 0x01
    int 0x16            
    jz .done            
    xor ah, ah
    int 0x16            
    
    mov di, VAR_SNAKE_DIR
    mov bx, [di]
    
    cmp ah, 0x48        
    je .up
    cmp ah, 0x50        
    je .down
    cmp ah, 0x4B        
    je .left
    cmp ah, 0x4D        
    je .right
    ret

.up:    
    cmp bx, 2560        
    je .done
    mov word [di], -2560
    ret
.down:  
    cmp bx, -2560
    je .done
    mov word [di], 2560
    ret
.left:  
    cmp bx, 8
    je .done
    test bx, bx         
    jz .done
    mov word [di], -8
    ret
.right: 
    cmp bx, -8
    je .done
    mov word [di], 8
.done:
    ret

%endif