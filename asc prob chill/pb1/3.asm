bits 32 

global start        

extern exit, fopen, fclose, printf, fread, fprintf, scanf, fgets, strlen
import exit msvcrt.dll     
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
import fgets msvcrt.dll
import strlen msvcrt.dll


segment data use32 class=data
    file_name db "in3.txt", 0
    buffer resb 100
    out_file resb 50
    sentence resb 100

    
    format_string db "%s", 0
    mod_read db "r", 0
    mod_write db "w", 0
    file_descriptor dd -1
    file_descriptor_out dd -1
    
segment code use32 class=code
    start:
        
        ; eax = fopen("in3.txt", "r")
        push mod_read
        push file_name
        call[fopen]
        add esp, 8
        ; if eax = 0 -> error
        cmp eax, 0
        je error_fopen
        mov [file_descriptor], eax
        
        mov edi, sentence
        Buffer:
            ;char *fgets(char *str, int n, FILE *stream)
            ;eax = fread(buffer, 1, len, descriptor)
            push dword [file_descriptor]
            push 100
            push buffer
            call [fgets]
            add esp, 12
            ; if eax = 0 -> file_empty
            cmp eax, 0
            je empty_file
            mov esi, buffer
            
            push buffer
            call [strlen]
            add esp, 4
            
            mov ecx, eax
        
            Another_sentence:
                
                ;Interpret the file name
                mov edi, out_file
                for_out_file:
                
                    cmp ecx, 0
                    je end_of_buffer
                    lodsb
                    dec ecx
                    cmp al, byte ' '
                    je out_file_ready
                    stosb
                    
                jmp for_out_file
                
                out_file_ready:
                    
                    push ecx
                    
                    mov al, 0
                    stosb
                    
                    ; Create the file and open for writing
                    ; eax = fopen(out_file, "r")
                    push mod_write
                    push out_file
                    call[fopen]
                    add esp, 8
                    ; if eax = 0 -> error
                    cmp eax, 0
                    je error_fopen
                    mov [file_descriptor_out], eax
                    
                    mov al, 10
                    stosb
                    
                    pop ecx
                    
                mov edi, sentence
                
                Again:
                
                    cmp ecx, 0
                    je end_of_buffer
                    
                    lodsb
                    dec ecx
                    
                    cmp al, byte 10
                    je end_of_sentence
                    cmp al, byte 0
                    je end_of_buffer
                    
                    stosb
                
                jmp Again
                end_of_sentence:
                
                ;store in file
                mov al, 10
                stosb
                mov al, 0
                stosb
                
                push ecx
                ; fprintf(file_descriptor, text)
                push dword sentence
                push dword [file_descriptor_out]
                call [fprintf]
                add esp, 4*2
                
                push sentence
                call [printf]
                add esp, 4
                
                pop ecx
            
            jmp Another_sentence
            end_of_buffer:
        
        jmp Buffer
        
        end_of_file:
        empty_file:
        
        ;Check if the last sentence needs to be stored 
        push dword sentence
        push dword [file_descriptor_out]
        call [fprintf]
        add esp, 4*2
        
        push sentence
        call [printf]
        add esp, 4
        
        error_fopen:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
