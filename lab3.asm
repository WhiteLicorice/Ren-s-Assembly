%include "asm_io.inc"

section .data
	;;	Prompt strings with null terminators
	star	db	'*', 0	;;	Marker used for unit-testing in development
	cross	db 	'+', 0	;;	Marker used for unit-testing in development
	askint	db	"Please input integers a and b.", 0
	askinta	db	"Please input integer a: ", 0
	askintb	db 	"Please input integer b: ", 0
	greatera db	"The integer a is greater than or equal to integer b.", 0
	greaterb db	"The integer b is greater than integer a.", 0
	outlcm	db "The LCM is: ", 0
	nolcm	db "None", 0
section	.bss
	;;	Reserve double words for user inputs int_a and int_b, derived expressions int_a*int_b and GCD(int_a, int_b), and their gcd and lcm
	inta	resd 	1
	intb	resd 	1	 
	intaxb	resd	1
	intgcd	resd	1
	intlcm	resd	1
	
section	.text
   global asm_main        ;must be declared for using gcc
	
asm_main:	                ;tell linker entry point
	
	enter   0,0		; setup routine
    pusha
	
	;;	Prompt user to enter integers a and b. 
	mov eax, askint 
	call print_string
	call print_nl
	
	;;	Prompt user to input integer a, read the input, then move it to int_a address
	mov eax, askinta 
	call print_string
	call read_int
	mov [inta], eax
	
	;;	Prompt user to input integer b, read the input, then move it to int_b address
	mov eax, askintb
	call print_string
	call read_int
	mov [intb], eax
	
	;;	Scaffolding to check if input stream is functional
	;;mov eax, [inta]
	;;call print_int
	
	;;call print_nl
	
	;;mov eax, [intb]
	;;call print_int
	
	;;call print_nl
	
	;;	Clear registers
	xor eax, eax
	xor ecx, ecx
	xor ebx, ebx
	xor edx, edx
	
	;;	TASK: Find the LCM of two integers
	;;	The generic algorithm for finding the lcm of any two integers relies on the following formula and its derivation below:
	;;
	;;	int_a * int_b = LCM(int_a, int_b) * GCD (int_a, int_b) => LCM(int_a, int_b) = (int_a * int_b) / GCD(int_a, int_b)
	;;
	;;	Thus, we can construct the following series of steps to arrive at the LCM of integers a and b:
	;;
	;;		1) First, we have to calculate the GCD of a and b using Euclidean Algorithm -> GCD(int_a, int_b)
	;;			a)	Determine which of a or b is greater.
	;;			b)	Then, we compute greater_int % lesser_int and replace the value of the greater integer found in (a) with the result.
	;;			c)	That is, if a > b, then a = a % b and vice versa.
	;;			d)	Steps a-b are recursively repeated until greater_int % lesser_int = 0.
	;;			e)	The final value that lesser_int takes when greater_int becomes 0 is the GCD of integers a and b.
	;;		2) Once we have the GCD, we can simply plug it into the formula above to compute the LCM of integers a and b.
	;;
	
	;;	IMPLEMENTATION OF ALGORITHM: 
	
	;;	PRECOMPUTATION: Check if any of the inputs are 0 => if so, jump to case where the lcm does not exist
	;;					Otherwise, compute a * b first so we can freely mutate int_a and int_b.
	
	mov eax, [inta]
	cmp eax, 000
	jz lcm_dne
	mov ebx, [intb]
	cmp ebx, 000
	jz lcm_dne
	
	mul ebx				;;	eax *= ebx 
	mov [intaxb], eax	;;	move the result of the multiplication into int_a_x_b -- this assumes that no overflow to edx occurs in the product
	
	;;	Scaffolding to check if the above block works as intended
	;;mov eax, [intaxb]
	;;call print_int
	;;jmp close
	
	;;	Step 1: Computation of the GCD of int_a and int_b

;;	a) Determine which of a or b is greater
comparison:

	;;	Clear registers
	xor eax, eax
	xor ecx, ecx
	xor ebx, ebx
	xor edx, edx
	
	;;	Move the values of int_a and int_b to registers ecx and ebx respectively then compare their values with cmp operation
	mov	ecx,  [inta]
	mov ebx, [intb] 
	cmp ecx, ebx
	jae greater_a	;;	If int_a is greater than or equal to int_b, jump to greater_a label
	jmp greater_b 	;;	Else, jump to greater_b
	
	
