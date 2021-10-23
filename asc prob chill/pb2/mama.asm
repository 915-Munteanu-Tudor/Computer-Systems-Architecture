bits 32 


global start        


extern exit, fopen, fclose, printf, fread, fprintf,scanf,gets,strtok,fgets
import exit msvcrt.dll     
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll
import gets msvcrt.dll
import strtok msvcrt.dll
import fgets msvcrt.dll

segment data use32 class=data

    len equ 100
    nume_fisier resb 100
    mod_acces db "r", 0
    text_fisier resb len
    file_descriptor db -1
    divisor dd 4
    cuvant resb 50
    delimitator dd ' ', 0
    contor dd 0
    auxiliar dd 0
    
    format db "%s",10,0
    
    
segment code use32 class=code
    start:
    
    push dword nume_fisier
    call [gets]
    add esp, 4
    
    push dword mod_acces
    push dword nume_fisier
    call [fopen]
    add esp, 8
    
    mov [file_descriptor], eax
    
    
    cmp eax, 0
    je final_program
    
    push dword[file_descriptor]
    push dword len
    push dword text_fisier
    call [fgets]
    add esp, 12
    
    push dword delimitator
    push text_fisier
    call [strtok]
    add esp, 8
    
    
    bucla:
    
    inc dword[contor]
    cmp eax, 0
    je final_program
    mov dword [auxiliar], eax
    mov eax, dword[contor]
    mov edx, 0
    mov ebx, 4
    div ebx
    cmp edx, 0
    
    jne not_print
    mov eax, dword[auxiliar]
    
    push dword eax
    push dword format
    call [printf]
    add esp, 4 * 2
    
    not_print
    push dword delimitator
    push dword 0
    call [strtok]
    add esp, 8
    
    jmp bucla
    
    final_program:


        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
