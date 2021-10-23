bits 32 ; assembling for the 32 bits architecture

global _afish 

extern _printf
;import printf msvcrt.dll

; declare the EntryPoint (a label defining the very first instruction of the program)

segment data use32 class=data public 
   
    format  db "%x", 0 
    formatdec db "%d ", 0
    formatuns db "%u ", 0
    
  
segment code use32 class=code public 
   _afish:
        mov ebx, [esp+4] ; 2
        mov eax, [esp+8] ; 12
        
        cmp ebx, dword 1
        jne unsigned
        
        push eax 
        push dword formatdec
        call _printf
        add esp, 4*2
        jmp over_unsigned
        
        unsigned:
        push eax 
        push dword formatuns
        call _printf
        add esp, 4*2
        
        over_unsigned:
        ret