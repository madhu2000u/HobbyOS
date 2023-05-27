;===========================================
;           HobbyOS Boot Sector
;
;           Author: Madhu Sudhanan
;           Date  : May 25, 2023
;============================================

mov ah, 0x0e    ; set higher bytes of ax reg to 0x0e to indicate BIOS routine type to scrolling teletype routine (BIOS routine that prints to screen)

mov al, 'H'     ; set ASCII character to be printed on screen to lower bytes of ax reg
int 0x10        ; call scrolling teletype BIOS routine by giving an interupt insruction
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10
mov al, '!'
int 0x10

;Print A to Z
mov al, 'A'
mov bx, 26
jmp loop
loop:
    int 0x10    ;call screen interupt
    add al, 1   ;increment ASCII value
    sub bx, 1   ;decrement count
    cmp bx, 0   ;check if bx is 0
    jnz loop    ;if not zero, loop back and keep printing
    jmp infi    ;if zero jump to infi

infi:
    jmp $          ; jump indefinitely ($ -> current address)

times 510 - ($ - $$) db 0

dw 0xaa55       ; magic number to indicate BIOS that this is the boot sector