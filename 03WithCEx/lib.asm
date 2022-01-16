    global addNumber:
    section .text

; int64_t addNumber(int64_t, int64_t, int64_t, int64_t,
;                   int64_t, int64_t, int64_t, int64_t);
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
