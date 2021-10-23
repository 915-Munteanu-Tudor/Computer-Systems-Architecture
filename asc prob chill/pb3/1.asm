
bits 32 


global start        


extern exit, fopen, fclose, printf, fread, fprintf
import exit msvcrt.dll     
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll


segment data use32 class=data
    nume_fisier_1 db "in.txt", 0
    nume_fisier_2 db "out.txt", 0
    mod_citire db "r", 0
    mod_scriere db "w", 0
    str_format db "%s", 0
    file_descriptor_1 dd -1
    file_descriptor_2 dd -1
    
    contor dd 0
    len_text dd 0
    len equ 100; numarul maxim de elemente citite din fisier intr-o etapa
    buffer resb len
    sentence resb len
    divizor dd 2
    
segment code use32 class=code
    start:
; Sa se scrie un program care citeste un fisier text care contine propozitii
; si sa se scrie intr un alt fisier doar propozitiile de ordin impar. 
; Numele celor 2 fisiere in segm de date
; propozitiile se termina cu caracterul '!'
        
        ; eax = fopen("in.txt", "r")
        push dword mod_citire
        push dword nume_fisier_1
        call [fopen]
        add esp, 8
        mov [file_descriptor_1], eax
        
        ; eax = fopen("out.txt", "w")
        push mod_scriere
        push nume_fisier_2
        call [fopen]
        add esp, 8
        mov [file_descriptor_2], eax
        
        mov edi, sentence
        read_part_of_the_file:
        
            ; read 100 chr from the file
            ; eax = fread(buffer, 1, len, descriptor)
            push ecx
            push dword [file_descriptor_1]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4*4
            pop ecx
            
            ; when eax = 0, we finished the text
            cmp eax, 0
            jne over_checking_last_sentence
                cmp edi, sentence
                je not_print
                
                ;checked, ok => printf
                mov al, byte 10
                stosb
                mov al, byte 0
                stosb
                
                push ecx
                ; fprintf(file_descriptor, text)
                push dword sentence
                push dword [file_descriptor_2]
                call [fprintf]
                add esp, 4*2
                
                push sentence
                call [printf]
                add esp, 4
                
                pop ecx
                
                not_print:
                jmp close_files
                
            over_checking_last_sentence:
            
            mov esi, dword buffer
            mov ecx, dword eax
            new_sentence:
                
                store_sentence:
                    
                    lodsb
                    jecxz close_files
                    dec ecx
                    
                    cmp al, byte '!'
                    je end_of_sentence
                    cmp al, byte '\0'
                    
                    stosb
                    jecxz buffer_done
                    
                jmp store_sentence
                end_of_sentence:
                
                mov al, byte 10
                stosb
                mov al, byte 0
                stosb
                
                inc dword[contor]
                mov eax, dword[contor]
                mov edx, dword 0
                div dword [divizor]
                ; edx:eax / 2 => eax = cat, edx = rest
                cmp edx, dword 1
                jne nott_print
                
                push ecx
                ; fprintf(file_descriptor, text)
                push dword sentence
                push dword [file_descriptor_2]
                call [fprintf]
                add esp, 4*2
                
                
                push sentence
                call [printf]
                add esp, 4
                pop ecx
                
                nott_print:
                mov edi, sentence
                
            jmp new_sentence
            buffer_done:
        jmp read_part_of_the_file
        
        close_files:
        
        ; close "in.txt"
        push dword [file_descriptor_1]
        call [fclose]
        add esp, 4
        
        ; close "out.txt"
        push dword [file_descriptor_2]
        call [fclose]
        add esp, 4

        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
