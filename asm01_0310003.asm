; name: 邱弘毅
; student ID: 0310003
; email address:i314i@yahoo.com.tw

TITLE homework1

INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
	menu0 BYTE "Please select option: ",0
	menu1 BYTE "1. Show colorful frames",13,10,0
	menu1_space BYTE " ",0
	width_count DWORD 70
	height_count DWORD 40
	cur_width BYTE 0
	cur_height BYTE 0
	border_height BYTE 0
	menu2 BYTE "2. Sum up signed integers",13,10,0
	menu3 BYTE "3. Sum up unsigned integers",13,10,0
	menu4 BYTE "4. Compute sin(x)",13,10,0
	menu5 BYTE "5. Show student information",13,10,0
	menu6 BYTE "6. Quit",13,10,0
	newLine BYTE 13,10,0 ;換行
	new BYTE 10,0
	border BYTE "-------------------------------------",13,10,0 
	menu2_1 BYTE "Input the number of signed integers: ",0
	menu2_2 BYTE "Input signed integers: ",0
	menu2_3 BYTE "Signed integers sum: ",0
	menu2_4 BYTE 13,10,"Press a key to return.",0
	menu3_1 BYTE "Input the number of unsigned integers: ",0
	menu3_2 BYTE "Input unsigned integers: ",0
	menu3_3 BYTE "Unsigned integers sum: ",0
	menu3_4 BYTE 13,10,"Press a key to return.",0
	menu4_1 BYTE "Input a float number x= ",0
	menu4_2 BYTE "Input the number of terms n= ",0
	menu4_3 BYTE "sin(x)= ",0
	menu5_1 BYTE "ID: 0310003",13,10,"Name: 邱弘毅",13,10,"Email address: i314i@yahoo.com.tw",13,10,0
	sinn BYTE 0 ;用來存sin的n
	sinncount BYTE 0 ;l;存sin n的fory迴圈計數
	sinx REAL4 1.0 ;存sin的x
	minus1 WORD -1 ;存-1這個數
	count DWORD 1 ;存階乘的counter
	total DWORD 1 ;存2n-1，並且每次遞減2
	textcolor BYTE 0 ;存原先預設的文字顏色
.code

main PROC
	call gettextcolor
	mov textcolor,al
	L0: ;menu loop
	mov edx, OFFSET newline
	call WriteString
	mov edx, OFFSET border
	call WriteString
	mov edx, OFFSET menu1;
	call WriteString
	mov edx, OFFSET menu2;
	call WriteString
	mov edx, OFFSET menu3;
	call WriteString
	mov edx, OFFSET menu4;
	call WriteString
	mov edx, OFFSET menu5;
	call WriteString
	mov edx, OFFSET menu6;
	call WriteString
	mov edx, OFFSET menu0;
	call WriteString
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
	cmp al, 36h
	je L6;
	
	L1: ;option1
	mov ebx, 0
	mov ecx,10;連續印10次
		L1_print: 
			L1_choose_color: 
			call Random32
			and eax, 000000F0h 
			cmp eax, 00000000h ;如果是黑色，那就重選
			je L1_choose_color
			cmp eax, ebx ;顏色相同重選
			je L1_choose_color
		call settextcolor
		mov ebx, eax
		mov eax, 500
		call Delay
		mov dl, border_height
		mov dh, cur_width
		call Gotoxy
		mov eax,ecx
		mov ecx,height_count
		jmp L1_height

		L1_print2:
		jmp L1_print

		L1_height:
		mov bl,border_height
		mov cur_height,bl
		mov ebx,ecx
			mov ecx,width_count ;連續印空白width_count次
				L1_width:
				mov edx, OFFSET menu1_space
				call WriteString
				
				;mov dl, border_height
				;mov dh, cur_width
				;call Gotoxy
				Loop L1_width
				mov edx, OFFSET newline
				call WriteString
			mov ecx,height_count
		mov ecx,ebx
		Loop L1_height
		sub width_count, 3
		sub height_count, 3
		add cur_width, 1
		mov ecx,eax
		Loop L1_print2
	mov eax,0
	mov al, textcolor
	call settextcolor ;設回原本的顏色
	mov edx, OFFSET newline
	call WriteString
	mov edx, OFFSET newline
	call WriteString
	mov dl, 100
	mov dh, 0
	call Gotoxy
	mov cur_width, 0;
	mov cur_height, 0;
	mov border_height, 0;
	jmp L0;

	L2: ;option2
	mov edx, OFFSET menu2_1
	call WriteString
	call ReadInt
	mov ecx, eax
	mov ebx, 0000h ;sum register
		L2_getnum:
		mov edx, OFFSET menu2_2
		call WriteString
		call ReadInt
		add ebx, eax
		loop L2_getnum
	mov edx, OFFSET menu2_3
	call WriteString
	mov eax, ebx
	call WriteInt
	mov edx, OFFSET menu2_4
	call WriteString
	call ReadChar
	mov edx, OFFSET newLine
	call WriteString
	jmp L0; 

	L3: ;option3
	mov edx, OFFSET menu3_1
	call WriteString
	call ReadDec
	mov ecx, eax
	mov ebx, 0000h ;sum register
		L3_getnum:
		mov edx, OFFSET menu3_2
		call WriteString
		call ReadDec
		add ebx, eax
		loop L3_getnum
	mov edx, OFFSET menu3_3
	call WriteString
	mov eax, ebx
	call WriteDec
	mov edx, OFFSET menu3_4
	call WriteString
	call ReadChar
	mov edx, OFFSET newLine
	call WriteString
	jmp L0;

	L4: ;option4
	FINIT
	mov edx, OFFSET menu4_1
	call WriteString
	call ReadFloat
	fstp sinx ;store x
	mov edx, OFFSET menu4_2
	call WriteString
	call ReadInt
	mov sinn,al ;sinn stores the n

	mov sinncount,al;
	cmp al,1 ;if n==1 then load sinx and print don't do any calculate
	jne L4_term_loop
	FLD sinx
	jmp L4_output

	L4_term_loop:
	mov ebx, 2
	mul ebx
	mov ecx, eax
	dec ecx ;2n-1
	mov total, ecx ;total=2n-1 decrease by 2 every loop
	FLDZ ;load zero to the stack L4_1

	L4_check_term_sign:
	mov dl, sinncount
	and edx, 00000001h

	FLD1
	cmp edx, 0 
	jne L4_cal_factory_x
	FILD minus1 ;if even term load -1 and multiply with the top 1
	fmul
		L4_cal_factory_x: 
			mov count, ecx
			FLD sinx
			fmul
			FILD count
			fdiv
		Loop L4_cal_factory_x
	mov bl, sinncount
	dec sinncount ;decrease n counter
	dec total ;decrease 2n+1 counter by 2
	dec total
	mov ecx, total
	mov bl,sinncount
	FADD ;add two terms
	cmp ebx, 1 ;if n counter not equal 1, keep doing
	jne L4_check_term_sign

	FLD sinx ;load the first term x and add
	FADD

	L4_output: ;output
	mov edx, OFFSET menu4_3
	call WriteString
	call WriteFloat
	mov edx, OFFSET newline
	call WriteString
	
	jmp L0;

	L5: ;option5
	mov edx, OFFSET menu5_1
	call WriteString
	jmp L0;

	L6: ;option6 
		exit 
main ENDP
END main