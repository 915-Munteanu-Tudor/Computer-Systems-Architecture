bits 32 

global start        

extern exit, fopen, fclose, printf, fread, fprintf, scanf, fgets
import exit msvcrt.dll     
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
import fgets msvcrt.dll 

segment data use32 class=data
    nume_fisier resb 50
    divizor16 dd 10h
    divizor2 db 2
    format_read db "%s", 0
    format_print db "%X", 0
    format_write db "%X ", 0
    mode db "w", 0
    file_descriptor dd -1
    rest_of_digits dd -1

segment code use32 class=code
    start:
        
        ; citim numele fisierului de la tastatura
        push nume_fisier
        push format_read
        call[scanf]
        add esp, 8
        
        ; deschidem fisierul citit de la tastatura

        push mode
        push nume_fisier
        call[fopen]
        add esp, 8
        
        ; if eax = 0 -> error
        cmp eax, 0
        je error_fopen
        mov [file_descriptor], eax
        
        ; printam descriptorul de fisier in baza 16
        push dword [file_descriptor]
        push format_print
        call [printf]
        add esp, 8
        
        mov eax, dword[file_descriptor]
        mov ecx, 8
        digits:
            ; parcurgem cifra cu cifra file_descriptor-ul
            mov edx, 0          ; in edx:eax avem file_descriptorul
            div dword[divizor16]  ; eax = cat = restul cifrelor din descriptor, edx = rest = ultima cifra din descriptor
            mov [rest_of_digits], eax   ; salvam restul de cifre in eax, pt ca il vom folosi mai departe in impartire
            
            ; verificam daca edx e cifra para sau impara
            ; fiind numai o cifra in edx, butem lua numai un word din el (ax=dx) si sa il impartim la un byte (divizor2)
            mov ax, dx
            div byte[divizor2]
            cmp AH, byte 0
            jne not_even
                ; punem cifra in fisier
                push ECX
                push EDX
                push format_print
                push dword [file_descriptor]
                call [fprintf]
                add esp, 12
                pop ecx
                
                not_even:
                mov eax, dword [rest_of_digits]
            ;avem nev de un loop pt a parcurge toate cifrele. vor fi 8 cifre, deci ecx = 8
        loop digits

        error_fopen:
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        push    dword 0      
        call    [exit]       
