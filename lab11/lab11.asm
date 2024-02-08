%include "asm_io.inc"
%define MAX_LENGTH 100		;;	Preprocessor for defining the maximum length of a string

;;	Preprocessors defining linux system calls
%define SYS_EXIT 	1		
%define SYS_READ 	3
%define SYS_WRITE 	4
%define STDIN 		0
%define STDOUT		1

section .data
	;;	Prompt strings with null terminators
	star	db	'*', 0	;;	Marker used for unit-testing in development
	cross	db 	'+', 0	;;	Marker used for unit-testing in development
	
	header	db	"FIND THE MAXIMUM OCCURING CHARACTER IN A STRING", 0
	divider db "================================================", 0
	askstring	db	"Enter a string: ", 0
	outchar db "Character(s): ", 0
	frequency db "Frequency: ", 0
	
section .bss
	;;	Reserve memory for the input -> string1, which stores the input string and lenstr for input length as well as string2, the counter array
	string1 	resb 	MAX_LENGTH
	string2		resd	MAX_LENGTH
	lenstr1		resd	1
section	.text
	global asm_main        ;; must be declared for using gcc
	
asm_main:	        		;; tell linker entry point
	
	enter   0,0				;; setup routine
    pusha
	
	;;	Print out header and prompt asking for a string
	mov eax, header
	call print_string
	call print_nl
	mov eax, divider
	call print_string
	call print_nl
	mov eax, askstring
	call print_string
	call print_nl
	
	;;	Use low level syscalls to accept string input with spaces -> this returns (length + 1) of the input string in eax
	mov eax, SYS_READ		;; 	eax, 3 = system read
	mov ebx, STDIN			;; 	ebx, 0 = stdin
	mov ecx, string1		;; 	store in string1
	mov edx, MAX_LENGTH		;; 	input size
	int 0x80				;;	System interrupt, call read
	
	dec eax		;;	Retrieve actual length of the input string -> we subtract 1 because pressing the enter key counts as a character input
	
	mov [lenstr1], eax	;;	Store length of the input string in lenstr1
	
	;;	Scaffolding to check if input block works as intended
	;call print_nl
	;xor eax, eax
	;mov eax, [lenstr1]
	;call print_int
	;call print_nl
	;mov eax, string1
	;call print_string
	;call print_nl
	
	;;	Zero out registers for future use
	xor eax, eax
	xor edi, edi
	xor ecx, ecx
	xor ebx, ebx 
	xor edx, edx
	
;;	ALGORITHM:
;;	This dynamic programming algorithm for finding the frequency of each character in a string runs at: 
;;	O(NlogN) at worst case (string of length N is made up of all unique characters, e.g. abcde)
;;	STEPS:
;;		1) Accept a string input.
;;		2) Initialize a counter array that mirrors the string in a 1 : 1 correspondence, like so:
;;				string: aabcdec
;;				counts: 0000000
;;		3) For each character in the string, roughly do the ff:
;;			a. Let i be the index of the current character -> perform look ahead from index i + 1 to the end of the string.
;;			b. If a match is found -> increment index i in counts array, mark the matched index in the string with ' ' (grave marker).
;;			c. If ever a grave marker is found, skip to the next character in the look ahead.
;;		4) To find the greatest frequency, hook a routine into the algorithm which maintains the greatest found frequency and replaces it
;;			whenever a greater frequency is found.
;;		5) This process transforms the example in #2 into:
;;				string: a_bcde_
;;				counts: 2012110
;;				Note how the grave markers have 0 frequency and how the algorithm is stable (it does not alter the order of appearance of characters.)
;;				We also have GF = 2 in this example with the routine in #4.

	mov esi, string1	;;	Retrieve address of the string for use in character counting algorithm
	mov di, 0			;;	Let di = greatest frequency found, initialized at 0 to account for inputs with only spaces
	
parse_loop:
	;;	Check if the end of the string has been reached by comparing external counter (ecx in this frame) with the length of string
	cmp ecx, [lenstr1]
	je print_result
			
	push ecx			;;	Save external counter on stack so we can also use ecx as inner counter
	
	mov dl, byte[esi]	;;	Move current character that is being compared
	push esi			;;	Save index of current character that is being compared
	inc esi				;;	Move to next index for comparison since we do not need to compare elements before
	
	;;	Scaffolding to check if dl contains the character of interest
	;mov al, dl
	;call print_char
	
	mov bx, 0	;;	Set bx to be 0 -> counter of current element
	
	;;	Check if the current element is a ' ' -> if so, skip and move to next iteration (this has the effect of setting the count of each ' ' to be 0)
	cmp dl, ' '
	je move_next
	
	inc bx		;;	Increment bx by 1, since the character must occur at least once to reach this line
	inc ecx		;;	Move index of current character that is being compared to the next index -> compare (i, i + 1...k)
	
