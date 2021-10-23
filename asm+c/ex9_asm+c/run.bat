nasm lab9m.asm -fwin32 -g -o lab9m.obj
cl /Z7 main.c /link lab9m.obj
main.exe
pause