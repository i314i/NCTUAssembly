; name: ªô¥°¼Ý
; student ID: 0310003
; email address:i314i@yahoo.com.tw

TITLE homework2

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
	menu0 BYTE " Please select option......                          ",0
	menu1 BYTE " 1) Change the space ship color                      ",0
	menu2 BYTE " 2) Show a frame around the screen rectangular area  ",0
	menu3 BYTE " 3) Play a game                                      ",0
	menu4 BYTE " 4) Show student information                         ",0
	menu5 BYTE " 5) Quit                                             ",0

	menu1_1 BYTE "     Please select a color for the space ship.     ",0
	menu1_2 BYTE "       1               2                3          ",0
	sound BYTE 7, 0 ;sound

	menu4_1 BYTE "ID: 0310003",13,10,"Name: ªô¥°¼Ý",13,10,"Email address: i314i@yahoo.com.tw",13,10,0
	
	newLine BYTE 13,10,0 ;´«¦æ
	border BYTE "-------------------------------------",13,10,0
	space BYTE " ",0
	
	wid DWORD 0 ; block width and height
	height DWORD 0

	x BYTE 0 ;coordinate
	y BYTE 0 
	maxx BYTE 0 ;console height and width
	maxy BYTE 0
	xshift BYTE 0 ;shift to the middle of the console
	spaceShipColor BYTE 11101111b
	color BYTE 0 ; current color to print

	count BYTE 0

	spaceShipStr BYTE "      ",0
	spaceShipShortStr BYTE "  ",0
	spaceShipLongStr BYTE "           ",0

.code

main PROC
	call GetMaxXY ;set some parameters
	mov maxx, dl
	mov maxy, dh
	mov ax,0
	mov al,maxx
	mov bl, 2
	div bl
	sub al,30
	mov xshift,al

	menu: ;get input and choose option
	mov height, 9
	mov wid, 57
	mov x, 0
	mov y, 0
	mov bl, spaceShipColor
	mov color, bl
	call Clrscr
	call drawBlock
	call showMenu
	
	call ReadChar
	call WriteChar
	mov edx, OFFSET newLine
	call WriteString
	mov edx, OFFSET border
	call WriteString
	mov edx, OFFSET newline
	call WriteString
	cmp al, 31h
	je L1;
	cmp al, 32h
	je L2;
	cmp al, 33h
	je L3;
	cmp al, 34h
	je L4;
	cmp al, 35h
	je L5;

	L1:
		call option1;
		jmp menu;
	L2:
		call option2;
		jmp menu;
	L3:
		call option3;
		jmp menu;
	L4:
		call option4;
		jmp menu;
	L5:
		exit

main ENDP

showMenu PROC ;show menu
	mov eax, 0
	mov al, 00001111b
	call settextcolor
	mov dl, 2
	mov dh, 1
	call GotoXY
	mov edx, OFFSET menu1;
	call WriteString
	mov dl, 2
	mov dh, 2
	call GotoXY
	mov edx, OFFSET menu2;
	call WriteString
	mov dl, 2
	mov dh, 3
	call GotoXY
	mov edx, OFFSET menu3;
	call WriteString
	mov dl, 2
	mov dh, 4
	call GotoXY
	mov edx, OFFSET menu4;
	call WriteString
	mov dl, 2
	mov dh, 5
	call GotoXY
	mov edx, OFFSET menu5;
	call WriteString
	mov dl, 2
	mov dh, 6
	call GotoXY
	mov edx, OFFSET menu0
	call WriteString
	ret
showMenu ENDP

option1 PROC
	call Clrscr
	
	mov dl,xshift
	mov dh,0
	call gotoxy
	mov edx, OFFSET menu1_1
	call WriteString

	mov bl,5 ;draw first block
	add bl,xshift
	mov x,bl
	mov y,2
	mov wid, 6
	mov height, 3
	mov color, 11100000b
	call drawblock

	mov bl,21 ;draw second block
	add bl,xshift
	mov x,bl
	mov color, 10100000b
	call drawblock

	mov bl,38 ;draw third block
	add bl,xshift
	mov x,bl
	mov color, 00010000b
	call drawblock

	mov dl,0
	add dl,xshift
	mov dh,5
	call gotoxy
	mov al, 00001111b
	call settextcolor
	mov edx, OFFSET menu1_2
	call WriteString

	call ReadChar
	mov edx, offset sound
	call writeString
	cmp al, 31h
	je op1_1;
	cmp al, 32h
	je op1_2;
	cmp al, 33h
	je op1_3;

	op1_1:
		mov spaceShipColor, 11100000b
		ret
	op1_2:
		mov spaceShipColor, 10100000b
		ret
	op1_3:
		mov spaceShipColor, 00010000b
		ret
option1 ENDP

option2 PROC
	call Clrscr
	mov dl, 0
	mov dh, 0
	mov al, spaceShipColor
	call settextcolor

	mov ecx,0
	mov cl,25 ;height of the frame
	mov eax, 50
	west:
		call gotoxy
		mov al," "
		call writechar
		call delay
		inc dh
	loop west
	mov cl,100 ;width of the frame
	south:
		call gotoxy
		mov al," "
		call writechar
		call delay
		inc dl
	loop south
	mov cl,25
	east:
		call gotoxy
		mov al," "
		call writechar
		call delay
		dec dh
	loop east
	mov cl,150
	north:
		call gotoxy
		mov al," "
		call writechar
		call delay
		dec dl
	loop north

	call ReadChar
	mov eax, 0;
	mov al, 00001111b
	call settextcolor
	ret
option2 ENDP

option3 PROC
	call Clrscr
	mov x,0
	mov y,10
	mov ecx, 0
	mov cl, maxx
	mov bl, maxx
	sub bl, 6
	mov count,bl

	moveSpaceShip:
		cmp al, 65h ;determine input
		je moveUp;
		cmp al, 63h
		je moveDown;
		cmp al, 20h
		je quit

		jmp option3_draw

		moveUp:
		call clearShip
		dec y
		jmp option3_draw

		moveDown:
		call clearShip
		inc y
		jmp option3_draw

		moveSpaceShip1:
		jmp moveSpaceShip

		option3_draw:
		mov eax,50
		call delay
		mov eax,0

		mov al, 00000000b ;draw black block
		call settextcolor
		mov dl, x
		mov dh, y
		call gotoxy
		mov edx, offset spaceShipShortStr
		call writeString

		mov al, spaceShipColor ;draw spaceship
		call settextcolor
		mov edx, offset spaceShipStr
		call writeString
		inc x
		mov cl,count
		dec count
		call readKey
		dec cl
	cmp cl, 0
	jne moveSpaceShip1

	quit:
	mov eax, 0;
	mov al, 00001111b
	call settextcolor
	ret
option3 ENDP

option4 PROC
	call Clrscr
	mov edx, OFFSET menu4_1
	call WriteString
	call readchar
	ret
option4 ENDP

clearShip PROC ;clear option3 spaceship
	mov dl, x
	mov dh, y
	call gotoxy
	mov eax, black + (black*16 )
	call settextcolor
	mov edx, offset spaceShipLongStr
	call writeString
	ret
clearShip ENDP

drawBlock PROC ;draw a big block
	mov eax, 0
	mov dl, x
	mov dh, y
	call gotoxy
	mov al, color
	call SetTextColor
	mov ebx, height
	mov ecx, ebx
	drawLine:
		mov ecx, wid
		drawSpace:
			mov al, " "
			call WriteChar
		Loop drawSpace
	inc dh
	call gotoxy
	dec ebx 
	mov ecx, ebx
	Loop drawLine
	ret
drawBlock ENDP

END main

