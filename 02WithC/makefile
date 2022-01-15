build:
	nasm -felf64 02WithAsm.asm && gcc 02WithC.c 02WithAsm.o -o b.out && ./b.out
	nasm -felf64 02WithC.asm && gcc -no-pie 02WithC.o -o a.out && ./a.out

clean:
	rm 02WithC.o a.out
	rm 02WithAsm.o b.out