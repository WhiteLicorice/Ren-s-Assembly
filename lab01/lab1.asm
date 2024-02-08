section .data
	
	;;	Create prompt strings and their lengths
	
	headanswer: db 'ANSWER:', 0xa	;;	Add newline here to save on a single block of code later
	lenheadanswer:  equ $-headanswer   

	outfirst: db 'The first digit is ',
	lenoutfirst: equ $-outfirst

	outsecond: db 'The second digit is ',
	lenoutsecond: equ $-outsecond

	outthird: db 'The third digit is ',
	lenoutthird: equ $-outthird

	outfourth: db 'The fourth digit is ',
	lenoutfourth: equ $-outfourth

	outfifth: db 'The fifth digit is ',
	lenoutfifth: equ $-outfifth

	outfinal: db 'The code is ',
	lenoutfinal: equ $-outfinal

	newline db '', 0xa	;;	For printing a newline manually
	lenoutnewline equ $-newline
	
section .bss

	;;	Variables to store the digits of the code
	first resb 5,
	second resb 5,
	third resb 5,
	fourth resb 5,
	fifth resb 5
  
section .text
	;;	Define entry point and start program
	global asm_main

asm_main:

	;; START COMPUTATIONS HERE

	;; From the riddle, we know:

	;; first + second = 8  
	;; second - fifth = fourth
	;; third = (first * fifth) / 6

	;; where first, second, third, fourth, and fifth are unique digits from 1-5

	;; Trivially, we know that a and b must take the values 5 and 3. 
	;; Thus, we check the case where first = 3 and second = 5 
	
	;;	Just do what was outlined above -> move value first into ecx then store it into its respective variable ny moving from ecx
	mov ecx, '3'
	mov [first], ecx
	mov ecx, '5'
	mov [second], ecx

	;; With this, we have eqs. a) 5 - fifth = fourth and b) third = (3 * fifth) / 6
	;; Notice that b narrows down the values of the fifth digit 
	;; We know that the only factors from 1-5 that generate a product divisible by six
	;; are 1) 3 * (4) and 2) 3 * (2)

	;; Take note, however, that if fifth = 2 
	;; then second - fifth = fourth -> 5 - 2 = 3 -> fourth = 3
	;; Remember that first = 3, so we cannot have fourth = 3.
	
	;;	Same thing here -> move value to ecx then move the value from ecx to its respective variable
	mov ecx, '4'
	mov [fifth], ecx

	;; Now, we compute for the value of the third digit using fifth = 4
	;; Equation: third = (first * fifth) / 6
	
	
	mov ax, [first]	;;	Move the value of the first variable to register ex, then subtract a '0' to convert to decimal
	sub ax, '0'
	mov bx, [fifth]	;;	Same here, except for the fifth value
	sub bx, '0'
	mul bx			;;	Multiply the value stored in register ax with the one in bx -> ax = ax * bx
	mov bx, '6'		;;	Reuse bx to store the divisor for the next step
	sub bx, '0'		;; Convert the stored '6' to decimal
	div bx			;; Divide the value stored in ax by the one in bx -> al = ax / bx
	add al, '0'		;; The quotient of the operation above is hardcoded to be stored in register al -> convert it into ASCII
	mov [third], al	;;	Move the ASCII quotient into the third digit variable

	;; Now, we compute for the value of the fourth digit using the values we derived
	;; Equation: fourth = second - fifth
	
	;;	Just move the values to be subtracted to registers eax and ebx, convert them to decimal by subtracting '0', then use sub -> eax = eax - ebx
	mov eax, [second]
	sub eax, '0'
	mov ebx, [fifth]
	sub ebx, '0'
	sub eax, ebx
	add eax, '0'	;;	Again, we add '0' to convert back into ASCII
	mov [fourth], eax	;;	Simply store the result of sub from eax to the fourth digit variable

	;; END OF COMPUTATIONS HERE
	
	;;	Output a newline for clarity on console
	mov eax, 4            
	mov ebx, 1         
	mov ecx, newline        
	mov edx, lenoutnewline    
	int 80h 
	
	;;	Output the header "Answer" by moving '4' -- SYS_WRITE call -- to eax and the string to be printed to ecx, its length to edx -> system interrupt to process
	;;	This process holds true for the rest of the blocks below, except we replace what we store in ecx and edx with respect to what we want to print
	mov eax, 4            
	mov ebx, 1         
	mov ecx, headanswer        
	mov edx, lenheadanswer    
	int 80h 
	
	;; New line 
	mov eax, 4            
	mov ebx, 1         
	mov ecx, newline        
	mov edx, lenoutnewline    
	int 80h 
	
	;;	Output the "first digit is..." prompt
	mov eax, 4            
	mov ebx, 1         
	mov ecx, outfirst        
	mov edx, lenoutfirst    
	int 80h
	
	;;	Output the actual first digit
	mov eax, 4
	mov ebx, 1
	mov ecx, first
	mov edx, 1
	int 80h
	
	;;	New line
	mov eax, 4            
	mov ebx, 1         
	mov ecx, newline        
	mov edx, lenoutnewline    
	int 80h 

	;;	Output the "second digit is..." prompt
	mov eax, 4            
	mov ebx, 1         
	mov ecx, outsecond        
	mov edx, lenoutsecond    
	int 80h 
	
	;;	Output the actual second digit
	mov eax, 4
	mov ebx, 1
	mov ecx, second
	mov edx, 1
	int 80h

	;;	New line
	mov eax, 4            
	mov ebx, 1         
	mov ecx, newline        
	mov edx, lenoutnewline    
	int 80h 
	
	;;	Output the "third digit is..." prompt
	mov eax, 4            
	mov ebx, 1         
	mov ecx, outthird        
	mov edx, lenoutthird    
	int 80h 
	
	;;	Output the actual third digit
	mov eax, 4
	mov ebx, 1
	mov ecx, third
	mov edx, 1
	int 80h
	
	;;	New line
	mov eax, 4            
	mov ebx, 1         
	mov ecx, newline        
	mov edx, lenoutnewline    
	int 80h 
	
	;;	Output the "fourth digit is..." prompt
	mov eax, 4            
	mov ebx, 1         
	mov ecx, outfourth        
	mov edx, lenoutfourth    
	int 80h 
	
	;;	Output the actual fourth digit
	mov eax, 4
	mov ebx, 1
	mov ecx, fourth
	mov edx, 1
	int 80h

	;;	New line
	mov eax, 4            
	mov ebx, 1         
	mov ecx, newline        
	mov edx, lenoutnewline    
	int 80h 
	
	;;	Output the "fifth digit is..." prompt
	mov eax, 4            
	mov ebx, 1         
	mov ecx, outfifth        
	mov edx, lenoutfifth    
	int 80h 
	
	;; Output the actual fifth digit
	mov eax, 4
	mov ebx, 1
	mov ecx, fifth
	mov edx, 1
	int 80h
	
	;;	New line
	mov eax, 4            
	mov ebx, 1         
	mov ecx, newline        
	mov edx, lenoutnewline    
	int 80h 
	
	;;	New line
	mov eax, 4            
	mov ebx, 1         
	mov ecx, newline        
	mov edx, lenoutnewline    
	int 80h 

	;;	Output the "code is..." prompt
	mov eax, 4            
	mov ebx, 1         
	mov ecx, outfinal        
	mov edx, lenoutfinal    
	int 80h 
	
	;;	Below, output each digit from their variables

	mov eax, 4
	mov ebx, 1
	mov ecx, first
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, second
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, third
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, fourth
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, fifth
	mov edx, 1
	int 80h
	
	;;	New line
	mov eax, 4            
	mov ebx, 1         
	mov ecx, newline        
	mov edx, lenoutnewline    
	int 80h 
	
	;;	New line
	mov eax, 4            
	mov ebx, 1         
	mov ecx, newline        
	mov edx, lenoutnewline    
	int 80h 
	
	;;	Exit program with no errors
	mov eax, 1         
	mov ebx, 0           
	int 80h