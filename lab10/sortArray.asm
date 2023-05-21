%include "asm_io.inc"
%define MAX_SIZE 100	;;	We hardcode the maximum size of the array to be 100 to sidestep dynamic memory allocation issues

section .data
	;;	Prompt strings with null terminators
	star	db	'*', 0	;;	Marker used for unit-testing in development
	cross	db 	'+', 0	;;	Marker used for unit-testing in development
	
	arraysizeprompt	db	"Enter array size: ", 0
	enterindex	db	"Element at INDEX ", 0
	colon	db ": ", 0
	whitespace db " ", 0
	arraycontains	db "The array contains: ", 0
	sortingarray	db	"Sorting array...", 0
	sortedarray db "The sorted array is:", 0 
	done db "Done.", 0
	
section .bss
	;;	Reserve words for the inputs -> array and arraysize
	arraysize 	resd 	1
	array1		resd 	MAX_SIZE
	
section	.text
   global asm_main       	;;	must be declared for using gcc
   extern dump_line

asm_main:	                ;;	tell linker entry point
	enter 0, 0				;;	Prologue of subprograms that adhere to the C-calling conventions
	pusha

ask_arraysize:
	
	;;	Print out "Enter array size: " prompt
	mov eax, arraysizeprompt
	call print_string
	
	;;	Read integer input -> note that the maximum legal array size is hardcoded in the preprocessor section
	call read_int
	
	;;	Edge case: if array size input is 0, we cannot proceed with execution of the program so we just end
	cmp eax, 0
	jz return_to_caller
	
	;;	Store integer input in arraysize
	mov [arraysize], eax
	
	;;	Zero out registers for future usage
	xor eax, eax
	xor ecx, ecx 
	xor ebx, ebx
	
	;;	Scaffolding to check if array size input is being read correctly
	;mov eax, [arraysize]
	;call print_int
	;call print_nl
	
	jmp ask_elements
	
ask_elements:
	cmp [arraysize], ecx	;;	Check if we have successfully filled the array up to the desired index
	je	before_print_array
	
	;;	Print out prompt for "Element at INDEX #: " and read the user input
	mov eax, enterindex
	call print_string
	mov eax, ecx
	call print_int
	mov eax, colon
	call print_string
	call read_int
	
	;;	Retrieve user input from eax and store it in the array indexed by ecx (starts at 0)
	mov [array1 + 4 * ecx], eax
	
	;;	Move to the next index
	inc ecx
	
	;;	Loop until exit condition is met
	jmp ask_elements
	
before_print_array:
	;;	Print out "The array contains: " prompt
	mov eax, arraycontains
	call print_string
	call print_nl
	
	;;	Zero out registers for future usage
	xor ecx, ecx
	xor eax, eax
	
	;;	Scaffolding to check if the conditional je jump in ask_elements works correctly
	;mov eax, star
	;call print_string
	;call print_nl

;;	Loop for printing out the elements of the unsorted array in order
before_printing_loop:
	cmp [arraysize], ecx	;;	Check if we have successfully printed out all the indexes in the array
	je	bubble_sort
	
	;;	Print out current element in array indexed by ecx
	mov eax, [array1 + 4 * ecx]	
	call print_int
	mov eax, whitespace
	call print_string
	inc ecx
	
	;;	Loop until exit condition is met
	jmp before_printing_loop

;;	ALGORITHM: BUBBLE SORT
;;	For each element in the array, do the following:
;;		1) Begin with pointers i = 0 and j = 1
;;		2) Compare array[i] with array[j] -> swap array[i] and array[j] if array[i] > array[j], if not continue to step 3
;;		3) Increment i and j by 1.
;;		4) Repeat steps 2 - 3 until i = k, where k is the index at the end of the array
;;		5) Go to step 1, move iteration to next element.
bubble_sort:
	;;	Print out "Sorting array..." prompt with newline
	call print_nl
	mov eax, sortingarray
	call print_string
	call print_nl
	
	;;	Zero out registers for future usage
	xor ecx, ecx
	xor eax, eax
	
sorting_loop:
	cmp ecx, [arraysize]	;;	Check if the array has been completely sorted -> if so, print out the array after sorting
	je after_print_array
	inc ecx					;;	Otherwise, increment counter
	
	;;	Zero out ebx for use as a counter in the pass routine
	xor ebx, ebx
	jmp pass
	
pass:
	;;	Peek if ebx is currently pointing to the index at the end of the array -> if so, the current pass routine is finished, move to next element
	inc ebx
	cmp ebx, [arraysize]
	je sorting_loop
	dec ebx		;;	Simply decrement ebx after peeking
	
	mov eax, [array1 + 4 * ebx + 4]	;;	Grab the element after ebx for comparison
	cmp eax, [array1 + 4 * ebx]		;;	Compare the next element with the current element
	ja continue						;;	If the next element is greater than the current element, then it is in order -> continue to next adjacent pair
	
swap:
	mov edx, [array1 + 4 * ebx]		;;	Simple swap algorithm with edx acting as temp -> temp = curr -> curr = next -> next = temp = curr
	mov [array1 + 4 * ebx], eax	
	mov [array1 + 4 * ebx + 4], edx
	
continue:
	inc ebx		;;	Increment our counter and go back to pass routine
	jmp pass
	
;;	Prints out sorted array
after_print_array:
	;;	Print out "The sorted array is: " prompt
	mov eax, sortedarray
	call print_string
	call print_nl
	
	;;	Zero out registers for future usage
	xor ecx, ecx
	xor eax, eax

;;	Loop for printing out the elements of the sorted array in order
after_printing_loop:
	cmp [arraysize], ecx	;;	Check if we have successfully printed out all the indexes in the array
	je	return_to_caller
	
	;;	Print out current element in array indexed by ecx
	mov eax, [array1 + 4 * ecx]	
	call print_int
	mov eax, whitespace
	call print_string
	inc ecx
	
	;;	Loop until exit condition is met
	jmp after_printing_loop

return_to_caller:
	call print_nl		;;	Simply print a newline for space on the console
	mov eax, done		;;	Print out "Done." and another newline
	call print_string
	call print_nl
	popa
	leave
	ret