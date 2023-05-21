%include "asm_io.inc"

section .data
	;;	Prompt strings with null terminators
	star	db	'*', 0	;;	Marker used for unit-testing in development
	cross	db 	'+', 0	;;	Marker used for unit-testing in development
	asknum1	db	"Enter a number: ", 0
	asknum2	db	"Enter another number: ", 0
	symand	db " & ", 0
	symor	db " | ", 0
	symxor	db	" ^ ", 0
	symis	db	" is ", 0
	
section .bss
	;;	Reserve words for the inputs -> num1 and num2 and the outputs -> resultant of the logic operators
	num1 		resd 	1
	num2 		resd 	1
	resultant 	resd	1
	
section	.text
   global asm_main        ;must be declared for using gcc
	
asm_main:	                ;tell linker entry point
	
	enter   0,0		; setup routine
    pusha

ask_input:
	
	;;	Ask for user inputs and store them into num1 and num2 respectively
	mov eax, asknum1		
	call print_string
	call read_int
	mov [num1], eax
	
	mov eax, asknum2
	call print_string
	call read_int
	mov [num2], eax
	
	;;	Scaffolding to check if input stream works as intended
	;mov eax, [num1]
	;call print_int
	
	;call print_nl
	
	;mov eax, [num2]
	;call print_int
	
find_and:
	;;	Clear register for safety purposes
	xor eax, eax
	xor ebx, ebx 
	
	;;	Move numbers to eax and ebx registers and perform AND
	mov eax, [num1]			;;	eax =  num1
	mov ebx, [num2]			;;	ebx = num2
	and eax, ebx			;;	eax = eax & ebx
	mov [resultant], eax	;;	resultant = eax
	
	;;	Print out the string "[num1] & [num2] is [resultant]"
	mov eax, [num1]
	call print_int
	mov eax, symand
	call print_string
	mov eax, [num2]
	call print_int
	mov eax, symis
	call print_string
	mov eax, [resultant]
	call print_int
	
	call print_nl	;;	Simply print out a new line 
	
find_or:
	;;	Clear register for safety purposes
	xor eax, eax
	xor ebx, ebx 
	
	;;	Move numbers to eax and ebx registers and perform OR
	mov eax, [num1]			;;	eax =  num1
	mov ebx, [num2]			;;	ebx = num2
	or eax, ebx			;;	eax = eax | ebx
	mov [resultant], eax	;;	resultant = eax
	
	;;	Print out the string "[num1] | [num2] is [resultant]"
	mov eax, [num1]
	call print_int
	mov eax, symor
	call print_string
	mov eax, [num2]
	call print_int
	mov eax, symis
	call print_string
	mov eax, [resultant]
	call print_int
	
	call print_nl	;;	Simply print out a new line 
	
find_xor:
	;;	Clear register for safety purposes
	xor eax, eax
	xor ebx, ebx 
	
	;;	Move numbers to eax and ebx registers and perform XOR
	mov eax, [num1]			;;	eax =  num1
	mov ebx, [num2]			;;	ebx = num2
	xor eax, ebx			;;	eax = eax ^ ebx
	mov [resultant], eax	;;	resultant = eax
	
	;;	Print out the string "[num1] ^ [num2] is [resultant]"
	mov eax, [num1]
	call print_int
	mov eax, symxor
	call print_string
	mov eax, [num2]
	call print_int
	mov eax, symis
	call print_string
	mov eax, [resultant]
	call print_int
	
	call print_nl	;;	Simply print out a new line 
	
close:
	
	;;	Exit routine
    popa
    mov     eax, 0            ; return back to C
    leave                     
    ret