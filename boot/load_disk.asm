;===========================================
;           HobbyOS
;
;           Author: Madhu Sudhanan
;           Date  : May 30, 2023
;============================================

load_disk:
    push dx             ; Save sectors read request count
    mov ah, 0x02        ; BIOS disk read function
    mov al, dh          ; Number of sectors to read
    mov ch, 0x00        ; Cylinder 0
    mov dh, 0x00        ; Head 0
    mov cl, 0x02        ; Read from sector 2
    int 0x13            ; BIOS interrupt for disk read
    jc gen_disk_err

    pop dx
    cmp dh, al
    jne incorrect_sector_rd_err
    ret

gen_disk_err:
    mov bx, gen_disk_err_msg
    call print_string
    jmp $

incorrect_sector_rd_err:
    mov bx, incorrect_sector_rd_err_msg
    call print_string
    jmp $

gen_disk_err_msg:
    db 'Disk read error!', 0

incorrect_sector_rd_err_msg:
    db 'All sectors were not read!', 0