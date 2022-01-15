	global _start

	; 文本片段
	section .text
_start:
	; 1 号系统调用是写操作
	mov rax, 1
	; 1 代表 stdout
	mov rdi, 1
	; 字符串地址
	mov rsi, message
	; 字节数
	mov rdx, len
	; 调用操作系统写入
	syscall

	; 60 号系统调用是退出
	mov rax, 60
	; 退出代码 0
	xor rdi, rdi
	; 调用操作系统退出
	syscall

	; 常量片段
	section .data
message: db "Hello,World", 10
len: equ $-message
