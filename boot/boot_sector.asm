;===========================================
;           HobbyOS
;
;           Author: Madhu Sudhanan
;           Date  : May 25, 2023
;============================================

[org 0x7c00]                ; tell assembler memory location a which this code is loaded by BIOS so it can offset other addresses
KERNEL_OFFSET equ 0x1000

mov bp, 0x9000
mov sp, bp

mov bx, boot_msg            ; mov starting addr of boot_msg
call print_string

mov [boot_drive], dl        ; BIOS stores out boot drive into dl
mov bp, 0x8000
mov sp, bp

call load_kernel

call switch_to_pm

%include "boot/lib16/print_lib.asm"
%include "boot/load_disk.asm"
%include "boot/gdt.asm"

load_kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 1
    mov dl, [boot_drive]
    call load_disk
    ret

[bits 16]
; Switch to protected mode (32-bit)
switch_to_pm:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax                ; Swith to 32-bit protected mode

    jmp CODE_SEGMENT:setup_pm   ; Far jump to flush CPU pipeline

[bits 32]
setup_pm:
    mov ax, DATA_SEGMENT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp
    call start_pm

start_pm:
    mov ebx, MSG_PROT_MODE
    call KERNEL_OFFSET
    jmp $



boot_msg:
    db 'Booting HobbyOS',0  ; null terminated string

MSG_PROT_MODE: db "Successfully landed in 32 - bit Protected Mode" , 0

boot_drive: db 0

times 510 - ($ - $$) db 0   ; padding with 0 since we need total of 512 bytes in a boot sector

dw 0xaa55                   ; magic number to indicate BIOS that this is the boot sector