;;	For the case where a >= b
greater_a:
	;;	Clear registers
	xor eax, eax
	xor ecx, ecx
	xor ebx, ebx
	xor edx, edx
	
	;;	We perform int_a = int_a % int_b since a > b, and store the remainder from edx in int_a (overwriting the greater value) (b)
	mov eax, [inta]
	mov ebx, [intb]
	div ebx
	mov [inta], edx 
	
	;;	Scaffolding to check if the jmp to greater_a works as intended
	;;mov eax, greatera
	;;call print_string
	
	;;	Check if int_a (the greater integer in this case) has already become 0 -> if so, we have found the GCD in int_b (d)
	mov ecx, [inta] 
	cmp ecx, 000
	jz	gcd_found_b
		
	;;jmp close	;;	Scaffolding jump
	
	jmp comparison	;;	Recursion: rerun from comparison step with inta = inta % intb and intb = intb 
	
;;	For the case where b > a
greater_b:
	;;	Clear registers
	xor eax, eax
	xor ecx, ecx
	xor ebx, ebx
	xor edx, edx
	
	;;	We perform int_b = int_b % int_a since b > a, and store the remainder from edx in int_b (overwriting the greater value) (b)
	mov eax, [intb]
	mov ebx, [inta]
	div ebx
	mov [intb], edx 
	
	;;	Scaffolding to check if the jmp to greater_a works as intended
	;;mov eax, greaterb
	;;call print_string
	
	;;	Check if int_b (the greater integer in this case) has already become 0 -> if so, we have found the GCD in int_a (d)
	mov ecx, [intb] 
	cmp ecx, 000
	jz	gcd_found_a
	
	;;jmp close	;;	Scaffolding jump
	
	jmp comparison	;;	Recursion: rerun from comparison step with inta = inta % intb and intb = intb 
	
gcd_found_b: 
	;;	Clear registers
	xor eax, eax
	xor ecx, ecx
	xor ebx, ebx
	xor edx, edx
	
	;;	Since the gcd is in int_b, we move the value there to int_gcd
	mov eax, [intb]
	mov [intgcd], eax 
	
	;;	Scaffolding to check if the above block works as intended
	;mov eax, star
	;call print_string
	;mov eax, [intgcd]
	;call print_int
	
	jmp final_computation	;;	Jump to final computation block
	
	;;jmp close	;;	Scaffolding jump
	
gcd_found_a: 
	;;	Clear registers
	xor eax, eax
	xor ecx, ecx
	xor ebx, ebx
	xor edx, edx
	
	;;	Since the gcd is in int_a, we move the value there to int_gcd
	mov eax, [inta]
	mov [intgcd], eax 
	
	;;	Scaffolding to check if the above block works as intended
	;mov eax, cross
	;call print_string
	;mov eax, [intgcd]
	;call print_int
	
	jmp final_computation	;;	Jump to final computation block
	
	;;jmp close	;; Scaffolding jump
	
final_computation:
	;;	Clear registers
	xor eax, eax
	xor ecx, ecx
	xor ebx, ebx
	xor edx, edx
	
	;;	Scaffolding to check if the computed values are as intended
	;mov eax, [intgcd]
	;call print_int
	
	;call print_nl
	
	;mov eax, [intaxb]
	;call print_int
	
	;;	Divide int_a * int_b by their GCD to get their LCM according to the formula
	mov eax, [intaxb]
	mov ebx, [intgcd]
	div ebx
	mov [intlcm], eax	;;	Store the computed lcm
	
	;;	Print out the LCM 
	mov eax, outlcm
	call print_string
	mov eax, [intlcm]
	call print_int
	
	jmp close	;;	End program execution
	
lcm_dne:
	;;	Print out that LCM does not exist
	mov eax, outlcm
	call print_string
	mov eax, nolcm
	call print_string
	
	jmp close	;;	End program execution

close:
	
	call print_nl	;;	Simply print a new line
	
	;;	Exit routine
    popa
    mov     eax, 0            ; return back to C
    leave                     
    ret