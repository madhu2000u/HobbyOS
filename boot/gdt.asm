gdt_start:

null_descriptor:
    dd 0x0
    dd 0x0

code_descriptor:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

data_descriptor:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

; Declare size of descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start                   ; Start address of gdt

; Constants for later use
CODE_SEGMENT equ code_descriptor - gdt_start
DATA_SEGMENT equ data_descriptor - gdt_start