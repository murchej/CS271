TITLE Program 5     (Proj05.asm)

; Author: Joseph Murche
; Last Modified: 2/25/22
; OSU email address: murchej@oregonstate.edu
; Course number/section: CS_271_001_W2022
; Assignment Number:      5           Due Date: 2/27/22
; Description: Write a MASM program to perform the tasks shown below. 
;				1. Introduce the program.
;				2. Get a user request in the range [min = 15 .. max = 200].
;				3. Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elements of an array.
;				4. Display the list of integers before sorting, 10 numbers per line.
;				5. Sort the list in descending order (i.e., largest first).
;				6. Calculate and display the median value, rounded to the nearest integer.
;				7. Display the sorted list, 10 numbers per line.

INCLUDE Irvine32.inc

		MIN = 15
		MAX = 200

		LO = 100
		HI = 999

		arraycount = 10		;counts array values

.data

		;string data

		intro1		BYTE	"Welcome to Sorting Random Integers!", 0
		intro2		BYTE	"Programmed by Joseph Murche.", 0
		TA			BYTE	"**EC: Hi Julian!!", 0
		instruct1	BYTE	"This program generates random numbers in the range [100-999],", 0
		instruct2	BYTE	"displays the original list, sorts the list, and calculates thec", 0
		instruct3	BYTE	"median value. Finally, it displays the list sorted in descending order.", 0
		getinput	BYTE	"How many numbers should be generated? [15-200]: ", 0
		errormess	BYTE	"Invalid Input, the range is [15-200],", 0
		unsorted	BYTE	"The unsorted random numbers:", 0
		sorted		BYTE	"The sorted random numbers:", 0
		printmedian	BYTE	"The median is ", 0
		farewell	BYTE	"Thank you and godspeed.", 0
		space		BYTE	"   ", 0

		
		;integer data

		userinput	DWORD	?			;user entered integer
		median		DWORD	0			;stored the value of median
		array		DWORD	MAX	DUP(?)	;defined array
		temp		DWORD	0			;temporary
		arraynum	DWORD	0			;holds the value to set to the median
		count		DWORD	0			;keeps track of what step the sequence is on
			

.code
main PROC

		call	Randomize				;initialize sequence on system clock
		call	introduction
		
		
		call	getuserinput
		
		
		push	OFFSET array			;push array on stack
		push	arraycount
		call	fillarray
		
		
		mov		edx, OFFSET unsorted	
		call	WriteString
		call	CrLf


		push	OFFSET array
		push	arraycount
		call	printarray				;prints unsorted array
		call	CrLf


		mov		edx, OFFSET sorted
		call	WriteString
		call	CrLf

		
		push	OFFSET array
		push	arraycount
		call	bubblesort				;sort procedure
		call	CrLf


		push	OFFSET array
		push	arraycount
		call	printarray				;prints sorted array
		call	CrLf


		push	OFFSET array
		push	arraycount
		call	getmedian				;calculates and prints the median value
		call	CrLf

		
		
		call	goodbye
		call	CrLf




		exit	
main ENDP


;-----------------------------------------------------------------------
; Title: introduction
; Receives: intro1 intro2, TA, instruct1-3
; Returns: none
; Preconditions: none
; Registers changed: edx
;-----------------------------------------------------------------------

introduction PROC
		;display title and intro

			mov		edx, OFFSET intro1
			call	WriteString
			call	CrLf

			mov		edx, OFFSET intro2
			call	WriteString
			call	CrLf

			mov		edx, OFFSET TA
			call	WriteString					;extra credit attempt
			call	CrLf
			
			call	CrLf
			mov		edx, OFFSET instruct1
			call	WriteString
			

			mov		edx, OFFSET instruct2
			call	WriteString

			mov		edx, OFFSET instruct3
			call	WriteString
			call	CrLf


		
		ret
introduction ENDP




;-----------------------------------------------------------------------
; Title: getuserinput
; Receives: global variables getinput, errormess, MIN, MAX
; Returns: saves the user input in userinput
; Preconditions: none
; Registers changed: edx, eax, ebx
;-----------------------------------------------------------------------

getuserinput PROC

			push	ebp
			mov		ebp, esp
			mov		ebx, [ebp + 8]

		INPUT:
			
			mov		edx, OFFSET getinput
			call	WriteString
			call	ReadInt							;get user input


			cmp		eax, MIN
			jl		AGAIN
			cmp		eax, MAX
			jg		AGAIN
			mov		ebx, eax
			jmp		DONE


		AGAIN:										;data validation loop

			mov		edx, OFFSET errormess
			call	WriteString
			call	CrLf
			jmp		INPUT


		DONE:

			pop		ebp
			ret		4



