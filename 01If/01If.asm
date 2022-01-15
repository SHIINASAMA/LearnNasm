	global _start

	section .text
_start:
	mov r9, 0
	mov r8, 1
	cmp r9, r8
	je equal
	jne not_equal
equal:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg1
	mov rdx, msg1len
	syscall
	jmp end
not_equal:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg2
	mov rdx, msg2len
	syscall
	jmp end
end:
	mov rax, 60
	xor rdi, rdi
	syscall
	
	section .data
msg1: db "equal", 10
msg1len: equ $-msg1
msg2: db "not equal", 10
msg2len: equ $-msg2

; je	如果等于
; jne	如果不等于
; jl	如果小于
; jnl	如果不小于
; jg	如果大于
; jng	如果不大于
; jle	如果小于等于
; jnle 	如果不小于等于
; jge	如果大于等于
; jnge	如果不大于等于