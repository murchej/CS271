TITLE Final Project     (final_project.asm)

; Author: Joseph Murche
; Last Modified: 3/14/22
; OSU email address: murchej@oregonstate.edu
; Course number/section:  CS_271_001_W2022
; Assignment Number:    6             Due Date: 3/15/22
; Description: Write MASM procedure called "compute" to create a cipher, have decoy, encrypt, decrypt functions within compute proc.

INCLUDE Irvine32.inc


.code
main PROC



	
main ENDP

;Sadie Thomas


;-----------------------------------------------------------------------
; Title: compute
; Receives: operand1, operand2, OFFSET dest (decoy)
			OFFSET key, OFFSET message, OFFSET dest	(encrypt, decrypt)

; Returns: encrypted message for encrypt, decrypted message for decrypt
		   sum of operand1 and operand2 stored in dest for decoy.

; Preconditions: N/A
; Registers changed: eax, ebp
;-----------------------------------------------------------------------
compute PROC

		enter	0,0
		pushad

		mov		eax, [ebp+8]
		mov		eax, [eax]			;store dest in eax for user to choose which mode to run

		cmp		eax, -1
		je		ENCRYPTION
		cmp		eax, -2
		je		DECRYPTION
		cmp		eax, 0
		je		DECOY_MODE


	
	ENCRYPTION:
		
		push	[ebp+16]		;key offset
		push	[ebp+12]		;message offset

		call	encrypt
		jmp		DONE



	DECRYPTION:

		push	[ebp+16]
		push	[ebp+12]

		call	decrypt
		jmp		DONE



	DECOY_MODE:
		
		push	[ebp+12]		;operand 1 and 2 on stack
		push	[ebp+8]			;dest on stack

		call	decoy
		jmp		DONE



	DONE:

		popad
		leave
		ret		12


compute ENDP




;-----------------------------------------------------------------------
; Title: encrypt
; Receives: OFFSET key, OFFSET message
; Returns: encrypted message is stored in OFFSET message
; Preconditions: N/A
; Registers changed: eax, ebp, esi, edx
;-----------------------------------------------------------------------
encrypt PROC

		enter	0,0
		mov		esi, [ebp+8]


	
	READ:							;loop that reads through string until end of message

		mov		eax, [esi]
		cmp		al, 122
		jg		NEXT

		cmp		al, 97
		jl		NEXT

		cmp		al, 0
		je		DONE


		sub		al, 97
		mov		edx, [ebp+12]
		AND		eax, 000000FFh		;eax finds index

		add		edx, eax
		mov		eax, [edx]
		mov		[esi], al			;the character gets replaced/encrypted


	
	NEXT:

		add		esi, TYPE BYTE
		jmp		READ



	DONE:

		leave
		ret		8





;-----------------------------------------------------------------------
; Title: decoy
; Receives: operand1 and operand2, OFFSET dest
; Returns: sum of operands stores in dest
; Preconditions: N/A
; Registers changed: eax, ebp, ebx
;-----------------------------------------------------------------------
decoy PROC

		enter	0,0
		mov		ax, [ebp+14]
		movsx	eax, ax

		mov		bx, [ebp+12]
		movsx	ebx, bx

		add		eax, ebx
		mov		ebx, [ebp+8]
		mov		[ebx], eax			;sum stored into dest

		leave
		ret		8



decoy ENDP

		


;-----------------------------------------------------------------------
; Title: decrypt
; Receives: OFFSET key, OFFSET message
; Returns: decrypted message is stored in OFFSET message
; Preconditions: N/A
; Registers changed: eax, ebp, ecx, esi, ebx
;-----------------------------------------------------------------------
decrypt	PROC

		enter	0,0
		mov		esi, [ebp+8]	



	LOOP_ORIGINAL:

		mov		eax, [esi]
		cmp		al, 122
		jg		NEXT

		cmp		al, 97
		jl		NEXT

		cmp		al, 0
		je		DONE
		mov		ecx, 0				;counts loops



	LOOP_REPLACE:

		mov		edx, [ebp+12]
		add		ebx, ecx
		mov		ebx, [ebx]

		cmp		bl, al
		jne		NEXT_REPLACE

		add		ecx, 97
		mov		[esi], cl



	NEXT_REPLACE:

		inc		ecx					;increment loop counter
		add		ebx, TYPE BYTE
		cmp		ecx, 26				;compare message length to loop count
		jg		NEXT
		
		jmp		LOOP_REPLACE



	NEXT:

		add		esi, TYPE BYTE
		jmp		LOOP_ORIGINAL



	DONE:

		leave
		ret		8



decrypt ENDP







END main
