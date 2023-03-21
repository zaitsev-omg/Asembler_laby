.586 
.model flat, stdcall ; Оголошуємо Модель памяти;

; Системна Функція вікон повідомлення;
extern MessageBoxA@16:near

; Підключення бібліотеку для використання вікон повідомлення;
includelib C:\masm32\lib\user32.lib 

Data segment ; Оголошуємо Сегмент данных
	
	; Оголошуємо змінні, які будуть брати участь в обчисленні;
	WinTitle db "Laboratory work 2",0 ; Текст для заголовку вікна;
	Message db "No! a,b,f are not equal to each other!",0 ; Текст повідомлення, якщо нерівні всі змінні;
	Message2 db "Yes, a = b!",0 ; Текст повідомлення, якщо рівні a = b;
	Message3 db "Yes, a = f!",0 ; Текст повідомлення, якщо рівні a = f;
	Message4 db "Yes, f = b!",0 ; Текст повідомлення, якщо рівні f = b;
	Message5 db "Yes, a = b = f!",0 ; Текст повідомлення, якщо рівні всі змінні;
	
	a dd 2300 ; Оголошуємо зміннy a;
	b dd 2300 ; Оголошуємо зміннy b;
 	f dd 2300 ; Оголошуємо зміннy f;
 	
Data ends ; Закінчуємо оголушавіти змінні;

Main segment ; Головний Сегмент

Begin: ; Оголошуємо початок лістингу команд;
	
	push 0 ; Ідентифікатор 0 - для вікна з однією кнопкю "OK".
	push offset WinTitle ; Встановлюємо текст для заголовку вікна;
	
	xor eax, eax ; Очищуємо регистр eax;
	xor ebx, ebx ; Очищуємо регистр ebx;
	xor edx, edx ; Очищуємо регистр edx;
	 
	Mov eax,a ; Відправляємо змінну a у регістр eах;
	Mov ebx,b ; Відправляємо змінну b у регістр ebх;
	Mov edx,f ; Відправляємо змінну f у регістр edх;
	
	cmp eax, ebx ; Порівнюємо a та b;
	je m2 ; Якщо a = b - стрибаємо на m2;
	
	cmp eax, edx ; Порівнюємо a та f;
	je m3 ; Якщо a = f - стрибаємо на m3;
	
	cmp edx, ebx ; Порівнюємо b та f;
	je m4 ; Якщо f = b - стрибаємо на m4;
	
	push offset Message ; Відправляємо текст "No! a,b,f are not equal to each other!" до вікна повідомлення;
	jmp m6 ; Cтрибаємо на m6;
	
	m2:
	
	cmp eax, edx ; Порівнюємо a та f;
	je m5 ; Якщо f = b - стрибаємо на m5;
	
	push offset Message2 ; Відправляємо текст "Yes, a = b!" до вікна повідомлення;
	jmp m6 ; Cтрибаємо на m6;
	m3:
	push offset Message3 ; Відправляємо текст "Yes, a = f!" до вікна повідомлення;
	jmp m6 ; Cтрибаємо на m6;
	m4:
	push offset Message4 ; Відправляємо текст "Yes, f = b!" до вікна повідомлення;
	jmp m6 ; Cтрибаємо на m6;
	m5:
	push offset Message5 ; Відправляємо текст  "Yes, a = b = f!" до вікна повідомлення; 
	
	m6:
	push 0 ; Ідентифікатор вікна;
	call MessageBoxA@16 ; Виклик вікна повідомлення;
	ret ; Корекне завершення програми.
	
Main ends ; Кінець головного Сегмента;
end Begin ; Оголошуємо кінець лістингу команд;