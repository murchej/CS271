TITLE Program 2    (Proj02.asm)

; Author: Joseph Murche
; Last Modified: 1/19/22
; OSU email address: murchej@oregonstate.edu
; Course number/section: CS_271_001_W2022
; Assignment Number:      2           Due Date: 1/23/22
; Description: Write a program to calculate Fibonacci numbers.

;		1. Display the program title and the programmer's name.
;		2. Prompt the user to enter the number of Fibonacci terms to be displayed.
;		3. Get and validate the user input (n).
;		4. Calculate and display all of the Fibonacci numbers up to and including the nth term. The results should be displayed 4 terms per line with at least 5 spaces between terms.
;		5. Display a parting message that includes the user’s name, and terminate the program.


INCLUDE Irvine32.inc



.data

;string data

		intro			byte	"My Name is Joseph Murche, Welcome to my program!", 0
		programtitle	byte	"Program Title: Write a program to calculate Fibonacci numbers.", 0
		extracredit		byte	"**EC: (1pt) Display the numbers in aligned columns.", 0
		username		byte	"What is your name?", 0
		storeusername	byte	30 DUP(0)										
		greeting		byte	"Hello there, ", 0
		instruct1		byte	"Please enter the number of Fibonacci terms to be displayed.", 0
		instruct2		byte	"Please be sure provide the number as an integer in the range [1..46].", 0
		fibterms		byte	"How many Fibonacci terms would you like to see today?", 0
		errormess		byte	"Out of range! Enter a number in [1..46].", 0
		results			byte	"Results certified by Joseph Murche.", 0
		goodbye			byte	"Goodbye, ", 0
		onetab			byte	"	", 0
		twotabs			byte	"		", 0


;number data

		fibonaccinum	DWORD	?
		fibonaccimax	DWORD	46
		fibonaccimin	DWORD	1
		fibonacci0		DWORD	0
		fibonacci1		DWORD	1
		mark			DWORD	0
		inline			DWORD	0



.code
main PROC


;display the program title and author name

		mov		edx, OFFSET intro
		call	WriteString
		call	CrLf

		mov		edx, OFFSET	programtitle
		call	WriteString
		call	CrLf



;display extra point

		mov		edx, OFFSET	extracredit
		call	WriteString
		call	CrLf



;ask user for name and greet them

		mov		edx, OFFSET username
		call	WriteString
		mov		edx, OFFSET storeusername
		mov		ecx, SIZEOF	storeusername
		call	ReadString
		
		mov		edx, OFFSET	greeting
		call	WriteString
		mov		edx, OFFSET	storeusername
		call	WriteString
		call	CrLf



;display instructions

		mov		edx, OFFSET instruct1
		call	WriteString
		call	CrLf

		mov		edx, OFFSET instruct2
		call	WriteString
		call	CrLf



;Fibonacci Section

FIBONACCI:

;getting fibonacci input

		mov		edx, OFFSET	fibterms
		call	WriteString
		call	ReadInt
		mov		fibonaccinum, eax
		mov		edx, fibonaccinum
		cmp		edx, fibonaccimin
		jl		ERROR
		cmp		edx, fibonaccimax
		jg		ERROR
		jmp		INITIAL_INPUT




;error message

ERROR:

		mov		edx, OFFSET errormess
		call	WriteString
		call	CrLf
		jmp		FIBONACCI




;print first term for calculation

INITIAL_INPUT:

		mov		ecx, fibonaccinum




;calculation section

CALCULATION:

		mov		eax, fibonacci0
		mov		ebx, fibonacci1
		add		eax, ebx

		mov		fibonacci0, ebx
		mov		fibonacci1,	eax
		inc		inline
		inc		mark
		jmp		CHECK_LINE



;check if we need a new line or not

CHECK_LINE:

		mov		edx, inline
		cmp		edx, 5
		jg		NEWLINE
		jmp		PRINT_FIBONACCI



;print a new line

NEWLINE:

		call	CrLf
		mov		inline, 1
		jmp		PRINT_FIBONACCI





;print the fibonacci sequence

PRINT_FIBONACCI:
		
		mov		eax, fibonacci0
		call	WriteDec
		cmp		mark, 30    ;spacing for columns
		jg		SPACE
		mov		edx, OFFSET onetab
		call	WriteString
		call	CrLf
		


;print tabs for larger numbers

SPACE:

		mov		edx, OFFSET	twotabs
		call	WriteString
		loop	CALCULATION




;goodbye, display terminating message

		call	CrLf
		mov		edx, OFFSET results
		call	WriteString
		call	CrLf

		mov		edx, OFFSET	goodbye
		call	WriteString
		mov		edx, OFFSET	storeusername
		call	WriteString
		

	
	
	exit	; exit to operating system
main ENDP



END main
