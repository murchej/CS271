TITLE Program 1		(Proj01.asm)

; Author: Joseph Murche
; Last Modified: 1/12/22
; OSU email address: murchej@oregonstate.edu
; Course number/section: CS_271_001_W2022
; Assignment Number:    1             Due Date: 1/16/22
; Description: Write MASM code to perform the following tasks:
;		1. Display your name and program title on the output screen.
;		2. Display instructions for the user.
;		3. Prompt the user to enter two numbers.
;		4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
;		5. Display a terminating message.


INCLUDE Irvine32.inc


.data

; strings data
	
		myname		byte	"Hi there, my name is Joseph", 0
		progtitle	byte	"Program Title: Program 1", 0
		extracred1	byte	"**EC1: Program verifies second number to be less than first.", 0
		extracred2	byte	"**EC2: Display the square of each number.", 0
		instruction	byte	"Enter two numbers and I will show you the sum, difference, product, quotient, and remainder.", 0
		enter1		byte	"Enter the first number: ", 0
		enter2		byte	"Enter the second number: ", 0
		symb_sum	byte	" + ", 0
		symb_diff	byte	" - ", 0
		symb_prod	byte	" * ", 0
		symb_div	byte	" / ", 0
		symb_equal	byte	" = ", 0
		remainder	byte	" remainder ", 0
		squareof	byte	"Square of ", 0
		errormess	byte	"The second number must be less than the first one. Please enter again.", 0
		terminate	byte	"Impressed? Bye!", 0


; numbers data

		input1	DWORD	?
		input2	DWORD	?
		sum		DWORD	?
		diff	DWORD	?
		prod	DWORD	?
		quotnt	DWORD	?
		remain	DWORD	?
		square1	DWORD	?
		square2	DWORD	?





.code
main PROC

;  Display your name and program title on the output screen

	mov			edx, OFFSET		myname
	call	WriteString
	call	CrLf
	mov			edx, OFFSET		progtitle
	call	WriteString
	call	CrLf


; Display extra credit

	mov		edx, OFFSET	extracred1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	extracred2
	call	WriteString
	call	CrLf


; Display user instructions

	mov		edx, OFFSET	instruction
	call	WriteString
	call	CrLf


USER_INPUT:


; let the user enter the first input

	mov		edx, OFFSET	enter1
	call	WriteString
	call	CrLf

	mov		edx, OFFSET	input1
	call	WriteString
	call	ReadInt
	mov		input1,eax



; let the user enter the second input

	mov		edx, OFFSET	enter2
	call	WriteString
	call	CrLf

	mov		edx, OFFSET	input2
	call	WriteString
	call	ReadInt
	mov		input2,eax


; check that the second number is less than the first
; extra credit point 1

; if first input is less than second input

	mov		eax, input1
	mov		ebx, input2
	cmp		eax, ebx
	ja		CALCULATIONS

	mov		edx, OFFSET		errormess		; show error message if second number needs to be bigger
	call	WriteString
	call	CrLf
	jmp		USER_INPUT					; jump back to userinput, let user try to enter again
	

CALCULATIONS:

; Calculations section

; calculate sum

	mov		eax, input1
	mov		ebx, input2
	add		eax, ebx
	mov		sum, eax


; calculate difference

	mov		eax, input1
	mov		ebx, input2
	sub		eax, ebx
	mov		diff, eax


; calculate product

	mov		eax, input1
	mov		ebx, input2
	mul		ebx
	mov		prod, eax


; calculate quotient
	
	mov		edx, 0
	mov		eax, input1
	mov		ebx, input2
	div		ebx
	mov		quotnt, eax
	mov		remain, edx


; calculate square
; extra credit point

	mov		eax, input1
	mov		ebx, input1
	mul		ebx
	mov		square1, eax

	mov		eax, input2
	mov		ebx, input2
	mul		ebx
	mov		square2, eax



; display section

; display sum

	mov		eax, input1
	call	WriteDec
	mov			edx, OFFSET	symb_sum
	
	call	WriteString
	mov		eax, input2
	call	WriteDec
	mov			edx, OFFSET	symb_equal
	call	WriteString
	
	mov		eax, sum
	call	WriteDec
	call	CrLf


; display difference

	mov		eax, input1
	call	WriteDec
	mov			edx, OFFSET symb_diff
	call	WriteString
	
	mov		eax, input2
	call	WriteDec
	mov			edx, OFFSET symb_equal
	call	WriteString
	
	mov		eax, diff
	call	WriteDec
	call	CrLf


; display product

	mov		eax, input1
	call	WriteDec
	mov			edx, OFFSET symb_prod
	call	WriteString

	mov		eax, input2
	call	WriteDec
	mov			edx, OFFSET symb_equal
	call	WriteString

	mov		eax, prod
	call	WriteDec
	call	CrLf


; display quotient and the remainder

	mov		eax, input1
	call	WriteDec
	mov			edx, OFFSET symb_div
	call	WriteString

	mov		eax, input1
	call	WriteDec
	mov			edx, OFFSET symb_equal
	call	WriteString

	mov		eax, quotnt
	call	WriteDec
	mov			edx, OFFSET remainder
	call	WriteString

	mov		eax, remain
	call	WriteDec
	call	CrLf


; display square1

	mov			edx, OFFSET squareof
	call	WriteString
	mov		eax, input1
	call	WriteDec
	
	mov			edx, OFFSET symb_equal
	call	WriteString
	
	mov		eax, square1
	call	WriteDec
	call	CrLf


; display square2

	mov			edx, OFFSET squareof
	call	WriteString
	mov		eax, input2
	call	WriteDec

	mov			edx, OFFSET symb_equal
	call	WriteString

	mov		eax, square2
	call	WriteDec
	call	CrLf


; display the terminating message

	mov		edx, OFFSET terminate
	call	WriteString
	call	CrLf

	
	exit	; exit to operating system

main ENDP


END main
