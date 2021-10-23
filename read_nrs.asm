bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit    ,fscanf, printf  , fopen, fclose         ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fscanf msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    file_name db "name1.txt", 0
    desc dd -1
    access db "r", 0
    format db "%d", 0
    n dd 0
    format1 db "%d ", 0

; our code starts here
segment code use32 class=code
    start:
        
        push dword access
        push dword file_name
        call[fopen]
        add esp, 4*2
        
        mov [desc], eax
        cmp eax, 0
        je finish
        
        read:

            push dword n
            push dword format
            push dword [desc]
            call[fscanf]
            add esp, 4*3
            
            cmp eax, 0
            jl stop
            
            push dword [n]
            push dword format1
            call[printf]
            add esp, 4*2
            
        jmp read
        stop:
        
        push dword[desc]
        call[fclose]
        add esp,4
        
        finish:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