pass_check:
	;;	Check if end of string has been reached, if so move to next iteration (next character in string)
	cmp ecx, [lenstr1]
	je next_iteration
	
	xor eax, eax			;;	Zero out eax so we can use al safely
	
	mov al, byte[esi]		;;	Retrieves current element for comparison
	
	cmp al, ' '				;;	Skip comparison if the element to be compared is a space (grave marker)
	je increment_pointers
	
	cmp dl, al				;;	Check if current character for comparison matches our first character
	je found_match
	
increment_pointers:
	;;	Move checking to next character
	inc esi
	
	;;	Scaffolding to check if indexing works correctly
	;mov eax, ecx
	;call print_int
	;call print_nl
	
	inc ecx			;;	Maintain a numerical representation of the index of the current character -> count where to stop
	
	jmp pass_check	;;	loop back to next pass

found_match:
	;;	Scaffolding to check if character matching works correctly
	;mov eax, star
	;call print_string

	mov byte [esi], ' '		;;	Mark found duplicate character as a grave (' ')
	inc bx					;;	Increment count of current character defined in pass_check
	
	jmp increment_pointers
	
next_iteration:
	;;	Check if the maintained greatest frequency is less than the current frequency -> if so, replace GF, else preserve GF
	cmp di, bx
	ja move_next
	mov di, bx
	
move_next:
	pop esi		;;	Restore original pointer to the string 
	inc esi		;;	Increment esi -> retrieve which character we are to compare next
	pop ecx		;;	Restore original counter
	
	mov [string2 + 4 * ecx], bx		;;	Store frequency into the appropriate index in the counting array -> use ecx as index register for efficiency
	inc ecx							;;	Move index register to next character in string, move to next iteration (character)

	jmp parse_loop		;;	Loop back to parsing loop

;;	Prints out the results of the algorithm above in the desired specification (we have di = greatest frequency here)
print_result:
	xor ecx, ecx		;;	Zero out counter register for fresh loop
	
	mov eax, outchar	;;	Print out the "Character(s): ..." prompt
	call print_string
	
	mov esi, string1	;; Point esi to mutated string

outchar_loop:
	;;	Check if we have exhausted the string by comparing ecx to its length -> if so, exit outchar_loop and proceed with routine
	cmp ecx, [lenstr1]
	je outchar_exit
	
	;;	Grab the current frequency in the counter array indexed by ecx, check if equal to greatest frequency -> if not, move to next char-freq pair
	mov eax, [string2 + 4 * ecx]	
	cmp eax, edi
	jne outchar_increment
	
	;;	If the current count is equal to the greatest frequency, grab current character from esi
	mov al, byte [esi]
	
	;;	Check if the current character is a ' ' -> if so, skip to next iteration
	cmp al, ' '
	je outchar_increment
	
	;;	Print out current character whose count matches the greatest frequency found
	call print_char
	mov al, ' '
	call print_char
	
outchar_increment:
	;;	Move pointers -> ecx points to counter array, esi points to string (1 : 1 correspondence)
	inc ecx
	inc esi
	jmp outchar_loop

outchar_exit:
	;;	Exit routine
	;;	Print out "Frequency: X" -> greatest frequency is in edi
	call print_nl
	mov eax, frequency
	call print_string
	mov eax, edi
	call print_int
	
	jmp close	;;	end program execution


;;	Scaffolding to check if the string and the counting array matches up after algorithm (unreachable during normal execution)
print_counter:
	xor ecx, ecx
	xor eax, eax
	call print_nl
	
	;;	Scaffolding to check if the greatest frequency is correct
	mov eax, edi
	call print_int
	call print_nl
	xor eax, eax
	
	;;	Scaffolding to check if string has been mutated successfully
	mov eax, string1
	call print_string
	call print_nl
	xor eax, eax
	
printing_loop:
	cmp [lenstr1], ecx
	je close
	
	mov eax, [string2 + 4 * ecx]	
	call print_int
	inc ecx
	
	jmp printing_loop
	
close:
	call print_nl	;;	Simply print a new line
	
	;;	Exit routine
    popa
    mov     eax, 0            ; return back to C
    leave                     
    ret