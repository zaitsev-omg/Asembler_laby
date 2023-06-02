; File: lr8.asm

.386
.model flat, stdcall

; Прототипи функцій
extern ExitProcess : proc
extern CoTaskMemAlloc : proc
extern CoTaskMemFree : proc
extern SysAllocString : proc
extern SysFreeString : proc
extern SysStringLen : proc
extern SysStringByteLen : proc

includelib kernel32.lib
includelib ole32.lib

.data
    sentencePtr dd 0
    wordsVectorPtr dd 0
    wordCount dd 0

.code
lr8 proc sentence:DWORD, wordsVector:DWORD
    ; Збереження вказівника на речення та вказівника на вектор слів
    mov sentencePtr, sentence
    mov wordsVectorPtr, wordsVector

    ; Встановлення розміру вектора слів на 0
    mov wordCount, 0

    ; Отримання розміру речення в байтах
    invoke SysStringByteLen, sentencePtr
    mov ecx, eax

    ; Виділення пам'яті для збереження копії речення
    invoke CoTaskMemAlloc, ecx
    mov esi, eax

    ; Копіювання речення в виділену пам'ять
    push ecx
    invoke lstrcpy, esi, sentencePtr
    pop ecx

    ; Розділення речення на слова
    mov edi, esi
    mov edx, ecx
    xor eax, eax
    xor ebx, ebx

    process_sentence:
        ; Пошук початку наступного слова
        cld
        repne scasb
        je end_of_sentence

        ; Обробка знайденого слова
        dec edi
        push edi
        push edx

        ; Виділення пам'яті для збереження слова
        mov ecx, edx
        add ecx, 2 ; +2 для нуль-термінатора
        invoke CoTaskMemAlloc, ecx
        mov eax, edi

        ; Копіювання слова в виділену пам'ять
        mov edi, eax
        mov ecx, edx
        rep movsb

        ; Додавання нуль-термінатора
        mov byte ptr [edi], 0

        ; Збереження вказівника на слово у векторі слів
        mov ecx, wordsVectorPtr
        mov eax, wordCount
        imul eax, 4 ; Розмір DWORD (4 байти) для зсуву в векторі
        add ecx, eax
        mov eax, edi
        mov [ecx], eax

        ; Збільшення лічильника слів
        inc wordCount

        pop edx
        pop edi

        ; Продовження обробки речення
        jmp process_sentence

    end_of_sentence:
        ; Завершення роботи

        ; Звільнення виділеної пам'яті для копії речення
        mov eax, esi
        invoke CoTaskMemFree, eax

        ; Повернення кількості знайдених слів
        mov eax, wordCount

        ret
lr8 endp

end
