; ===============================================================================
; CALCULADORA 64-BITS (PONTO FLUTUANTE)
; Montador: NASM
; Plataforma: Linux 64-bit (vinculado com libc)
;
; Compilação e Linkagem (usando GCC):
; nasm -f elf64 calculadora_fp.asm -o calculadora_fp.o
; gcc calculadora_fp.o -o calculadora_fp -no-pie
; ./calculadora_fp
; ===============================================================================

extern printf
extern scanf
extern exit
extern strtod

section .data
    format_int        db "%ld", 0
    format_float      db "%lf", 0
    format_str        db "%63s", 0
    msg_welcome       db "--- Calculadora 64-bit (Ponto Flutuante) ---", 10, 0
    msg_type_choice   db "Escolha a operacao:", 10, "  1. Soma", 10, "  2. Subtracao", 10, "  3. Multiplicacao", 10, "  4. Divisao", 10, "  0. Sair", 10, "> ", 0
    msg_num1          db "Digite o primeiro numero: ", 0
    msg_num2          db "Digite o segundo numero: ", 0
    msg_result_float  db "Resultado: %lf", 10, 0
    msg_invalid       db "Opcao invalida ou entrada incorreta.", 10, 0
    msg_divzero       db "Erro: Divisao por zero!", 10, 0

section .bss
    align 8
    float_input_buf  resb 64
    escolha_op       resq 1
    num1_float       resq 1
    num2_float       resq 1
    float_input_end   resq 1

section .text
global main

main:
    push rbp
    mov rbp, rsp

main_loop:
    mov rdi, msg_welcome
    xor rax, rax
    call printf
    mov rdi, msg_type_choice
    xor rax, rax
    call printf
    mov rdi, format_int
    mov rsi, escolha_op
    xor rax, rax
    call scanf
    mov rbx, [escolha_op]
    cmp rbx, 0
    je sair
    call get_float_numbers
    movsd xmm0, [num1_float]
    movsd xmm1, [num2_float]
    cmp rbx, 1
    je float_add
    cmp rbx, 2
    je float_sub
    cmp rbx, 3
    je float_mul
    cmp rbx, 4
    je float_div
    mov rdi, msg_invalid
    xor rax, rax
    call printf
    jmp main_loop
float_add:
    addsd xmm0, xmm1
    mov rdi, msg_result_float
    mov rax, 1
    call printf
    jmp main_loop
float_sub:
    subsd xmm0, xmm1
    mov rdi, msg_result_float
    mov rax, 1
    call printf
    jmp main_loop
float_mul:
    mulsd xmm0, xmm1
    mov rdi, msg_result_float
    mov rax, 1
    call printf
    jmp main_loop
float_div:
    movsd xmm2, [num2_float]
    pxor xmm3, xmm3
    ucomisd xmm2, xmm3
    je divzero_float
    movsd xmm0, [num1_float]   ; garantir que xmm0 tem o numerador
    movsd xmm1, [num2_float]   ; garantir que xmm1 tem o denominador
    divsd xmm0, xmm1           ; xmm0 = xmm0 / xmm1
    mov rdi, msg_result_float
    mov rax, 1                 ; 1 argumento flutuante
    call printf
    jmp main_loop
divzero_float:
    mov rdi, msg_divzero
    xor rax, rax
    call printf
    jmp main_loop

get_float_numbers:
    mov rdi, msg_num1
    xor rax, rax
    sub rsp, 8 ; alinhar pilha
    call printf
    add rsp, 8
    ; Limpar buffer
    mov rcx, 64
    mov rdi, float_input_buf
    xor rax, rax
clear_buf1:
    mov byte [rdi], 0
    inc rdi
    loop clear_buf1
    mov rdi, format_str
    mov rsi, float_input_buf
    xor rax, rax
    sub rsp, 8 ; alinhar pilha
    call scanf
    add rsp, 8
    ; Substituir vírgula por ponto
    mov rcx, float_input_buf
substitute_comma_loop1:
    mov al, [rcx]
    test al, al
    jz parse_num1
    cmp al, ','
    jne next_char1
    mov byte [rcx], '.'
next_char1:
    inc rcx
    jmp substitute_comma_loop1
parse_num1:
    mov rdi, float_input_buf
    xor rsi, rsi    ; passar 0 como segundo argumento (NULL)
    sub rsp, 8 ; alinhar pilha
    call strtod
    add rsp, 8
    movsd [num1_float], xmm0

    mov rdi, msg_num2
    xor rax, rax
    sub rsp, 8 ; alinhar pilha
    call printf
    add rsp, 8
    ; Limpar buffer
    mov rcx, 64
    mov rdi, float_input_buf
    xor rax, rax
clear_buf2:
    mov byte [rdi], 0
    inc rdi
    loop clear_buf2
    mov rdi, format_str
    mov rsi, float_input_buf
    xor rax, rax
    sub rsp, 8 ; alinhar pilha
    call scanf
    add rsp, 8
    ; Substituir vírgula por ponto
    mov rcx, float_input_buf
substitute_comma_loop2:
    mov al, [rcx]
    test al, al
    jz parse_num2
    cmp al, ','
    jne next_char2
    mov byte [rcx], '.'
next_char2:
    inc rcx
    jmp substitute_comma_loop2
parse_num2:
    mov rdi, float_input_buf
    xor rsi, rsi    ; passar 0 como segundo argumento (NULL)
    sub rsp, 8 ; alinhar pilha
    call strtod
    add rsp, 8
    movsd [num2_float], xmm0
    ret

sair:
    xor edi, edi
    call exit
