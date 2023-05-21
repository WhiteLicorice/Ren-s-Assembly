segment .text
	global asm_main

asm_main:

  ;;  Output prompt to enter value of jack
  mov eax, 4
  mov ebx, 1
  mov ecx, askjck
  mov edx, lenaskjck
  int 80h

  ;;  Read and store user input for initial value of jack
  mov eax, 3 
  mov ebx, 0
  mov ecx, jack  
  mov edx, 5          
  int 80h
  
  ;;  Output prompt to enter value of jill
  mov eax, 4
  mov ebx, 1
  mov ecx, askjll
  mov edx, lenaskjll
  int 80h

  ;;  Read and store user input for initial value of jill
  mov eax, 3 
  mov ebx, 0
  mov ecx, jill  
  mov edx, 5          
  int 80h
  
  ;; Outputs the "before the fall" divider
  mov eax, 4
  mov ebx, 1
  mov ecx, divbef
  mov edx, lendivbef
  int 80h
  
  ;;  Output the message 'The value of jack is: '
  mov eax, 4
  mov ebx, 1
  mov ecx, outjck
  mov edx, lenoutjck
  int 80h  

  ;;  Output the value of jack
  mov eax, 4
  mov ebx, 1
  mov ecx, jack
  mov edx, 5
  int 80h  
	
  ;;  Output the message 'The value of jill is: '
  mov eax, 4
  mov ebx, 1
  mov ecx, outjll
  mov edx, lenoutjll
  int 80h  

  ;;  Output the value of Jill
  mov eax, 4
  mov ebx, 1
  mov ecx, jill
  mov edx, 5
  int 80h  
  
  ;; Swaps the values between jack and jill by using registers eax and ebx as intermediaries
  mov eax, [jack]
  mov ebx, [jill]
  mov [jack], ebx
  mov [jill], eax
  
  ;; Outputs the "after the fall" divider
  mov eax, 4
  mov ebx, 1
  mov ecx, divaft
  mov edx, lendivaft
  int 80h
  
  ;; Essentially the same code used in printing the values before the fall, copy and pasted from above
  
  ;;  Output the message 'The value of jack is: '
  mov eax, 4
  mov ebx, 1
  mov ecx, outjck
  mov edx, lenoutjck
  int 80h  

  ;;  Output the value of jack
  mov eax, 4
  mov ebx, 1
  mov ecx, jack
  mov edx, 5
  int 80h  
	
  ;;  Output the message 'The value of jill is: '
  mov eax, 4
  mov ebx, 1
  mov ecx, outjll
  mov edx, lenoutjll
  int 80h  

  ;;  Output the value of Jill
  mov eax, 4
  mov ebx, 1
  mov ecx, jill
  mov edx, 5
  int 80h  
    
  ;; Exit code
  mov eax, 1
  mov ebx, 0
  int 80h
	
segment .data      

  ;Values of constructs and their lengths
  askjck  db "Enter the value of jack: ", 
  lenaskjck equ	$ - askjck

  askjll db "Enter the value of jill: ", 
  lenaskjll	equ	$ - askjll

  divbef  db "===========Before the fall===========", 0xa
  lendivbef	equ	$ - divbef

  outjck	    db "The value of 'jack' is ", 
  lenoutjck	equ	$ - outjck

  outjll       db "The value of 'jill' is ", 
  lenoutjll	equ	$ - outjll

  divaft  db "===========After the fall===========", 0xa
  lendivaft	equ	$ - divaft
  
segment .bss

  jack resb 5,
  jill resb 5