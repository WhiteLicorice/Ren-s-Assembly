%include "asm_io.inc"

segment .data
	space db ' ', 0		;;	Token for a simple one-character space
segment .bss
	
segment	.text
   global mult       	;;	must be declared for using modules

mult:
	enter 0, 0			;;	Executes the prologue of subprograms that adhere to C calling conventions
	push ebx			;;	Since C calling convention does not allow mutation of ebx, we save original value on stack (ecx, edx, eax modifiable)
	
	;;	Scaffolding to check if pass-by-reference works correctly
	;mov eax, [ebp + 8]
	;call print_int
	;call print_nl
	;jmp end_for
	
	jmp start_for		;;	Jump to algorithm proper
	
	;;	EXPLANATION: 
	;;	We use standard O(n2) algorithm for printing out the multiplication table of cardinality up to n.
	;;	let ecx = 0, counter for rows (outer loop)
	;;	let ebx = 0, counter for columns (inner loop)
	;;	For each row entry, print eax = ecx * ebx -> increment ecx and ebx by 1 every time their respective loop runs

;;	Initialize main loop -> ecx = 0	
start_for:
	mov ecx, 0
	
;;	Initialize outer loop -> check if ecx has reached n, if so end main loop, otherwise, proceed with iteration
outer_loop:
	;;	Condition check if  ecx >= n, if so end loop, otherwise continue iteration
	cmp ecx, [ebp + 8]
	jnl end_for
	
	inc ecx			;;	ecx += 1
	mov ebx, 0		;;	ebx = 0
	call print_nl	;;	Simply print a new line, used to move printing to next row

;;	Initialize inner loop -> check if ebx has reached n, if so end inner loop, otherwise, proceed with iteration
inner_loop:
	;;	Condition check if ebx >= n, if so move execution to outer loop, otherwise continue iteration
	cmp ebx, [ebp + 8]
	jnl outer_loop
	
	inc ebx			;;	ebx += 1
	mov eax, ecx	;;	eax = ecx 
	mul ebx			;;	eax = ecx * ebx
	
	call print_int		;;	Print out the result of the operation in the previous block
	mov eax, space		;;	Simply print out a space to separate numbers in a row, modify space token in data segment for bigger margins to preference
	call print_string	;;	Actual printing call of the previous line
	
	jmp inner_loop		;;	Move to next iteration
	
end_for:

	;;	Simply print two new lines for clarity on the console
	call print_nl
	call print_nl
	
	pop ebx		;;	Restore ebx to its original value
	leave		;;	Executes the epilogue of subprograms that adhere to the C calling convention
	ret			;;	Returns to caller