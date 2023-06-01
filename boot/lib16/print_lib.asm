;===========================================
;           HobbyOS
;
;           Author: Madhu Sudhanan
;           Date  : May 30, 2023
;============================================

print_string:
    pusha
    mov ah, 0x0e        ; set higher bytes of ax reg to 0x0e to indicate BIOS routine type to scrolling teletype routine (BIOS routine that prints to screen)
    loop_through_stirng:
        mov al, [bx]    ; mov value at addr [bx], such as 'B' of boot_msg
        int 0x10
        add bx, 1       ; advance to next char addr
        cmp al, 0       ; if 0, we have reached end of string
        jnz loop_through_stirng
    popa
    ret
    
print_hex:
    pusha
    mov ax, dx  ; mov hex value to ax for manipulation
    mov bx, 0xf000  ; mov initial mask (we want to extraxt first 4-bits of hex value)
    mov cl, 12      ; shift amount
    mov dx, hex_template    ;store starting byte address of hex_template to later manipulate it
    add dx, 2               ; skip '0x' text
    loop_through_hex:
        push ax     ; save reg values before using them for other purpose below
        push bx

        and ax, bx
        shr ax, cl
        push ax
        mov bl, 10
        div bl
        mov al, ah
        mov ah, 0x0e
        pop bx
        cmp bx, 0x09        ; check if bx is less than or equal to 9
        jle digits
        add al, 'a'         ; if alphabet, add base ascii code
        jmp continue
        digits:
            add al, '0'     ; if digit, add base ascii code
        continue:
            mov bx, dx
        mov [bx], al
        inc dx

        ;restore original reg values
        pop bx          ;always pop first to the reg that was pushed last since it is a stack
        pop ax
        shr bx, 4
        sub cl, 4
        cmp bx, 0x0     ;if mask is 0 then we are done with all hex digits
        jnz loop_through_hex
    mov bx, hex_template
    call print_string
    popa
    ret

    hex_template:
        db '0x0000',0