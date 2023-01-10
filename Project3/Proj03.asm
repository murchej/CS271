TITLE Program 3     (Proj03.asm)

; Author: Joseph Murche
; Last Modified: 1/26/22
; OSU email address: murchej@oregonstate.edu
; Course number/section: CS_271_001_W2022
; Assignment Number:       3          Due Date: 1/30/22
; Description: Write a MASM program to perform the following tasks:
;			1. Display the program title and programmer’s name.
;			2. Get the user's name, and greet the user.
;			3. Display instructions for the user.
;			4. Repeatedly prompt the user to enter the number. 
;			5. Validate the user input to be in [-100, -1] (inclusive). 
;			6. Count and accumulate the valid user numbers until a non-negative number is entered (The non-negative number is discarded)
;			7. Calculate the (rounded integer) average of the negative numbers
;			8. Display:
;				- The number of negative numbers entered (Note: if no negative numbers were entered, display a special message and display the goodbye message with the user's name at the end).
;				- The sum of negative numbers entered.
;				- The average, rounded to the nearest integer (e.g., -20.5 rounds to -21).
;				- A goodbye message that includes the user’s name, and terminate the program.

INCLUDE Irvine32.inc


MINIMUM = -100	; minimum integer




.data

	; strings

		intro		BYTE	"Welcome to the Integer Accumulator by Joseph Murche.", 0	; program title and author name/welcome
		username	BYTE	33 DUP(0)													; string entered by user for their name
		prompt1		BYTE	"What is your name?", 0										; ask user for their name
		greeting	BYTE	"Hello, ", 0												; greeting
		prompt2		BYTE	"Please enter numbers in [-100, -1]", 0						; ask user for integers	
		
		prompt3		BYTE	"Enter a non-negative number when you are finished to see results.", 0		; see results
		userinput	BYTE	"Enter a number:", 0										; ask for input		
		errormess	BYTE	"Invalid number, please enter numbers in [-100, -1].", 0	; error message
		negativesum	BYTE	"Sum of negative numbers is: ", 0							; sum of neg numbers
		roundedavg	BYTE	"The rounded average is: ", 0								; rounded average
		validresult	BYTE	"Valid numbers entered: ", 0								; num of valid numbers
		thanks		BYTE	"Thank you for playing Integer Accumulator!", 0				; thanks to user
		goodbye		BYTE	"Goodbye, ", 0												; goodbye to user
		special		BYTE	"Oh for pete sake, it looks like you didn't enter any negative integers :(", 0		;special msg
		zerrormess	BYTE	"Invalid input, unable to divide by zero", 0		; error message for div by 0

	; integers

		usernumber	DWORD	?		; user negative int
		total		DWORD	0		; holds int total
		sum			DWORD	0		; holds int sum
		average		DWORD	0		; int average
		linecount	DWORD	0		; counts lines
		remainder	DWORD	0		; division remainder
		quotient	DWORD	0		; holds quotient
		
		


.code
main PROC


INTRODUCTION:

; introduction

		mov		edx, OFFSET intro
		call	WriteString
		call	CrLf


; get user name(userInstructions)

		mov		edx, OFFSET prompt1
		call	WriteString
		mov		edx, OFFSET username
		mov		ecx, 32
		call	ReadString
		
		mov		edx, OFFSET greeting
		call	WriteString
		mov		edx, OFFSET username
		call	WriteString
		call	CrLf



STEPS:

; (getUserData)

		mov		edx, OFFSET prompt2
		call	WriteString
		call	CrLf

		mov		eax, 0
		mov		linecount, 1
		mov		eax, linecount
		call	WriteDec

		mov		edx, OFFSET userinput
		call	WriteString
		call	ReadInt
		call	CrLf
		
		cmp		eax, 0
		jge		CALCULATE			; jump to print results
		cmp		edx, MINIMUM
		jl		ERROR				; if under min get input again

		mov		usernumber, eax
		add		sum, eax
		inc		linecount
		loop	STEPS

		

CALCULATE:
; calculate and print results

		cmp		sum, 0
		je		SPECMSG
		dec		linecount

		mov		edx, OFFSET validresult		; print valid inputs
		call	WriteString
		mov		eax, linecount
		call	WriteDec
		call	CrLf

		mov		edx, OFFSET negativesum		; print sum of negative integers
		call	WriteString
		mov		eax, sum
		call	WriteInt
		call	CrLf


		mov		edx, 0
		mov		eax, sum
		cdq
		mov		ebx, linecount
		cmp		ebx, 0
		je		ZERROR
		cdq
		idiv	ebx
		mov		quotient, eax
		mov		remainder, edx
		
		mov		edx, OFFSET roundedavg
		call	WriteString
		mov		quotient, eax
		call	WriteInt
		call	CrLf

		jmp		PEACEOUT



SPECMSG:
; if user doesnt enter negative integers

		mov		edx, OFFSET special
		call	WriteString
		call	CrLf
		
	

ERROR:

; print error message and jump to previous section


		mov		edx, OFFSET errormess
		call	WriteString
		call	CrLf
		jmp		STEPS



ZERROR:

; error message for when the user tries to divide by 0

		mov		edx, OFFSET zerrormess
		call	WriteString
		call	CrLf
		jmp		PEACEOUT


PEACEOUT:
; goodbye to user

		mov		edx, OFFSET thanks
		call	WriteString
		call	CrLf

		mov		edx, OFFSET goodbye
		call	WriteString
		mov		edx, OFFSET	username
		call	WriteString
		call	CrLf
			



	exit	; exit to operating system
main ENDP


END main
