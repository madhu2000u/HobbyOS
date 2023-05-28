
mov ah , 0x0e ; scrolling teletype BIOS routine
; doesn't print X - wrong offset
mov al , value
int 0x10
; doesn't print X - wrong offset
mov al , [value]
int 0x10
; print's X
mov bx , value  ;move offset of "value" within this code to bx
add bx , 0x7c00 ;add it to 7c00 where BIOS loads boot sector by default
mov al , [bx]   ;actuall memory location at which "X" is loaded
int 0x10
jmp $ ; Jump forever.
value :
    db "X"

times 510 -( $ - $$ ) db 0
dw 0xaa55