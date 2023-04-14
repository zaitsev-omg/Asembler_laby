.586
.model flat, C
.CODE

;*** THE SUM OF THE ELEMENTS OF THE FIRST TERM ***
;*************************************
first_row_sum PROC C arr:dword, n:dword

	xor esi, esi			;reset esi
	mov ecx, n			;put in ecx n
	xor eax, eax			;clean eax
	mov edx, arr			;in edx array address
;---------------------------;cycle
c0:
	add eax, [edx+esi*4]	                ;in eax we will accumulate the sum of terms
	inc esi					;increment esi
	loop c0					;loop, go to label c0
;---------------------------;the end of the cycle

ret							;subroutine exit
first_row_sum ENDP

;** SUM OF THE ELEMENTS OF THE FIRST COLUMN **
;*************************************
first_col_sum PROC C arr:dword, n:dword

	xor esi, esi			;reset esi
	mov ecx, n			;put in ecx n
	xor eax, eax			;clean eax
	mov edx, arr			;in edx put in array address
;---------------------------;cycle
c1:
	mov ebx, esi			;we will put a counter esi in ebx 
	imul ebx, n			;multiply by n
	add eax, [edx+ebx*4]	        ;and add the necessary element to eax
	inc esi				;increment esi
	loop c1				;loop, go to label c1
;---------------------------;the end of the cycle

ret							;subroutine exit
first_col_sum ENDP
;*************************************

;EXCHANGE THE FIRST ROW AND THE FIRST COLUMN
;*************************************
arr_change PROC C arr:dword, n:dword
	
	xor esi, esi			;reset esi
	mov ecx, n			;put in ecx n
	mov edx, arr			;in edx put in array address
;---------------------------;cycle
c2:
	mov ebx, esi			;in ebx put esi
	imul ebx, n			;multiply by n
	mov eax, [edx+ebx*4]	;and add the necessary element to eax
	xchg eax, [edx+esi*4]	;we replace each with the term element
	mov [edx+ebx*4], eax	;and we will place a row element on the column element
	inc esi					;increment esi
	loop c2					;loop, go to label c2
;---------------------------;the end of the cycle
ret
arr_change ENDP
;*************************************

END