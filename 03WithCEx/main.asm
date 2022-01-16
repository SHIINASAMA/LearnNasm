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

    mov rdi, format
    mov rsi, 1
    call printf

    mov rax, 60
    xor rdi, rdi
    syscall
    
    section .data
format: db "%d", 0x0A, 0x0
