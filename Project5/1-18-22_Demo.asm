TITLE In Class Demo    (1-18-22_Demo.asm)

; Author:
; Last Modified:
; OSU email address: 
; Course number/section:
; Assignment Number:                 Due Date:
; Description:

INCLUDE Irvine32.inc


.data

	prompt_1	byte	"Enter lower limit: ", 0
	prompt_2	byte	"Ener upper limit: ", 0
	low_limit	DWORD	?
	up_limit	DWORD	?

.code
main PROC

;low limit	
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		low_limit,eax


;upper limit
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		up_limit, eax

;set up accumulator, eax


;lower limit
	mov		eax, 0
	mov		ebx, lower_limit

;upper limit
	mov		ecx, up_limit
	mov		ecx, low_limit
	inc		ecx


;loop body

top:

	add		eax, ebx
	inc		ebx
	loop	top
	
	
;print result
	
	call	WriteDec

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
