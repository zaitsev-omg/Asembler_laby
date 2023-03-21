.686p
.mmx
.xmm
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

.data
array dd -3, 5, -2, 7, -1, 8, 4, -6, 1, -9
array_len equ ($ - array)/4

.code
start:
    mov esi, offset array ; установить указатель на начало массива
    mov ecx, array_len ; установить количество элементов

loop_start:
    mov eax, [esi] ; загрузить текущий элемент в регистр EAX
    cmp eax, 0 ; проверить, является ли он нулем
    jge skip_negative ; пропустить неотрицательные числа

    ; вычислить абсолютное значение и сохранить в отдельной переменной
    mov ebx, eax
    neg ebx
    cmp eax, ebx
    cmovl eax, ebx

    ; вставить модуль в массив
    mov [esi], eax
    add esi, 4 ; перейти к следующему элементу
    inc ecx ; увеличить счетчик элементов
    jmp loop_start

skip_negative:
    add esi, 4 ; перейти к следующему элементу
    loop loop_start

    ; выйти из программы
    invoke ExitProcess, 0
end start