# Nasm 学习资料

- 00Hello 基本程序结构
    
    - 基本结构
    
      ```asm
      	global _start
      	extern puts
      	section .text
      _start:
      	mov rdi, message
      	call puts
      	
      	mov rax, 60
      	xor rdi, rdi
      	syscall
      	
      	section .data
      message: db "Hello", 0x0
      ```
    
    - 注意
      若程序有依赖与libc，结束必须发出exit信号
      在 X86 下为 1
      在 X86_64 下为 60
    
      ```asm
      mov rax, 60
      xor rdi, rdi
      syscall
      ```
    
- 01If 条件分支

    | 跳转指令 | 触发条件   |
    | -------- | ---------- |
    | je       | 等于       |
    | jne      | 不等于     |
    | jl       | 小于       |
    | jnl      | 不小于     |
    | jg       | 大于       |
    | jng      | 不大于     |
    | jle      | 小于等于   |
    | jnle     | 不小于等于 |
    | jge      | 大于等于   |
    | jnge     | 不大于等于 |

- 02WithC 与C的交叉编译

    - X86 架构下，传参只用堆栈寄存器
    - X86_64 架构下，前六个参数使用寄存器，之后才使用堆栈寄存器
      - 整数与指针 rdi, rsi, rdx, rcx, r8, r9
      - 浮点类型 xmm0, xmm1, xmm2, xmm3, xmm4, xmm5, xmm6, xmm7
    - 剩下的参数将按照从右到左的顺序压入栈中，并在调用之后 由调用函数推出栈
    - 等所有的参数传入后，会生成调用指令。所以当被调用函数得到控制权后，返回地址会被保存在 [rsp] 中，第一个局部变量会被保存在 [rsp+8] 中，以此类推
    - 栈指针rsp在调用之前，必须与16 字节边界对齐处理。当然，调用的过程中只会把一个 8 bytes 的返回地址推入栈中，所以当函数得到控制权时，rsp 并没有对齐。你需要向栈中压入数据或者从 rsp 减去 8 来使之对齐
    - 调用函数需要预留如下寄存器(the calle-save registers)：rbp,rbx,r12,r13,r14,r15。其他的寄存器可以自由使用
    - 被调用函数也需要保存 XMCSR 的控制位和 x87 指令集的控制字，但是 x87 指令在 64 位系统中很少见
    - 整数被返回在rax或rdx:rax,浮点值返回在xmm0或xmm1:xmm0

- 03WithCEx （X86_64）与C的交叉编译 - 复杂

    - C 调用 ASM

        ```asm
        ; lib.asm
        	global addNumber:
            section .text
        
        addNumber:
            mov rax, rdi
            add rax, rsi
            add rax, rdx
            add rax, rcx
            add rax, r8
            add rax, r9
        
            add rax, [rsp+0x8]
            add rax, [rsp+0x10]
        
            ret
        ```

        ```c
        // main.c
        #include <inttypes.h>
        #include <stdio.h>
        
        int64_t addNumber(int64_t a, int64_t b, int64_t c, int64_t d,
                          int64_t e, int64_t f, int64_t g, int64_t h);
        
        int main()
        {
            printf("%ld\n", addNumber(1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L));
            return 0;
        }
        ```

        ```makefile
        # makefile
        build:
        	nasm -felf64 -g lib.asm && gcc -g main.c lib.o && ./a.out
        ```

    - ASM 调用 C

        ```asm
        ; main.asm
        	global main
            extern addNumber
            extern printf
        
            section .text write
        main:
            mov rdi, 1
            mov rsi, 2
            mov rdx, 3
            mov rcx, 4
            mov r8, 5
            mov r9, 6
            mov r10, 7
            push r10
            mov r10, 8
            push r10
            call addNumber
        
            mov rdi, format
            mov rsi, rax
            call printf
        
            mov rax, 60
            xor rdi, rdi
            syscall
            
            section .data
        format: db "%d", 10, 0
        ```

        ```c
        // lib.c
        #include <inttypes.h>
        
        extern int64_t addNumber(int64_t a, int64_t b, int64_t c, int64_t d,
                                 int64_t e, int64_t f, int64_t g, int64_t h)
        {
            return a + b + c + d + e + f + g + h;
        }
        ```

        ```makefile
        # makefile
        build:
        	nasm -felf64 -g main.asm && 
        	gcc -g -c lib.c && 
        	ld -e main main.o lib.o -lc --dynamic-linker /lib/ld-linux-x86-64.so.2 -o b.out &&
        	./b.out
        ```

        
