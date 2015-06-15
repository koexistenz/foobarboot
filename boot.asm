[bits 16]

org 0x7c00

sti

mov ah,0x2
mov al,2
mov ch,0
mov cl,1
mov bx,foo
int 0x13
jmp foo

times 0200h - 2 - ($ - $$) db 0
dw 0aa55h

foo:

; clearing the screen
mov ax,0003h
int 0x10

; set cursor 0 0
mov ah,0x2
mov bh,0
mov dh,0
mov dl,0
int 0x10

; prepare to write spaces
mov ah,0x9
mov al,' '
mov bh,0

mov bl,70h
mov cx,0b10000000
int 0x10

mov ah,0x2
mov dh,1
int 0x10

fooh:
mov ah,0x9
mov bl,0b01110000
mov cx,0b1010000
int 0x10

mov ah,0x2
inc dh
int 0x10

mov ah,0x9
mov bl,0b10000000
mov cx,0b1010000
int 0x10

mov ah,0x2
inc dh
int 0x10

cmp dh,25
jle fooh

;--- bis hier funktionierts
	mov ah,0x2							; prepare to set cursor position
	mov dh,4							; set it to line 4
	mov dl,20							; go 20 spaces to the right
	int 0x10							; send dat shit
	blackout:							; label blackout
		cmp dh, 16						; compare dh to 16
		jge textmsg						; jump if greater or equal (to textmsg)
			mov ah,0x9					; prepare to write something to the screen
			mov al,' '					; write a space
			mov bl,0b00000000			; make dat shit black
			mov cx,40					; do it 40 times
			int 0x10					; syscall
			mov ah,0x2					; prepare to set cursor position
			inc dh						; increment dh
			int 0x10					; syscall
			jmp blackout				; jump to blackout
textmsg:
int 0x10
mov bp,dx

hlt
xor ax,ax
mov al,13h
int 0x10

mov bh,0
mov bl,0
MOV AX,0xA000
MOV ES,AX
mov di,0
mov cx,64000
loop:
MOV byte [ES:DI],bl
inc di
inc bh
cmp ax,160
jge bla
loop loop

mov dx,0
	bla:
	cmp bl,120
	cmova bx,dx
	inc bl
	mov ax,0
	loop loop
