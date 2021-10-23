bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    sir db 69h, 42h, 40h, 69h, 42h, 23h, 0A2h, 69h, 42h, 90h, 0B4h, 05h, 7Ah, 69h, 42h, 90h, 2h, 77h, 88h, 69h, 42h, 90h
    len_sir equ $-sir
    subsir db 69h, 42h
    len_subsir equ $-subsir
    sir_dest resb len_sir 
    contor DD 0H
    
segment code use32 class=code
    start:
        ; Being given a string of bytes and a substring of this string,
        ; eliminate all occurrences of this substring from the initial string.
        
        MOV ESI, sir
        MOV EDI, subsir
        MOV ECX, len_sir
        CLD
        
        JECXZ Pass
        
        Again:
            ; 69h, 42h, 40h, 69h, 42h, 23h, 0A2h, 69h, 42h, 90h, 0B4h, 05h, 7Ah, 69h, 42h, 90h, 2h, 77h, 88h, 69h, 42h, 90h
            ; 69h, 42h
            MOV EDI, subsir
            
            XOR EBX, EBX
            MOV EDX, ECX
            MOV ECX, len_subsir
            
            Verify_if_subsir:
                
                CMPSB
                JNZ Out_of_loop
                INC EBX
            
            loop Verify_if_subsir
        
            Out_of_loop:
            
            MOV EDI, sir_dest
            ADD EDI, DWORD[contor]

            CMP EBX, len_subsir
            JE not_write
            
                INC EBX
                ADD DWORD[contor], EBX
                SUB ESI, EBX
                MOV ECX, EBX
                REP MOVSB
            
            not_write:
            
            DEC EBX
            SUB EDX, EBX
            MOV ECX, EDX
        
        loop Again
        
        Pass:
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
