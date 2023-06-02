.586
.model flat, stdcall
option casemap : none
;Including files with constants
include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\msvcrt.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\masm32.inc
include C:\masm32\macros\macros.asm
;Connecting Libraries
includelib C:\masm32\lib\masm32.lib
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\msvcrt.lib

.STACK
.DATA
	ConsoleTitle db " Laboratory work ¹5 ",0 ;Console window title
	Name_Title db 30 dup(0)
	ComSizeMas db "Specify the size of the array:",13,10
	Len_ComSize equ $- ComSizeMas
	ComElemMas db "Enter array elements: ",13,10
	Len_ComElem equ $- ComElemMas
	ComMasBefore db "            Your array:",13,10
	Len_MasBefore equ $- ComMasBefore
	NoPositive db " Does not contain positive numbers!",13,10
	Len_NoPositive equ $- NoPositive
	Cin_Error db " Must be between 1 and 100!",13,10
	Len_Cin_Error equ $- Cin_Error
	_Excep db "          NO EVEN!",13,10
	Len__Excep equ $- _Excep
	Stars db "*********************************",13,10
	Len_Stars equ $- Stars
	Process db "            Treatment...",13,10
	Len_Process equ $- Process
	format_size_arr db "%d",0
	format_print_arr db " %4d ",0
	print_arr_b db "Element [",0
	print_arr_e db "]=",0
	print_13_10 db 13,10,0
	print_13 db 13,0

	ipar_max dd -1			;max element offset
	par_max dd 1
	fl db 0				;1- no even
.DATA?
	    arr dd 100 dup(?)   ;Max array size
        Size_arr dd ?        ;Actual array size
        h_input dd ?        ;Input device handle
        h_output dd ?       ;Output device handle
        nWrite dd ?         ;Variable for WriteConsole
        number_element dd ? ;Current input item number
        element_arr dd ?    ;Variable for array element inputarr dd 100 dup(?)
.CODE
main proc
	call AllocConsole ;Create your own console
                          ;convert characters to oem format for title output
        invoke CharToOemA, addr ConsoleTitle, addr Name_Title
        invoke SetConsoleTitle, addr Name_Title  ; Display title
        invoke GetStdHandle, STD_INPUT_HANDLE
        mov h_input, eax                         ;Get input device handle
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov h_output, eax                        ;Get a handle to the output device
        invoke SetConsoleOutputCP,1251           ; Cyrillic support
        invoke SetConsoleCP,1251
        mov h_input, eax                         ;Get input device handle
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov h_output, eax                        ;Get a handle to the output device
        call input_mas                           ;input initial data
        call print_rezult                        ;print array on screen
        invoke WriteConsole, h_output, ADDR Process, Len_Process, ADDR nWrite, 0
        call work_mas                            ;run the main algorithm
        call print_rezult                        ;print array on screen
        cmp fl,0                                 ;check flag
	je _ok
	invoke WriteConsole, h_output, ADDR _Excep, Len__Excep, ADDR nWrite, 0
	invoke WriteConsole, h_output, ADDR Stars, Len_Stars, ADDR nWrite, 0
_ok:
	invoke Sleep,50000		
	invoke ExitProcess, 0	;exit from the program
main endp

;---------------------------------------------------------------------------------------------------
input_mas proc
cin:
	;Array size prompt
	invoke WriteConsole, h_output, ADDR ComSizeMas, Len_ComSize, ADDR nWrite, 0
	invoke crt_scanf, ADDR format_size_arr, ADDR Size_arr
	
	cmp Size_arr, 1
	jl in_error
	cmp Size_arr, 100
	jg in_error
	or eax,eax
	jz in_error ;Input Error
	
	mov number_element, 0
	jmp m_input_arr

in_error:
	invoke crt_getchar
	invoke WriteConsole, h_output, ADDR Stars, Len_Stars, ADDR nWrite, 0
	invoke WriteConsole, h_output, ADDR Cin_Error, Len_Cin_Error, ADDR nWrite, 0
	invoke WriteConsole, h_output, ADDR Stars, Len_Stars, ADDR nWrite, 0
	jmp cin

m_input_arr:
	invoke WriteConsole, h_output, ADDR print_arr_b, 9, ADDR nWrite, 0	
	invoke crt_printf, ADDR format_size_arr , number_element 			
	invoke WriteConsole, h_output, ADDR print_arr_e, 2, ADDR nWrite, 0 	
	invoke crt_scanf, ADDR format_size_arr, ADDR element_arr
	or eax,eax
	jnz m_1			;no error
	;input error - buffer clearing
