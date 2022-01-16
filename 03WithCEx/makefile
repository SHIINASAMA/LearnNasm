build:
	nasm -felf64 -g lib.asm && gcc -g main.c lib.o && ./a.out
	nasm -felf64 -g main.asm && gcc -g -c lib.c && ld -e main main.o lib.o -lc --dynamic-linker /lib/ld-linux-x86-64.so.2 -o b.out && ./b.out

clean:
	rm a.out lib.o
	rm b.out main.o
