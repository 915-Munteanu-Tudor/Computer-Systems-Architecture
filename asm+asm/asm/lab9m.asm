bits 32 ; assembling for the 32 bits architecture

global afish 
extern printf
import printf msvcrt.dll

; declare the EntryPoint (a label defining the very first instruction of the program)

segment data use32 class=data public 
   
    format  db "%x", 0 
    formatdec db "%d ", 0
    formatuns db "%u ", 0
    
  
segment code use32 class=code public 
   afish:
        mov ebx, [esp+4] ; in ebx incarcam 1 sau 2 pt a decide daca afisam signed sau unsigned
        mov eax, [esp+8] ; in eax incarcam numarul care va fi afisat
        
        cmp ebx, dword 1;comparam ebx cu 1, daca nu e 1 afisam unsigned,daca e 2 afisam signed
        jne unsigned
        
        push eax 
        push dword formatdec
        call [printf]
        add esp, 4*2
        ;aici afisam numerele in decimal cu semn
        jmp over_unsigned; daca afisam signed sarim peste afisarea fara semn
        
        unsigned:
        push eax 
        push dword formatuns
        call [printf]
        add esp, 4*2
        ;aici afisam numerele in decimalfara semn
        over_unsigned:
        ret 8