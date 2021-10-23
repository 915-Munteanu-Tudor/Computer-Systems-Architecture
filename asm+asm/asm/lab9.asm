bits 32
global start 

extern exit,scanf,printf
extern afish

import scanf msvcrt.dll
import printf msvcrt.dll
import exit msvcrt.dll  

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    n dd 0
    sir resd 30
    format  db "%x", 0 
    formatdec db "%d ", 0
    out1 db "Signed: ", 0
    out2 db "%cUnsigned: ", 0

    
; our code starts here
segment code use32 class=code
    start:
    
        mov eax, 1
        mov ecx, 0
        mov edi, sir; punem in edi sirul destinatie
        
        continue_reading:
            
            pushad
            push dword n
            push dword format
            call [scanf]
            add esp, 4 * 2
            popad
            ;incepem si citim nr cu nr de la tastatura
            
            mov eax, dword[n]
            cmp eax, dword 0; comparam nr citit cu 0, si daca este 0, nu mai citim
            je finish_reading
         
            inc ecx; incrementam ecx=nr de termeni ai sirului
            mov eax, dword[n]
            stosd; punem nr citit in sirul destinstie
        
        jmp continue_reading; reluam citirea pana dam de 0
        finish_reading:
        
        ; "Signed: "
        pushad
        push dword out1
        call [printf]
        add esp, 4
        popad
        ;afisam mesajul "signed"
        
        mov edx, ecx;salvam ecx in edx, adica nr de elemente din sir, pt a putea relua loopul la unsigned
        mov esi, sir; incarcam sirul sursa in esi
        Display_numbers_signed:
            
            pushad
            push dword [esi]
            push dword 1
            call afish
            popad
            ;afisam numerele in forma signed rand pe rand
            add esi, 4; trecem la urmatorul element din sir
        loop Display_numbers_signed
        
        ; "Unsigned: "
        pushad
        push dword 10; cod ascii pt endl impns pe stack pt apelul mesajului
        push dword out2
        call [printf]
        add esp, 8; curatam stackul
        popad
        ;afisam mesajul "unsigned"
        
        
        mov ecx, edx; punem in ecx nr de nr din sir salvsat anterior pt a face loopul de ecx ori
        mov esi, sir; incarcam sirul sursa in esi
        Display_numbers_unsigned:
            
            pushad
            push dword [esi]
            push dword 2
            call afish
            popad 
            ;afisam numerele in forma signed rand pe rand
            add esi, 4; trecem la urmatorul element din sir
        loop Display_numbers_unsigned
        
        ; exit(0)
        push    dword 0 
        call    [exit] 