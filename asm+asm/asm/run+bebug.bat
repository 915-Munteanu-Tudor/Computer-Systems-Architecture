cls
nasm -f obj lab9.asm
nasm -f obj lab9m.asm
alink lab9.obj lab9m.obj -oPE -subsys console -entry start
ollydbg.exe lab9.exe
pause