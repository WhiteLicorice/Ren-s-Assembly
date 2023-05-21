%include "asm_io.inc"

section .data

section .bss
	
section	.text
   global factorial, get_int        ;must be declared for using modules
   
factorial:
	
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
	
get_int:	         
	
	;;enter   0,0		; setup routine
	
	;;	Simple read user input then move it to ebx (which points to the variable num in main)
	call read_int
	mov [ebx], eax
	
    ;;leave                     
    ret