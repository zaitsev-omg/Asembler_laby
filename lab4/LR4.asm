
	.586		           	   				; ��� ����������;
	.model flat, stdcall       				; ������ ���'���;
	.stack									; ������� �����;
	.data			   		   				; ������� �����;
		Array dd 0,0,0,2,0,0,0,0,0,5,0,6,7	; ����. �����;
		ArraySize dd 13  					; ʳ�. �������� � �������;
	.code  									; ������� ����;
	Begin: 									; ��������� ������� ������� ������;
											;
			lea ebx, Array					; � �bx ��������� ����� ������
			push ebx						; ��������� � ���� ��������� ebx;
			push ArraySize					; ʳ�. �������� � ����
			push ecx						; ��������� � ���� ��������� ecx;
			;-------------------------------;
											; �������� �������;
			xor eax, eax 					; ������� ������� eax;	
			xor ebx, ebx 					; ������� ������� ebx;
			xor ecx, ecx 					; ������� ������� ecx;
			xor edx, edx 					; ������� ������� edx;
			xor esi, esi 					; ������� ������� esi;
											;
			call CountZeroes				; ��������� CountZeroes;
			jmp Check						; ��������� Check;
											;
			;-------------------------------;
			CountZeroes proc				; ϳ��������� CountZeroes;
			mov eax, 1						; ��������� ������� �������� ����� 1;
			mov ecx, dword ptr[ebp+16]		; ��������� � ��� �i�. e������i� ������;
			mov ebx, dword ptr[ebp+20]		; ��������� � �dx ����� ������;
			mov ecx, ArraySize  			; ��������� ������� �������� ����� "ArraySize" - ����� ������;
			CountingZeroes:					; ������� ����� CountingZeroes;
			cmp	Array[esi], 0				; ��������: �� � ������� ������ �����?
			jne	It_is_not_zero				; ���� ������� ������ �� � ����� - ������������ ����������� ���������!
											;
			Add edx, eax 					; ����, ���� ��������� - �������� ���� ��������� �� ����;
											;
			It_is_not_zero:					;
			add esi, 4 						; �������� (esi = esi + 4);
			loop CountingZeroes				; ʳ���� ����� CountingZeroes;
			ret 0							; ���������� � ����������;
											;
			CountZeroes endp				; ʳ���� ����������;
											;
			;-------------------------------;	
											;
											;
			Check:							;
			test edx, 00000001h          	; �������� �� ������� edx - �������� ����; 
			jnz Need_to_delete              ; ��������, ���� ������� 0-�� �������� ������ � �������;
											;
			jmp TheEnd						; �������� � �����, ���� ������� 0-�� �������� ������ � �����;
			Need_to_delete:					;
			call DeleteZeroes				; ��������� DeleteZeroes;
											;
			;-------------------------------;
											;
			DeleteZeroes proc				; ������� ����������;
				mov eax, 1					; ��������� ������� �������� ����� 1;
				push eax					; ��������� � ���� ��������� eax
				xor eax, eax				; ������� ������� eax;
				xor ecx, ecx 				; ������� ������� ecx;
				xor edx, edx 				; ������� ������� edx;
				xor esi, esi 				; ������� ������� esi;
				xor edi, edi				; ������� ������� edi;
				mov ecx, dword ptr[ebp+16]	; ��������� � ��� �i�. e������i� ������;
				mov ebx, dword ptr[ebp+20]	; ��������� � �dx ����� ������;
				mov ecx, ArraySize  		; ��������� ������� �������� ����� "ArraySize" - ����� ������;
				pop eax						; ³��������� � ����� �������� eax;
											;
				DeletingZeroes:				; ������� ����� DeleteZeroes;
				mov edi, Array[esi]			;
				cmp	Array[esi], 0			; ��������: �� � ������� ������ �����?
				jne	Not_Delete			    ; ���� ������� ������ �� � ����� - ������������ ����������� ���������, 
											; �� �������� �� ���������!
											;
				Add edx, eax 				; ����, ���� ��������� - �������� ���� ��������� �� ����;
											;
				test edx, 00000001h			; �������� �� ������� edx - �������� ����;
				jnz Not_Delete				; ������������ ��������� ��������� ��������, ���� ��������� 0 � ��������;
											; ��������� 0, ���� ��������� 0 � ������;
				push ecx					; ��������� � ���� ��������� ecx;
				push esi					; ��������� � ���� ��������� esi;
				dec ecx						; ³������� ������� �� ecx;
				DeletingLoop:				;
				mov ebx, Array[esi+4]		; ��������� ��������� ������� ������;
				mov Array[esi], ebx			; �������� ������� ������ ��������� ��������� ������;
				add esi, 4					; �������� (esi = esi + 4);
				loop DeletingLoop			;
				mov Array[esi], 0 			; ������� ���� � ����� ������;
				pop esi						; ³��������� � ����� �������� esi;
				sub esi, 4					; �������� (esi = esi + 4);
				pop ecx						; ³��������� � ����� �������� ecx;
											;
				Not_Delete:					;
				add esi, 4 					; �������� (esi = esi + 4);
				loop DeletingZeroes			; ʳ���� ����� DeletingZeroes;
				ret 0						; ���������� � ����������;
											;
			DeleteZeroes endp 				; ʳ���� ����������;
											;
			;-------------------------------;
											;
		TheEnd: ret							; ������� ���������� ��������;
		end Begin 				   			; Ki���� ������� ������.