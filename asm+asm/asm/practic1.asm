bits 32 


global start        


extern exit, fopen, fclose, printf, fread, fprintf,scanf,gets
import exit msvcrt.dll     
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll
import gets msvcrt.dll


segment data use32 class=data
    
    nume_fisier resb 100
    mod_acces db "r", 0
    text_fisier resb len
    len equ 100
    file_descriptor db -1
    divisor dd 4
    cuvant resb 50
    
    format db "%c", 0
    
    
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
    push dword 1
    push dword text_fisier
    call [fread]
    add esp, 16
    
    mov ecx, eax
    
    push dword [file_descriptor]
    call [fclose]
    add esp, 4
    
    mov esi, text_fisier
    mov eax, 0
    mov edi, cuvant
    
    bucla:
    
    lodsb
    ;mov ebx, dword 0
    ;add bl, al
    cmp al, ' '
    je not_store
    
    stosb
    
    not_store:
    
    cmp al, ' '
    je store
    
    store:
    inc eax
    mov edx, 0
    div dword[divisor]
    cmp edx, dword 0
    jne not_print
    
    push dword cuvant
    push dword format
    call [printf]
    add esp, 8
    
    not_print:
    
    add esi, 2
    dec ecx
    
    jmp bucla

    
    
    final_program:


        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
