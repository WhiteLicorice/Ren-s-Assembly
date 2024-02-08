%include "asm_io.inc"

section .data
	;;	Prompt strings with null terminators
	star	db	'*', 0	;;	Marker used for unit-testing in development
	cross	db 	'+', 0	;;	Marker used for unit-testing in development
	asknum	db	"Enter an integer: ", 0
	askshift	db	"Enter the number of places to shift: ", 0
	symleftshift	db " << ", 0
	symrightshift	db " >> ", 0
	symis	db	" is ", 0
	
section .bss
	;;	Reserve words for the inputs -> num and shift and the outputs -> right-shifted and left-shifted numbers
	num 		resd 	1
	shift 		resd 	1
	rightnum	resd	1
	leftnum		resd	1
	
section	.text
   global asm_main        ;must be declared for using gcc
	
asm_main:	                ;tell linker entry point
	
	enter   0,0		; setup routine
    pusha

ask_input:
	
	;;	Ask for user inputs 
	mov eax, asknum
	call print_string
	call read_int
	mov [num], eax
	
	mov eax, askshift
	call print_string
	call read_int
	mov [shift], eax
	
	;;	EDGE CASE: if the number of places to be shifted is 0 (NONE), then jump to zero_shift block directly
	mov eax, [shift]
	cmp eax, 0
	jz zero_shift
	
	;;	Clear register
	xor eax, eax
	
	;;	Scaffolding to check if input stream works as intended
	;mov eax, star
	;call print_string
	;mov eax, [num]
	;call print_int
	
	;mov eax, cross
	;call print_string
	;mov eax, [shift]
	;call print_int
	
	;;	TASK: Shift an integer by a number of places left and right.
	;;	The high-level algorithm used in constructing a shifting loop is as follows:
	;;		1) For both left_shift and right_shift loops, shift the number to left or right respectively by 1 bit 
	;;		2) Step 1 is repeated until counter (ecx = shift) is exhausted (ecx = 0) [For-loop] 

;;	Use a counter-controlled loop to shift [num] to the left by [shift] places
move_left:

	mov ecx, [shift]	;;	Move [shift] to counter register
	mov eax, [num]		;;	Move the number to eax for left-shifting
	jmp left_shift 		;;	Move to left-shifting loop
	
left_shift:

	shl eax, 1			;;	Shift eax to the left by 1 for [shift] times
	loop left_shift		;;	Decrement ecx (counter) -> if ecx != 0, goto left_shift label and loop

	mov [leftnum], eax	;;	Store left-shifted result 
	jmp move_right		;;	Goto right_shift block
	
;;	Use a counter-controlled loop to shift [num] to the right by [shift] places
move_right:

	mov ecx, [shift]	;;	Move [shift] to counter register
	mov eax, [num]		;;	Move the number to eax for right-shifting
	jmp right_shift		;;	Move to right-shifting loop

right_shift:

	shr eax, 1			;;	Shift eax to the right by 1 for [shift] times
	loop right_shift	;;	Decrement ecx (counter) -> if ecx != 0, goto right_shift label and loop
	
	mov [rightnum], eax	;;	Store the right_shifted result
	jmp printing_output	;;	Goto printing_output block

;;	Printing block used for cases where shift > 0 
printing_output:
	;;	Clear registers
	xor eax, eax
	xor ecx, ecx
	
	;;	Print num << shift is left_num
	mov eax, [num] 
	call print_int
	mov eax, symleftshift
	call print_string 
	mov eax, [shift]
	call print_int
	mov eax, symis
	call print_string
	mov eax, [leftnum] 
	call print_int
	
	call print_nl		;;	Simply print a new line for clarity
	
	;;	Print num >> shift is right_num
	mov eax, [num] 
	call print_int
	mov eax, symrightshift
	call print_string 
	mov eax, [shift]
	call print_int
	mov eax, symis
	call print_string
	mov eax, [rightnum] 
	call print_int
	
	jmp close
	
;;	Printing block used for the edge case where shift = 0 -> we can skip many lines of code for efficiency since we don't have to shift
zero_shift:
	;;	Clear registers
	xor eax, eax
	
	;;	Print num << shift is num
	mov eax, [num] 
	call print_int
	mov eax, symleftshift
	call print_string 
	mov eax, [shift]
	call print_int
	mov eax, symis
	call print_string
	mov eax, [num] 
	call print_int
	
	call print_nl		;;	Simply print a new line for clarity
	
	;;	Print num >> shift is num
	mov eax, [num] 
	call print_int
	mov eax, symrightshift
	call print_string 
	mov eax, [shift]
	call print_int
	mov eax, symis
	call print_string
	mov eax, [num] 
	call print_int
	
	jmp close
	
close:
	
	call print_nl	;;	Simply print a new line
	
	;;	Exit routine
    popa
    mov     eax, 0            ; return back to C
    leave                     
    ret