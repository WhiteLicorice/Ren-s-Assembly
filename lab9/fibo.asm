%include "asm_io.inc"

segment .data
segment .bss
	
segment	.text
   global fibonacci       	;;	must be declared for using modules

fibonacci:
	enter 0, 0			;;	Executes the prologue of subprograms that adhere to C calling conventions
	pusha				;;	We save all registers that are non modifiable as per C calling conventions by pushing them onto stack
	
	;;	Scaffolding to check if pass-by-reference works correctly
	;mov eax, [ebp + 8]
	;call print_int
	;call print_nl
	;jmp end_for
	
	;;	Covers the case where n = [ebp + 8] = 0 (note that n can only be in the discrete range 0–47 due to limitations)
	mov eax, 0
	cmp [ebp + 8], eax
	jz zero_input
	
	;;	If n != 0, we proceed with standard iterative fibonacci algorithm
	jmp start_for

start_for:
	mov ecx, [ebp + 8]	;;	Initialize for loop with i = n
		
	;;	Retrieve first two fibonacci numbers -> 0, 1
	mov ebx, 0
	mov eax, 1
	
	jmp calc_fib
	
;;	iterative calc looop for fibonacci sequence, implicitly takes ebx = 0 and eax = 1 as initial arguments
calc_fib:
	xadd ebx, eax	;;	Perform exchange and add: temp = ebx + eax (next fibonacci number) -> ebx = eax, eax = temp 
	call print_int	;;	Print out current fibonacci number
	call print_nl	;;	Simply print a new line to separate fibonacci numbers
	loop calc_fib	;;  --ecx -> Continue looping until ecx <= 0
	jmp end_for		;;	End loop

zero_input:
	jmp end_for	;;	Upon encountering n = 0, a ZERO number of fibonacci numbers (empty set), we just end the program by jumping to end_for
	
end_for:	
	popa		;;	Restore non modifiable registers to their original values by popping from stack
	leave		;;	Executes the epilogue of subprograms that adhere to the C calling convention
	ret			;;	Returns to caller