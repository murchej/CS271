TITLE Program 4     (proj04.asm)

; Author: Joseph Murche
; Last Modified: 2/12/22
; OSU email address: murchej@oregonstate.edu
; Course number/section: CS_271_001_W2022
; Assignment Number:     4            Due Date: 2/13/22
; Description: Write a program to calculate composite numbers.


INCLUDE Irvine32.inc


.data

;string data

		welcome		byte	"Hello! Welcome to the Composite Number Spreadsheet.", 0
		myname		byte	"Programmed by Joseph Murche.", 0	
		intro		byte	"This program generates a list of composite numbers.", 0
		intro2		byte	"All you have to do is tell me how many you want to see.", 0
		range		byte	"The range of composites I can do is from 1-300.", 0
		getnumber	byte	"Please enter how many composites you want to see [1-300]:", 0
		errormess	byte	"Error: Out of range. Please enter number [1-300]:", 0
		goodbyemess	byte	"Thank you for using my program. Godspeed", 0
		space		byte	"   ", 0

;int data

		n_comp		DWORD	?		;user input
		itemline	DWORD	0		;store value of items in line
		mark		DWORD	0		;tracks printed numbers
		minimum		DWORD	1		;minimum input value
		maximum		DWORD	300		;maximum input value
		current		DWORD	4		;the current composite number in iteration
		locate		DWORD	0		;0 for not composite number, 1 if it is



.code
main PROC

		call	introduction
		call	getUserData
		call	showComposites
		call	goodbye


	exit	; exit to operating system
main ENDP


;-----------------------------------------------------------------------------------------
; Introduction: welcomes user to program and gives program info
; Receives: name, welcome, intro, intro2, range
; Returns: none
; Preconditions: none
; Registers changed: edx
;-----------------------------------------------------------------------------------------
introduction PROC
;display program title, my name, and instructions

			
			mov		edx, OFFSET	welcome		;welcome user
			call	WriteString
			call	CrLf

			mov		edx, OFFSET myname		;display name
			call	WriteString
			call	CrLf

			mov		edx, OFFSET intro		;how program works
			call	WriteString
			call	CrLf

			mov		edx, OFFSET intro2		;how program works
			call	WriteString
			call	CrLf

			mov		edx, OFFSET range		;shows input range
			call	WriteString
			call	CrLf


		ret
introduction ENDP



;-----------------------------------------------------------------------------------------
; Introduction: get user data
; Receives: n_comp
; Returns: input stored in n_comp
; Preconditions: none
; Registers changed: edx, eax
;-----------------------------------------------------------------------------------------
getUserData PROC
;get number

			
			mov		edx, OFFSET	getnumber		;request and store user input
			call	WriteString
			call	ReadInt

			mov		n_comp, eax
			call	validate				;validate number

	
	ret
getUserData ENDP



;----------------------------------------------------------------------------------------
; Introduction: make sure number is between 1 and 300
; Receives: minimum, maximum, n_comp, errormess
; Returns: save the input in numberComposite
; Preconditions: none
; Registers changed: edx
;----------------------------------------------------------------------------------------
validate PROC
;validate n_comp

			mov		edx, n_comp					;compares user input to the minimum and maximums
			cmp		edx, minimum
			jl		AGAIN
			cmp		edx, maximum
			jg		AGAIN
			jmp		DONE

			AGAIN:								;error message and loop
				mov		edx, OFFSET	errormess
				call	WriteString
				call	CrLf
				call	getUserData
			
			DONE:
					ret

validate ENDP


;----------------------------------------------------------------------------------------
; Introduction: Print the composite number
; Receives: locate, current, mark, itemline, space, n_comp
; Returns: none
; Preconditions: mark <= n_comp
; Registers changed: edx, eax
;----------------------------------------------------------------------------------------
showComposites PROC

			
			ODD:
					mov		edx, 0                 
					mov		eax, current
					mov		ebx, 2
					div		ebx
					cmp		edx, 0
					jne		CHECK_COMPOSITE       
					inc		current
			
			
			CHECK_COMPOSITE:					;checks for composite numbers
					mov		locate, 0
					call	isComposite
					cmp		locate, 1
					je		PRINT
					inc		current


			PRINT:								;increments
					inc		mark
					inc		itemline
					jmp		CHECKLINE


			CHECKLINE:							;checks if we need new line 
					mov		edx, itemline
					cmp		edx, 10
					jg		NEWLINE
					jmp		PRINT_INT


			NEWLINE:							;prints new line
					call	CrLf
					mov		itemline, 1
					jmp		PRINT_INT


			PRINT_INT:							;prints the numbers
					mov		eax, current
					call	WriteDec
					
					mov		edx, OFFSET space
					call	WriteString


			CHECKNEXT:							;check to print next or not
					mov		eax, mark
					cmp		eax, n_comp
					je		DONE
					inc		current
					jmp		ODD


			DONE:
					ret


showComposites ENDP



;----------------------------------------------------------------------------------------
; Introduction: Verify composite numbers
; Receives: locate, current
; Returns: 1 if the number is a composite number
; Preconditions: none
; Registers changed: edx, eax, ecx
;----------------------------------------------------------------------------------------
isComposite PROC

			mov		ecx, current
			dec		ecx							;divide all numbers less than itself

			CHECK_COMPOSITE:
					cmp		ecx, 1
					je		DONE
					mov		edx, 0
					mov		eax, current		;check that the numbers are less than n_comp
					div		ecx
					cmp		edx, 0
					je		FIND
					loop	CHECK_COMPOSITE


			FIND:
					mov		locate, 1


			DONE:
					ret

isComposite ENDP



;----------------------------------------------------------------------------------------
; Introduction: Say goodbye to user
; Receives: goodbye
; Returns: none
; Preconditions: none
; Registers changed: edx
;----------------------------------------------------------------------------------------
goodBye PROC

			call	CrLf
			mov		edx, OFFSET goodbyemess		;says goodbye and thank you to user
			call	WriteString
			call	CrLf


		ret
goodBye	ENDP


END main
