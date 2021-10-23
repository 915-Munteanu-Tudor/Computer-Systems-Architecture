bits 32 

global start        

extern exit, scanf, fopen, fclose      
import exit msvcrt.dll   
import fopen msvcrt.dll   
import fclose msvcrt.dll   
import scanf msvcrt.dll   
 
; se citeste de la tastatura un numar si un sir de caractere si apoi se creeaza un fisier cu numele "(sir)(numar).txt"

                         
segment data use32 class=data
    a dd 0
    decimal_format db "%d", 0
    buffer times 50 db 0
    string_format db "%s", 0
    access_mode db "w", 0
    file_descriptor dd -1
    extensie db ".txt", 0
    
segment code use32 class=code
    start:
    ; scanf("%d", &a)
    push dword a
    push dword decimal_format
    call [scanf]
    add ESP, 4*2
    
    ; scanf("%s", &buffer)
    push dword buffer
    push dword string_format
    call [scanf]
    add ESP, 4*2
    
    cld 
    mov ESI, buffer
    
    my_loop:
        lodsb
        
        cmp AL, 0
        je exit_loop
    jmp my_loop
    
    exit_loop:
    dec ESI
    
    mov BL, byte[a]
    add BL, '0'
    
    mov byte[ESI], BL
    inc ESI
    
    mov EDI, ESI
    mov ESI, extensie
    
    loop_2:
        lodsb 
        stosb
        cmp al, 0
        je stop_loop
    jmp loop_2
    
    stop_loop:
    
    ; fopen(&filename, &access_mode)
    push dword access_mode
    push dword buffer
    call [fopen]
    add ESP, 4*2
    
    cmp EAX, 0
    je errorx
mov dword[file_descriptor], EAX

    ; fclose(file_descriptor)
    push dword [file_descriptor]
    call [fclose]
    add ESP, 4*1
    
        errorx:
    
       
        push    dword 0   
        call    [exit]   