getuserinput ENDP




;-----------------------------------------------------------------------
; Title: fillarray
; Receives: userinput, array
; Returns: fills array with random numbers
; Preconditions: none
; Registers changed: ecx, eax, edi
;-----------------------------------------------------------------------

fillarray PROC

			push	ebp
			mov		ebp, esp
			mov		edi, [ebp + 12]
			mov		ecx, [ebp + 8]	

		FILL:

			mov		eax, HI
			sub		eax, LO
			inc		eax
			call	RandomRange			;get range for random numbers
			add		eax, LO
			mov		[esi], eax
			add		esi, 4
			loop	FILL


			pop		ebp
			ret		8


fillarray ENDP




;-----------------------------------------------------------------------
; Title: printarray
; Receives: userinput, array
; Returns: none
; Preconditions: none
; Registers changed: edx, esi, eax, ebx, ecx
;-----------------------------------------------------------------------

printarray PROC

			push	ebp
			mov		ebp, esp
			mov		esi, [ebp + 12]
			mov		ecx, [ebp + 8]			;value of count in ecx


		PRINT_ARRAY:

			mov		eax, [esi]
			call	WriteDec

			mov		edx, OFFSET space
			call	WriteString

			add		esi, 4
			inc		count
			mov		edx, 0
			mov		eax, count

			mov		ebx, 10
			div		ebx

			cmp		edx, 0
			je		NEXT_LINE			;check for need for new line
			jne		DONE
			

		NEXT_LINE:

			call	CrLf
			loop	PRINT_ARRAY			;loop printing procedure


		DONE:

			loop	PRINT_ARRAY
			mov		count, 0
			pop		ebp
			ret		12

			


printarray ENDP




;-----------------------------------------------------------------------
; Title: bubblesort
; Receives: array
; Returns: bubble sorted array
; Preconditions: none
; Registers changed: esi, ebp, ecx, eax
;-----------------------------------------------------------------------		

bubblesort PROC

			push	ebp
			mov		ebp, esp
			mov		ecx, [ebp + 8]
			dec		ecx


		BEGIN:

			push	ecx						;push outer loop counter to stack
			mov		esi, [ebp + 12]			;set the start of the array


		INSIDE_LOOP:

			mov		eax, [esi]
			cmp		[esi + 4], eax
			jle		NEXT
			xchg	eax, [esi + 4]			;swap if greater
			mov		[esi], eax


		NEXT:

			add		esi, 4					;add the next element
			loop	INSIDE_LOOP
			pop		ecx						
			loop	BEGIN					;back to first loop


		DONE:

			pop		ebp
			ret		8


bubblesort ENDP




;-----------------------------------------------------------------------
; Title: getmedian
; Receives: arraynum, printmedian
; Returns: median value
; Preconditions: none
; Registers changed: edx, eax, ebx, ebp
;-----------------------------------------------------------------------

getmedian PROC

			push	ebp
			mov		ebp, esp
			mov		esi, [ebp + 12]
			mov		eax, [ebp + 8]
			mov		edx, 0						;set 0 as the remainder
			mov		ebx, 2
			div		ebx

			mov		arraynum, eax
			cmp		edx, 0
			je		NO_REM						;even
			jg		ODD							;odd


		ODD:

			mov		ebx, 4
			mul		ebx
			mov		arraynum, eax				;save the element address to variable
			mov		eax, arraynum
			mov		eax, [esi + eax]

			mov		edx, OFFSET printmedian			
			call	WriteString
			call	WriteDec
			call	CrLf

			pop		ebp
			ret		8


		NO_REM:

			mov		eax, arraynum
			mov		ebx, 4
			mul		ebx										;for finding the right element in the array

			mov		eax, [esi + eax]
			mov		temp, eax
			mov		eax, arraynum
			mul		ebx
			sub		eax, 4
			mov		ebx, eax								;location of the second element

			mov		ebx, [esi + ebx]						;set location value
			mov		eax, temp
			add		eax, ebx
			mov		ebx, 2
			div		ebx

			mov		edx, OFFSET printmedian
			call	WriteString								;prints median value
			call	WriteDec
			call	CrLf


		DONE:

			pop		ebp
			ret		8


getmedian ENDP




;-----------------------------------------------------------------------
; Title: goodbye
; Receives: farewell
; Returns: none
; Preconditions: none
; Registers changed: edx
;-----------------------------------------------------------------------

goodbye PROC

			mov		edx, OFFSET farewell			;goodbye message
			call	WriteString
			call	CrLf

		
			ret

goodbye ENDP

END main
