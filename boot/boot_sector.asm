;===========================================
;           HobbyOS Boot Sector
;
;           Author: Madhu Sudhanan
;           Date  : May 25, 2023
;============================================

loop:
    jmp loop

times 510 - ($ - $$) db 0

dw 0xaa55       ; magic number
