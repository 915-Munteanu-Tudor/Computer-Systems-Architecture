bits 32 

global start        

extern exit, fopen, fclose, fscanf, fprintf, printf               
import exit msvcrt.dll    
import fopen msvcrt.dll    
import fclose msvcrt.dll    
import fscanf msvcrt.dll  
import fprintf msvcrt.dll
import printf msvcrt.dll
segment data use32 class=data

    string db "a", 0, "b", 0, "c", 0, "d", 0, "e", 0, "f", 0, "g", 0, "h", 0, "i", 0, "j", 0
    len equ $-string
    input_file db "input.txt", 0
    input_desc dd -1
    format_int db "%d", 0
    file_name db "output", 0, ".txt", 0
    file_desc dd -1
    access_mode db "r", 0
    writting db "w", 0
    
    n dd 0
    
    


segment code use32 class=code
    start:
    
        push dword access_mode
        push dword input_file
        call [fopen]
        add esp, 4*2
        
        mov [input_desc], eax
        cmp dword [input_desc], 0
        je finish
        
        ; fscanf(file_desc, format, param)
        push dword n
        push dword format_int
        push dword [input_desc]
        call [fscanf]
        add esp, 4*3
        
        push dword [input_desc]
        call [fclose]
        add esp, 4
        
        mov ecx, [n]
        mov edi, string + len
        std
        
        for_file:
            
            mov ebx, dword [n]
            sub ebx, ecx
            add bl, "0"
            mov byte [file_name+6], bl
            
            push ecx
            
            
            ;push dword file_name
            ;call [printf]
            ;add esp, 4
            
            push dword writting
            push dword file_name
            call [fopen]
            add esp, 4*2
            
            cmp eax, 0
            je finish
            mov dword [file_desc], eax
            
            mov eax, 0
            lodsb ; al
            dec edi
            
            push eax
            call [fprintf]
            add esp, 4
            
            push dword [file_desc]
            call [fclose]
            add esp, 4
        
            pop ecx
            
        loop for_file
        
        
        

        finish:
    push dword 0      
    call [exit]       