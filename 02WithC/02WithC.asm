global main
	extern puts

	section .text
main:
	mov rdi, message
	call puts
	ret

; C 中字符串必须以'\0'结尾
message: db "Hello, World", 0

; 传递参数寄存器顺序，参数顺序从左到右
; - 整数与指针 rdi, rsi, rdx, rcx, r8, r9
; - 浮点类型 xmm0, xmm1, xmm2, xmm3, xmm4, xmm5, xmm6, xmm7
; 剩下的参数将按照从右到左的顺序压入栈中，并在调用之后 由调用函数推出栈
; 等所有的参数传入后，会生成调用指令。所以当被调用函数得到控制权后，返回地址会被保存在 [rsp] 中，第一个局部变量会被保存在 [rsp+8] 中，以此类推
; 栈指针rsp在调用之前，必须与16 字节边界对齐处理。当然，调用的过程中只会把一个 8 bytes 的返回地址推入栈中，所以当函数得到控制权时，rsp 并没有对齐。你需要向栈中压入数据或者从 rsp 减去 8 来使之对齐
; 调用函数需要预留如下寄存器(the calle-save registers)：rbp,rbx,r12,r13,r14,r15。其他的寄存器可以自由使用
; 被调用函数也需要保存 XMCSR 的控制位和 x87 指令集的控制字，但是 x87 指令在 64 位系统中很少见，所以您不必担心这一点
; 整数被返回在rax或rdx:rax,浮点值返回在xmm0或xmm1:xmm0