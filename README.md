# Calculadora 64-bit (Ponto Flutuante) em Assembly x86_64

Este projeto é uma calculadora simples de ponto flutuante implementada em Assembly x86_64 para Linux, utilizando NASM e vinculada à libc via GCC. O programa permite realizar operações básicas de soma, subtração, multiplicação e divisão com números de ponto flutuante, além de tratar entradas com vírgula ou ponto decimal.

## Funcionalidades
- Operações suportadas:
  - Soma
  - Subtração
  - Multiplicação
  - Divisão (com verificação de divisão por zero)
- Aceita números com vírgula ou ponto como separador decimal
- Interface de texto simples no terminal

## Como compilar e executar

1. **Pré-requisitos:**
   - NASM (montador)
   - GCC (linkador)

2. **Compilação e execução:**

   ```bash
   make        # Compila o programa
   make run    # Executa o programa
   make clean  # Remove arquivos gerados
   ```

   Ou manualmente:

   ```bash
   nasm -f elf64 calculadora_fp.asm -o calculadora_fp.o
   gcc calculadora_fp.o -o calculadora_fp -no-pie
   ./calculadora_fp
   ```

## Uso

Ao executar, o programa exibe um menu com as operações disponíveis. Basta digitar o número da operação desejada, inserir os dois números (usando vírgula ou ponto como separador decimal) e o resultado será exibido. Para sair, escolha a opção 0.

## Estrutura dos arquivos
- `calculadora_fp.asm`: Código-fonte principal em Assembly.
- `Makefile`: Facilita a compilação, execução e limpeza do projeto.

## Observações
- O programa utiliza as funções da libc (`printf`, `scanf`, `strtod`, `exit`) para entrada e saída de dados e conversão de strings para ponto flutuante.
- O buffer de entrada aceita até 63 caracteres para cada número.
- O código está comentado para facilitar o entendimento.

---

Desenvolvido para fins educacionais e de prática em Assembly x86_64.
