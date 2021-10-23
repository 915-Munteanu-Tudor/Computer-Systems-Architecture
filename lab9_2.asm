bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fprintf, fopen, fclose, printf, fread               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fprintf msvcrt.dll 
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll 
import fread msvcrt.dll                        
;Se da un fisier text. 
;Sa se citeasca continutul fisierului, 
;sa se determine litera mare (uppercase) cu cea mai mare frecventa si sa se afiseze acea litera, 
;impreuna cu frecventa acesteia. Numele fisierului text este definit in segmentul de date.
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    nume_fisier db "lab10.txt", 0 ; numele fisierului care va fi creat
    mod_acces db "r", 0 ; modul de deschidere a fisierului (mod citire)
    descriptor dd -1 ; variabila in care se salveaza descriptorul fisierului
    nr_caract_citite dd 0
    len equ 100
    buffer resb len
    ascii resb 256
    format db "Litera uppercase cu cea mai mare frecventa este %c. Frecventa literei %c este %d.", 0
    

; our code starts here
segment code use32 class=code
    start:
        ;fopen(nume_fisier, mod_acces)
        ;functia va returna in eax descriptorul fisierului sau 0 in caz de eroare 
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4 * 2 ; se elibereaza parametrii de pe stiva
         
        ;se verifica daca functia fopen a deschis fisierul cu succes (EAX ! = 0)
        cmp eax, 0
        je final
        
        ;se salveaza descriptorul de fisier
        mov [descriptor], eax 
        
        ;se iau cate 100 de caractere din fisier si se transfera in buffer
        repeta:
            ;fread(text, 1, len, descriptor)
            ;se citeste din fisier atata timp cat se poate
            push dword [descriptor]
            push dword len
            push dword 1
            push dword buffer
            call[fread]
            add esp, 4 * 4
            
            
            mov ecx, eax ; se contorizeaza numarul de caractrere pentru a parcurge buffer-ul intr-un loop
            jecxz frecventa
            
            ;se parcurge buffer-ul
            mov esi, buffer ; in esi se transfera sirul buffer
            mov edi, ascii ; in edi se transfera sirul ascii
            cld ; se parcurge sirul de la stanga la dreapta
            parcurgere:
                mov eax, 0
                lodsb ; in al se transfera primul caracter din buffer (primul byte)
                cmp al, 'A'
                jb continua
                cmp al, 'Z'
                ja continua
                inc dword [edi + eax]; se contorizeaza aparitia literei mari ce se afla in al
                continua:
            loop parcurgere
        jmp repeta ; se citesc urmatoarele 100 de caractere
        
        ; se determina caracterul litera mare cu cea mai mare frecventa
        frecventa:
        ;fclose(descriptor)
        ;se inchide fisierul
        push dword [descriptor]
        call [fclose]
        add esp, 4 * 1
        
        ;se incepe determinare frecventei
        mov bl, 0 ; se initializeaza numarul maxim de aparitii cu 0
        mov ecx, 255 ; se initializeaza ecx cu numarul de caractere din tabela ascii
        mov esi, ascii ; in esi se transfera sirul ascii(in care se cauta frecventele)
        
        ; se cauta litera mare cu numarul maxim de aparitii
        aparitii:
            lodsb ; in al se transfera frecventa caracterului din ascii
            cmp al, bl ; se verifica daca frecventa din al este mai mare decat vechiul numar maxim de aparitii(bl)
            jb urmatorul ; daca frecventa din al este mai mica decat cea veche(bl), se trece la urmatoarea frecventa
            mov bl, al ; se salveaza in frecventa maxima (bl) frecventa din al, daca aceasta este mai mare
            mov eax, esi ;  se salveaza in eax valoarea la care s-a ajuns in esi
            sub eax, edi ; se cauta elementului in tabela de coduri ascii(+1)(edi pointeaza spre inceputul sirului ascii)
            mov edx, eax ; se transfera in edx valoarea lui eax, adica caracterul cu numaraul maxim de aparitii(+1)
            dec edx ; se scade 1 pentru a obtine caracterul cautat
            urmatorul:
        loop aparitii
         
        
        ; se afiseaza rezultatul calculat
        mov al, bl; se transfera in al frecventa maxima salvata in bl
        cbw ; se converteste valoarea la word
        cwde; se converteste valoarea la dword
        push dword eax ; frecventa
        push dword edx ; caracterul
        push dword edx
        push dword format
        call [printf]
        add esp, 4 * 3
        
    final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
