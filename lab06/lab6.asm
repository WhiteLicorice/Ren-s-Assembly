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
   global asm_main        ;must be declared for using gcc
	
asm_main:	                ;tell linker entry point
	
	enter   0,0		; setup routine
    pusha
	
read_user_input:
	
	;;	Prompt user to input a number to compute its factorial, read the input, then move the read input from eax to num
	mov eax, asknum
	call print_string
	call read_int
	mov [num], eax
	
	xor eax, eax 		;;	Clear eax register for later use
	
	mov ebx, [num]		;;	Store number in ebx to later compute its factorial
	call fact_base		;;	Call the start of the factorial function -> the base case
	
	mov [fact], eax		;;	Store result of factorial function
	
	;;	Scaffolding to check if ret in fact_recurse works as intended
	;mov eax, cross
	;call print_string
	;jmp close
	
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
	jmp close
	
fact_base:
	cmp ebx, 1			;;	Check if recursion has reached base case: n <= 1
	jg fact_recurse		;;	If base case has not been reached, continue with recursion
	mov eax, 1			;;	Base case -> return 1 
	ret
	
fact_recurse:

	;;	Scaffolding to check if call fact_base works as intended
	;mov eax, star
	;call print_string
	;ret
	
	dec ebx				;; decrement ebx (the number) by 1 to move to next factor (ie. 5! = 5 * 4 * 3 * 2 * 1)	
	call fact_base		;; call fact_base with ebx - 1 as its argument -> recurse and check if base case has been reached
	inc ebx				;; retrieve current factor, because we decreased it by 1 to check for base case above
	mul ebx 			;; eax = ebx * eax, computation starts at base case assignment -> eax = 1, thereafter: eax = 1 * 2 * 3... * n 
	ret					;; go back to caller 
	
close:
	
	call print_nl	;;	Simply print a new line
	
	;;	Exit routine
    popa
    mov     eax, 0            ; return back to C
    leave                     
    ret
	
	