;===========================================
;           HobbyOS Boot Sector
;
;           Author: Madhu Sudhanan
;           Date  : May 25, 2023
;============================================

[org 0x7c00]    ; tell assembler memory location a which this code is loaded by BIOS so it can offset other addresses

mov ah, 0x0e    ; set higher bytes of ax reg to 0x0e to indicate BIOS routine type to scrolling teletype routine (BIOS routine that prints to screen)

mov bx, boot_msg    ;mov addr of starting addr of boot_msg
call print_string

; call print_string
jmp infi

boot_msg:
    db 'Booting HobbyOS',0  ; null terminated string

print_string:
    pusha
    mov ah, 0x0e
    loop_through_stirng:
        mov al, [bx]    ; mov value at addr [bx], such as 'B' of boot_msg
        int 0x10
        add bx, 1       ; advance to next char addr
        cmp al, 0       ; if 0, we have reached end of string
        jnz loop_through_stirng
    popa
    ret
    

infi:
    jmp $          ; jump indefinitely ($ -> current address)

times 510 - ($ - $$) db 0   ;padding with 0 since we need total of 512 bytes in a boot sector

dw 0xaa55       ; magic number to indicate BIOS that this is the boot sector