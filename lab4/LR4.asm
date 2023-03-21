
	.586		           	   				; Тип процессора;
	.model flat, stdcall       				; Модель пам'яти;
	.stack									; Сегмент Стеку;
	.data			   		   				; Сегмент Даних;
		Array dd 0,0,0,2,0,0,0,0,0,5,0,6,7	; Іниц. масив;
		ArraySize dd 13  					; Кіл. елементів в массиве;
	.code  									; Сегмент кода;
	Begin: 									; Оголошуємо початок лістингу команд;
											;
			lea ebx, Array					; в еbx Зберигаємо адрес масива
			push ebx						; Зберигаємо у стек заначення ebx;
			push ArraySize					; Кіл. елементів в стек
			push ecx						; Зберигаємо у стек заначення ecx;
			;-------------------------------;
											; Очищення регістрів;
			xor eax, eax 					; Очищуємо регистр eax;	
			xor ebx, ebx 					; Очищуємо регистр ebx;
			xor ecx, ecx 					; Очищуємо регистр ecx;
			xor edx, edx 					; Очищуємо регистр edx;
			xor esi, esi 					; Очищуємо регистр esi;
											;
			call CountZeroes				; Викликаємо CountZeroes;
			jmp Check						; Викликаємо Check;
											;
			;-------------------------------;
			CountZeroes proc				; Підпрограма CountZeroes;
			mov eax, 1						; Присоюємо регістру значення змінної 1;
			mov ecx, dword ptr[ebp+16]		; Зберигаємо у есх кiл. eлементiв масива;
			mov ebx, dword ptr[ebp+20]		; Зберигаємо у еdx адрес масива;
			mov ecx, ArraySize  			; Присоюємо регістру значення змінної "ArraySize" - розмір масиву;
			CountingZeroes:					; Початок Циклу CountingZeroes;
			cmp	Array[esi], 0				; Перевірка: Чи є елемент масиву нулем?
			jne	It_is_not_zero				; Якщо елемент масиву не є нулем - перестрибуємо збільшування лічильника!
											;
			Add edx, eax 					; Якщо, нуль знайденно - лічильник нулів забільшуємо на один;
											;
			It_is_not_zero:					;
			add esi, 4 						; Ітерація (esi = esi + 4);
			loop CountingZeroes				; Кінець Циклу CountingZeroes;
			ret 0							; Повернення з підпрограми;
											;
			CountZeroes endp				; Кінець підпрограми;
											;
			;-------------------------------;	
											;
											;
			Check:							;
			test edx, 00000001h          	; Перевірка на парність edx - лічильник нулів; 
			jnz Need_to_delete              ; Стрибаємо, Якщо кількість 0-их елементів масиву – непарна;
											;
			jmp TheEnd						; Стрибаємо в кінець, Якщо кількість 0-их елементів масиву – парна;
			Need_to_delete:					;
			call DeleteZeroes				; Викликаємо DeleteZeroes;
											;
			;-------------------------------;
											;
			DeleteZeroes proc				; Початок підпрограми;
				mov eax, 1					; Присоюємо регістру значення змінної 1;
				push eax					; Зберигаємо у стек заначення eax
				xor eax, eax				; Очищуємо регистр eax;
				xor ecx, ecx 				; Очищуємо регистр ecx;
				xor edx, edx 				; Очищуємо регистр edx;
				xor esi, esi 				; Очищуємо регистр esi;
				xor edi, edi				; Очищуємо регистр edi;
				mov ecx, dword ptr[ebp+16]	; Зберигаємо у есх кiл. eлементiв масива;
				mov ebx, dword ptr[ebp+20]	; Зберигаємо у еdx адрес масива;
				mov ecx, ArraySize  		; Присоюємо регістру значення змінної "ArraySize" - розмір масиву;
				pop eax						; Відновлюємо зі стека значення eax;
											;
				DeletingZeroes:				; Початок Циклу DeleteZeroes;
				mov edi, Array[esi]			;
				cmp	Array[esi], 0			; Перевірка: Чи є елемент масиву нулем?
				jne	Not_Delete			    ; Якщо елемент масиву не є нулем - перестрибуємо збільшування лічильника, 
											; та перевірку та видалення!
											;
				Add edx, eax 				; Якщо, нуль знайденно - лічильник нулів забільшуємо на один;
											;
				test edx, 00000001h			; Перевірка на парність edx - лічильник нулів;
				jnz Not_Delete				; Перестрибуємо видалення нульового елементу, Якщо знайдений 0 – непарний;
											; Видалення 0, Якщо знайдений 0 – парний;
				push ecx					; Зберигаємо у стек заначення ecx;
				push esi					; Зберигаємо у стек заначення esi;
				dec ecx						; Віднвмаємо одиницю від ecx;
				DeletingLoop:				;
				mov ebx, Array[esi+4]		; Зберигаємо наступний елемент масиву;
				mov Array[esi], ebx			; Замінюємо елемент масиву наступним елементом масиву;
				add esi, 4					; Ітерація (esi = esi + 4);
				loop DeletingLoop			;
				mov Array[esi], 0 			; Ставимо нуль у кінець масиву;
				pop esi						; Відновлюємо зі стека значення esi;
				sub esi, 4					; Ітерація (esi = esi + 4);
				pop ecx						; Відновлюємо зі стека значення ecx;
											;
				Not_Delete:					;
				add esi, 4 					; Ітерація (esi = esi + 4);
				loop DeletingZeroes			; Кінець Циклу DeletingZeroes;
				ret 0						; Повернення з підпрограми;
											;
			DeleteZeroes endp 				; Кінець підпрограми;
											;
			;-------------------------------;
											;
		TheEnd: ret							; Корекне завершення програми;
		end Begin 				   			; Kiнець лістингу команд.