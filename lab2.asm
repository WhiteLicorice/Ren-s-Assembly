%include "asm_io.inc"

section .data
	;;	Prompt strings with null terminators
	askyear    	db 'Enter a year: ', 0  
	outyear  db 'This year ', 0  
	outyearyes  db 'is a leap year.', 0 
	outyearno   db 'is NOT a leap year.', 0
		
section .bss
	year resd 1	;;	Reserve 1 double word called 'year' for the year input
	
section .text
	global asm_main

asm_main:

	enter   0,0               ; setup routine
    pusha
	
	;;	Outputs 'Enter a year' prompt
	mov eax, askyear
	call print_string
	
	;;	Reads user input and stores it in 'year'
	call read_int
	mov [year], eax
	
	;;	Clears eax and edx registers for use in the next block of code => div ebx uses eax:edx registers to store the dividend
	xor eax, eax
	xor  edx, edx
	
	;;	TODO: Check if 'year' is a leap year
	
	;;	Algorithm used for checking if the year is a leap year is as follows:
	;;		1) Check if the year is divisible by 400 => if it is, then the year is a leap year, otherwise, continue
	;;		2) Check if the year is divisible by 100 => if it is, then the year is not a leap year, otherwise, continue
	;;		3) Check if the year is divisible by 4 => if it is, then the year is a leap year, otherwise, continue
	;;		4) Once all checks from 1-3 have been exhausted, then the year is not a leap year
	
	;;	Implementation of algorithm start	;;
	
	;;	1) This checks if the year is divisible by 400 (year % 400) and stores the remainder in edx (if remainder exists, then it is not divisible)
	
	mov eax, [year]		;;	Move the value of year into eax
	mov ebx, 400		;;	Move our divisor -- 400 -- into ebx
	div ebx				;;	Divide the 'year' value in eax by the divisor in ebx => quotient is stored in eax while remainder is stored in edx
	;;mov eax, edx
	;;call print_int 
	cmp edx, 000		;;	Compare the remainder in edx with 0 => check if the remainder exists
	jz isleapyear		;;	If no remainder exists -- edx contains 0 -- then jump to isleapyear label (the year is a leap year, divisible by 400)
	
	;;	Clears eax and edx registers for use in the next block of code => div ebx uses eax:edx registers to store the dividend
	xor eax, eax
	xor  edx, edx
	
	;;	2) This checks if the year is divisible by 100 (year % 100), essentially the same process in #1 except with a different divisor
	
	mov eax, [year]		;;	Move the value of year into eax
	mov ebx, 100		;;	Move our divisor -- this time, 100 -- into ebx
	div ebx				;;	Divide the 'year' value in eax by the divisor in ebx => quotient is stored in eax while remainder is stored in edx
	;;mov eax, edx
	;;call print_int 
	cmp edx, 000		;;	Compare the remainder in edx with 0 => check if the remainder exists
	jz notleapyear		;;	If no remainder exists -- edx contains 0 -- then jump to notleapyear label (the year is not a leap year, divisible by 100)
	
	;;	Clears eax and edx registers for use in the next block of code => div ebx uses eax:edx registers to store the dividend
	xor eax, eax
	xor  edx, edx
	
	;;	3) This checks if the year is divisible by 4 (year % 4), essentially the same process in #1 and #2 except with a different divisor
	
	mov eax, [year]		;;	Move the value of year into eax
	mov ebx, 4		;;	Move our divisor -- this time, 4 -- into ebx
	div ebx				;;	Divide the 'year' value in eax by the divisor in ebx => quotient is stored in eax while remainder is stored in edx
	;;mov eax, edx
	;;call print_int 
	cmp edx, 000		;;	Compare the remainder in edx with 0 => check if the remainder exists
	jz isleapyear		;;	If no remainder exists -- edx contains 0 -- then jump to isleapyear label (the year is a leap year, divisible by 4)
	
	;;	4) Once all checks from 1-3 have been exhausted, then the year is not a leap year
	
	jmp notleapyear	;;	We simply jump to notleapyear label (all checks have been exhausted, year is not a leap year)
	
	;;jmp pass
	
notleapyear:
	
	;;	Simply print "This year is NOT a leap year" prompt.
	mov eax, outyear
	call print_string
    mov eax, outyearno
	call print_string
	
	;;	Jump to close, where the program terminates
    jmp close

isleapyear:
	
	;;	Simply print "This year is a leap year" prompt.
	mov eax, outyear
	call print_string
    mov eax, outyearyes
	call print_string
    
	;;	Jump to close, where the program terminates
	jmp close
	
pass:
	;;	Scaffolding block, used to test units in-development
	mov eax, outyear
	call print_string
	
	mov eax, [year]
	call print_int
	
	jmp close

close:
	
	;;	Print a new line for clarity on the console 
	call print_nl
	
	;;	Exit block
    popa
    mov     eax, 0            ; return back to C
    leave                     
    ret

