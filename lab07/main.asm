%include "asm_io.inc"

section .data
	;;	Prompt strings with null terminators
	star	db	'*', 0	;;	Marker used for unit-testing in development
	cross	db 	'+', 0	;;	Marker used for unit-testing in development
	asknum	db	"Enter a number to calculate its factorial: ", 0
	outfactpre	db	"Factorial of ", 0
	outfactis	db " is ", 0
	
section .bss
	;;	Reserve words for the inputs -> num output -> factorial
	num 		resd 	1
	fact        resd	1
	
section	.text
   global asm_main   			;must be declared for using gcc
   extern factorial, get_int	 ;must be declared for using external modules
   
asm_main:	                ;tell linker entry point
	
	enter   0,0		; setup routine
    pusha
	
	;;	Prompt user to input a number to compute its factorial, read the input, then move the read input from eax to num
	mov eax, asknum
	call print_string
	mov ebx, num
	call get_int	;; get_int reads user input then stores that result in ebx -> num
	
	;;	Clear registers for later use
	xor eax, eax 		
	xor ebx, ebx
	
	mov ebx, [num]
	call factorial		;;	Call the external factorial function
	
	mov [fact], eax		;;	Store result of factorial function
	
	;;	Print the output to terminal
	mov eax, outfactpre
	call print_string
	mov eax, [num]
	call print_int
	mov eax, outfactis
	call print_string
	mov eax, [fact]
	call print_int
	
	;;	Jump to close program execution
close:

	call print_nl	;;	Simply print a new line

	;;	Exit routine
    popa
    mov     eax, 0            ; return back to C
    leave                     
    ret