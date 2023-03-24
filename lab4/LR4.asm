
	.586		           	   		        ; Type of processor;
	.model flat, stdcall       				; Memory model;
	.stack							; Segment of the stack;
	.data			   		   		; Data segment;
		Array dd 0,0,0,2,0,0,0,0,0,5,0,6,7	        ; Initialization of the array;
		ArraySize dd 13  				; Number of elements in the array;
	.code  							; Code segment;
	Begin: 							; Assign the beginning of the command listing;
											
			lea ebx, Array				; in "åbx" save the addres of array;
			push ebx				; save in stack the value "ebx";
			push ArraySize				; Number of elements in the stack;
			push ecx				; We store the ecx assignment in the stack;
			;-------------------------------;
								; Cleaning registers;
			xor eax, eax 				; Cleaning register eax;	
			xor ebx, ebx 				; Cleaning register ebx;
			xor ecx, ecx 				; Cleaning register ecx;
			xor edx, edx 				; Cleaning register edx;
			xor esi, esi 				; Cleaning register esi;
											;
			call CountZeroes			; We call CountZeroes;
			jmp Check				; We call Check;
											
			;-------------------------------;
			CountZeroes proc			; Subroutine CountZeroes;
			mov eax, 1				; Assign the value of variable 1 to the register;
			mov ecx, dword ptr[ebp+16]		; We store the number of elements of the array in ecx;
			mov ebx, dword ptr[ebp+20]		; We store the address of the array in edx;
			mov ecx, ArraySize  			; Assign to the register the value of the variable "ArraySize" - the size of the array;
			CountingZeroes:				; Beginning of CountingZeroes Cycle;
			cmp	Array[esi], 0			; Check: Is the array element null?
			jne	It_is_not_zero			; If the element of the array is not zero - we skip the increase of the counter!
											
			Add edx, eax 				; If a zero is found, the counter of zeros is increased by one;
											
			It_is_not_zero:					
			add esi, 4 				; ²teration (esi = esi + 4);
			loop CountingZeroes			; End of Cycle CountingZeroes;
			ret 0					; Return from subroutine;
											
			CountZeroes endp			; End of routine;
											
			;-------------------------------;	
											
											
			Check:							
			test edx, 00000001h          	; edx parity check - counter of zeros; 
			jnz Need_to_delete              ; We jump if the number of 0 elements of the array is odd;
											
			jmp TheEnd			; Jump to the end If the number of 0 elements of the array is even;
			Need_to_delete:					
			call DeleteZeroes		; We call DeleteZeroes;
											
			;-------------------------------;
											
			DeleteZeroes proc				; Start of subroutine;
				mov eax, 1				; Assign the value of variable 1 to the register;
				push eax				; We save the eax assignment to the stack;
				xor eax, eax				; We clean the registry eax;
				xor ecx, ecx 				; We clean the registry ecx;
				xor edx, edx 				; We clean the registry edx;
				xor esi, esi 				; We clean the registry esi;
				xor edi, edi				; We clean the registry edi;

				mov ecx, dword ptr[ebp+16]	; We store the number of elements of the array in ESH;
				mov ebx, dword ptr[ebp+20]	; We store the address of the array in edx;
				mov ecx, ArraySize  		; Assign to the register the value of the variable "ArraySize" - the size of the array;
				pop eax				; We restore the value of eax from the stack;
											
				DeletingZeroes:				; The beginning of the Cycle DeleteZeroes;
				mov edi, Array[esi]			
				cmp	Array[esi], 0			; Check: Is the array element null?
				jne	Not_Delete			; If the element of the array is not zero - we skip the increase of the counter,
									; and check and delete!
											
				Add edx, eax 				; If a zero is found, the counter of zeros is increased by one;
											
				test edx, 00000001h			; edx parity check - counter of zeros;
				jnz Not_Delete				; We skip the deletion of the zero element. If the found 0 is odd;
										
                                                                                ; Removing 0. If found 0 is even;
				push ecx					; We store the ecx assignment in the stack;
				push esi					; We store the esi assignment in the stack;
				dec ecx						; Subtract the unit from ecx;
				DeletingLoop:				
				mov ebx, Array[esi+4]		; We store the next element of the array;
				mov Array[esi], ebx		; We replace the element of the array with the next element of the array;
				add esi, 4			; Iteration (esi = esi + 4);
				loop DeletingLoop			
				mov Array[esi], 0 		; We put zero at the end of the array;
				pop esi				; We restore the value of esi from the stack;
				sub esi, 4			; Iteration (esi = esi + 4);
				pop ecx				; We restore the value of ecx from the stack;
											
				Not_Delete:					
				add esi, 4 				; Iteration (esi = esi + 4);
				loop DeletingZeroes			; End of Cycle DeletingZeroes;
				ret 0					; Return from subroutine;
											
			DeleteZeroes endp 				; End of routine;
											
			;-------------------------------;
											
		TheEnd: ret						; Proper termination of the program;
		end Begin 				   		; End of command listing.