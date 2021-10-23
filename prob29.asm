bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit         ,gets, printf      ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import gets msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    buffer times 50 db 0
    new_string times 50 db 0
    format db "%s ",0

; our code starts here
segment code use32 class=code
    start:
    ;Read a sentence from the keyboard. For each word, obtain a new one by taking the letters in reverse order and print each new word. 
    
        ;gets()
        push dword buffer
        call[gets]
        add esp, 4
        
        mov esi, buffer
        
        main_loop:
            cmp byte[esi], 0
            je stop_main
        
            mov edi, new_string
            cld
            again:
               lodsb 
               cmp al, 0
               je stop
               cmp al, ' '
               je stop
               stosb
               jmp again
               
            stop:   
            
            push esi
            mov esi, new_string
            mov al,0
            mov [edi], al
            dec edi
            
            bucla:
                mov al, [esi]
                mov bl, [edi]
                mov [esi], bl
                mov [edi], al
                inc esi
                dec edi
                cmp esi, edi
                ja stop1
                jmp bucla
            stop1:
            
            push dword new_string
            push dword format
            call[printf]
            add esp, 4*2
            
            pop esi
            jmp main_loop
            
      stop_main:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