m_2: invoke crt_getchar
	cmp eax,10 		;until enter
	jne m_2
	invoke crt_printf, ADDR print_13
	jmp m_input_arr
m_1:
	mov eax, element_arr
	mov esi, number_element
	shl esi,2
	mov arr [esi], eax
	inc number_element
	mov edx, number_element
	cmp edx, Size_arr
	jnz m_input_arr	;loop without using LOOP
	ret
input_mas endp
;=====================================================================
print_rezult proc		;Vivid results
	invoke WriteConsole, h_output, ADDR Stars, Len_Stars, ADDR nWrite, 0
	invoke WriteConsole, h_output, ADDR ComMasBefore, Len_MasBefore, ADDR nWrite, 0
	mov number_element,0
m1: mov ecx,5 			;see 5 elements in a row
m2: push ecx
	mov eax,number_element
	shl eax,2
	mov esi,eax
	invoke crt_printf, ADDR format_print_arr , arr[esi]
	pop ecx
	inc number_element
	mov edx, number_element
	cmp edx, Size_arr
	jz m_ret 			;all elements are seen
	dec ecx
	jnz m2
	invoke crt_printf, ADDR print_13_10
	jmp m1
m_ret: 
	invoke crt_printf, ADDR print_13_10 ;
	invoke WriteConsole, h_output, ADDR Stars, Len_Stars, ADDR nWrite, 0
	ret
print_rezult endp
;=====================================================================
work_mas proc 			;main algorithm
;-------------------------------;find the first even number and set it to the maximum even number for the time being
	xor esi,esi					; clear åsi
	mov ecx, Size_arr
c0:
	mov eax,arr[esi*4]			;put in ex first element
	test eax,00000001h			;check for parity
	jnz m0					;if odd, jump
	mov par_max,eax				;even - put it in par_max 
	mov ipar_max,esi			;remember its index 
	mov ecx,1				;break the cycle
m0:
	inc esi					;add 1 to åsi
	loop c0					;loop, jump to label ñ0
;-------------------------------	
	cmp ipar_max,-1				;if equal to -1, then there is no even
	je _fl					;jumping fl
;-------------------------------;Calling a function (passing parameters through the stack)

	lea ebx, arr       ; to ebx array address
        push ebx           ;put it on the stack
        push Size_arr      ;number of elements to stack
        lea ebx, ipar_max  ;in ebx the index address of the first even element
        push ebx           ;put it on the stack
        push par_max       ;value of first even to stack
        call max_search    ; procedure call

        lea ebx, arr       ; to ebx array address
        mov edx, ipar_max  ;to edx- maximum position
        mov esi, Size_arr  ; in esi the size of the array
        dec esi            ;minus 1 (for the last element)
        call arr_change    ; function call, passing param. through registers
	jmp _ret
_fl:
	mov fl, 1
_ret:
	ret					;return
work_mas endp

;**SEARCH FOR THE MAXIMUM EVEN ELEMENT**
max_search proc 			        ;subroutine header
	push ebp
	mov ebp,esp
	pushad
;--------------------------------Popping parameters from the stack based on the above commands push.

	mov edi, [ebp+12]  		;in edi - addres pos_max
	mov ebx, [ebp+20]  		;in ebx – addres of array
	mov ecx, [ebp+16]  		;in ecx – count lemnts of array
	mov eax, [ebp+8]
	xor	esi,esi			;esi to zero
c1: 
	mov edx, [ebx+esi*4] 		;in eax current array element
        cmp edx, eax                    ;compare array element with maximum
        jle m1                          ;jump if array element is less than or equal to maximum
        test edx, 00000001h             ; even parity
        jnz m1                          ;jump if odd
        mov eax, edx                    ;update maximum value
        mov [edi], esi                  ; store number of maximum element in pos_max
m1: 
	inc esi 			;next array element
	loop c1				;if not all elements are processed go to c1
;-------------------------------
	popad
	mov esp,ebp
	pop ebp
	ret 16
max_search endp

;****SWAP WITH LAST****
arr_change proc
	push edx			;save register values
	push eax			
	push ecx
;--------------------------------
	mov eax, [ebx+esi*4]		;in ex the last element, this is our temp
	mov ecx, [ebx+edx*4]		;in esx maximum element
	mov [ebx+esi*4], ecx		;on the last set the maximum
	mov [ebx+edx*4],eax		;to the maximum last
;--------------------------------
	pop ecx				;restore register values
	pop eax
	pop edx
	ret 
arr_change endp
;********************************

_end:
end main