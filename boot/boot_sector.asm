;===========================================
;           HobbyOS
;
;           Author: Madhu Sudhanan
;           Date  : May 25, 2023
;============================================

[org 0x7c00]                ; tell assembler memory location a which this code is loaded by BIOS so it can offset other addresses

mov bx, boot_msg            ; mov starting addr of boot_msg
call print_string

mov [boot_drive], dl        ; BIOS stores out boot drive into dl
mov bp, 0x8000
mov sp, bp

; mov bx, 0x0000
; mov es, bx
mov dl, [boot_drive]        
mov dh, 2                   ; Read 2 sectors
mov bx, 0x9000              ; Load the read sectores into address es:bx (segment addressing)
call load_disk

mov dx, [0x9000]
call print_hex

jmp $                       ; jump indefinitely ($ -> current address)

%include "./lib16/print_lib.asm"
%include "load_disk.asm"

boot_msg:
    db 'Booting HobbyOS',0  ; null terminated string

boot_drive: db 0

times 510 - ($ - $$) db 0   ; padding with 0 since we need total of 512 bytes in a boot sector

dw 0xaa55                   ; magic number to indicate BIOS that this is the boot sector

times 256 dw 0xabcd         ; sector 2 (512 bytes)
times 256 dw 0x1f34         ; sector 3