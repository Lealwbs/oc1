# Organização de Computadores I - UFMG
## Resumo Completo - RISC-V Assembly e Fundamentos

---

## 1. Introdução ao RISC-V

### 1.1 ISA - Instruction Set Architecture
**RISC-V** é uma arquitetura de conjunto de instruções baseada nos princípios RISC (Reduced Instruction Set Computer), desenvolvida na UC Berkeley.

### 1.2 Filosofia RISC vs CISC

| Característica | RISC | CISC |
|----------------|------|------|
| **Conjunto de instruções** | Pequeno e simples | Grande e complexo |
| **Tamanho das instruções** | Fixo (32 bits) | Variável |
| **Ciclos por instrução** | Poucos (1-3) | Muitos (3-10+) |
| **Complexidade** | Hardware simples | Hardware complexo |
| **Pipeline** | Fácil implementação | Difícil implementação |
| **Exemplo** | RISC-V, ARM, MIPS | x86, x86-64 |

### 1.3 Princípios de Projeto RISC-V
1. **Simplicidade favorece regularidade**
2. **Menor é mais rápido**
3. **Torne o caso comum mais rápido**
4. **Bom design exige bons compromissos**

### 1.4 Características Fundamentais
- **32 registradores** de **64 bits** cada
- Todas as instruções têm **32 bits** (4 bytes)
- Máximo de **3 operandos** por instrução
- Ordem **fixa**: destino primeiro
- Operandos devem ser **registradores** (exceto imediatos)

---

## 2. Sistema de Registradores

### 2.1 Mapa Completo de Registradores

| Reg | ABI | Descrição | Preservado | Uso |
|-----|-----|-----------|------------|-----|
| `x0` | `zero` | Constante 0 | N/A | Sempre zero |
| `x1` | `ra` | Return address | Não | Endereço de retorno |
| `x2` | `sp` | Stack pointer | Sim | Ponteiro da pilha |
| `x3` | `gp` | Global pointer | N/A | Ponteiro global |
| `x4` | `tp` | Thread pointer | N/A | Ponteiro de thread |
| `x5` | `t0` | Temporary 0 | Não | Temporário |
| `x6` | `t1` | Temporary 1 | Não | Temporário |
| `x7` | `t2` | Temporary 2 | Não | Temporário |
| `x8` | `s0/fp` | Saved/frame pointer | Sim | Registrador salvo |
| `x9` | `s1` | Saved register 1 | Sim | Registrador salvo |
| `x10` | `a0` | Argument 0/return 0 | Não | 1º arg/1º retorno |
| `x11` | `a1` | Argument 1/return 1 | Não | 2º arg/2º retorno |
| `x12` | `a2` | Argument 2 | Não | 3º argumento |
| `x13` | `a3` | Argument 3 | Não | 4º argumento |
| `x14` | `a4` | Argument 4 | Não | 5º argumento |
| `x15` | `a5` | Argument 5 | Não | 6º argumento |
| `x16` | `a6` | Argument 6 | Não | 7º argumento |
| `x17` | `a7` | Argument 7 | Não | 8º argumento |
| `x18` | `s2` | Saved register 2 | Sim | Registrador salvo |
| `x19` | `s3` | Saved register 3 | Sim | Registrador salvo |
| `x20` | `s4` | Saved register 4 | Sim | Registrador salvo |
| `x21` | `s5` | Saved register 5 | Sim | Registrador salvo |
| `x22` | `s6` | Saved register 6 | Sim | Registrador salvo |
| `x23` | `s7` | Saved register 7 | Sim | Registrador salvo |
| `x24` | `s8` | Saved register 8 | Sim | Registrador salvo |
| `x25` | `s9` | Saved register 9 | Sim | Registrador salvo |
| `x26` | `s10` | Saved register 10 | Sim | Registrador salvo |
| `x27` | `s11` | Saved register 11 | Sim | Registrador salvo |
| `x28` | `t3` | Temporary 3 | Não | Temporário |
| `x29` | `t4` | Temporary 4 | Não | Temporário |
| `x30` | `t5` | Temporary 5 | Não | Temporário |
| `x31` | `t6` | Temporary 6 | Não | Temporário |

### 2.2 Registradores Especiais do Sistema
- **PC (Program Counter)**: Ponteiro para instrução atual
- **CSR (Control and Status Registers)**: Registradores de controle

### 2.3 Hierarquia de Velocidade de Acesso
1. **Registradores**: ~1 ciclo (mais rápido)
2. **Cache L1**: ~1-3 ciclos
3. **Cache L2**: ~10-20 ciclos
4. **Memória Principal**: ~100-300 ciclos (mais lento)

---

## 3. Formatos de Instruções

### 3.1 Tipos de Instruções (32 bits cada)

#### Formato R (Register)
```
31    25 24  20 19  15 14  12 11   7 6     0
[funct7][rs2 ][rs1 ][f3  ][rd   ][opcode]
```
**Uso**: Operações aritméticas/lógicas com 3 registradores

#### Formato I (Immediate)
```
31           20 19  15 14  12 11   7 6     0
[imm[11:0]   ][rs1 ][f3  ][rd   ][opcode]
```
**Uso**: Operações com constantes, loads, jalr

#### Formato S (Store)
```
31    25 24  20 19  15 14  12 11   7 6     0
[im[11:5]][rs2][rs1 ][f3  ][im[4:0]][op ]
```
**Uso**: Instruções de store

#### Formato B (Branch)
```
31 30    25 24  20 19  15 14  12 11 8 7 6     0
[i][im[10:5]][rs2][rs1][f3 ][im[4:1]][i][op]
```
**Uso**: Desvios condicionais

#### Formato U (Upper immediate)
```
31           12 11   7 6     0
[imm[31:12]   ][rd   ][opcode]
```
**Uso**: LUI, AUIPC

#### Formato J (Jump)
```
31 30      21 20 19     12 11   7 6     0
[i][im[10:1]][i][im[19:12]][rd  ][opcode]
```
**Uso**: JAL

---

## 4. Instruções Aritméticas e Lógicas

### 4.1 Operações Aritméticas Básicas

#### Instruções Tipo R
```assembly
# Aritmética básica
ADD rd, rs1, rs2      # rd = rs1 + rs2
SUB rd, rs1, rs2      # rd = rs1 - rs2
SLL rd, rs1, rs2      # rd = rs1 << rs2 (shift left logical)
SRL rd, rs1, rs2      # rd = rs1 >> rs2 (shift right logical)
SRA rd, rs1, rs2      # rd = rs1 >> rs2 (shift right arithmetic)

# Operações lógicas
AND rd, rs1, rs2      # rd = rs1 & rs2
OR rd, rs1, rs2       # rd = rs1 | rs2
XOR rd, rs1, rs2      # rd = rs1 ^ rs2

# Comparações (set less than)
SLT rd, rs1, rs2      # rd = (rs1 < rs2) ? 1 : 0 (signed)
SLTU rd, rs1, rs2     # rd = (rs1 < rs2) ? 1 : 0 (unsigned)
```

#### Instruções Tipo I (com imediatos)
```assembly
# Aritmética com constantes (-2048 a +2047)
ADDI rd, rs1, imm     # rd = rs1 + imm
SLTI rd, rs1, imm     # rd = (rs1 < imm) ? 1 : 0 (signed)
SLTIU rd, rs1, imm    # rd = (rs1 < imm) ? 1 : 0 (unsigned)

# Operações lógicas com constantes
ANDI rd, rs1, imm     # rd = rs1 & imm
ORI rd, rs1, imm      # rd = rs1 | imm
XORI rd, rs1, imm     # rd = rs1 ^ imm

# Shifts com constantes (shamt: 0-63)
SLLI rd, rs1, shamt   # rd = rs1 << shamt
SRLI rd, rs1, shamt   # rd = rs1 >> shamt (lógico)
SRAI rd, rs1, shamt   # rd = rs1 >> shamt (aritmético)
```

### 4.2 Exemplos Práticos

```assembly
# Exemplo 1: Calcular x = (a + b) * 4
ADD t0, a0, a1        # t0 = a + b
SLLI t0, t0, 2        # t0 = t0 << 2 (multiplica por 4)
MV a0, t0             # x = t0

# Exemplo 2: Implementar abs(x)
SRAI t0, a0, 63       # t0 = sinal de a0 (0 ou -1)
XOR t1, a0, t0        # t1 = a0 ^ sinal
SUB a0, t1, t0        # a0 = t1 - sinal = |a0|

# Exemplo 3: Swap de duas variáveis sem temporário
XOR a0, a0, a1        # a0 = a0 ^ a1
XOR a1, a0, a1        # a1 = (a0 ^ a1) ^ a1 = a0
XOR a0, a0, a1        # a0 = (a0 ^ a1) ^ a0 = a1
```

---

## 5. Acesso à Memória

### 5.1 Instruções de Load (Memória → Registrador)

```assembly
# Loads com extensão de sinal
LB rd, offset(rs1)    # Load byte (8 bits) com sinal
LH rd, offset(rs1)    # Load halfword (16 bits) com sinal  
LW rd, offset(rs1)    # Load word (32 bits) com sinal
LD rd, offset(rs1)    # Load doubleword (64 bits)

# Loads sem extensão de sinal (unsigned)
LBU rd, offset(rs1)   # Load byte unsigned
LHU rd, offset(rs1)   # Load halfword unsigned
LWU rd, offset(rs1)   # Load word unsigned
```

### 5.2 Instruções de Store (Registrador → Memória)

```assembly
SB rs2, offset(rs1)   # Store byte (8 bits)
SH rs2, offset(rs1)   # Store halfword (16 bits)
SW rs2, offset(rs1)   # Store word (32 bits)  
SD rs2, offset(rs1)   # Store doubleword (64 bits)
```

### 5.3 Endereçamento e Alinhamento

#### Tamanhos de Dados
| Tipo | Tamanho | Alinhamento | Range offset |
|------|---------|-------------|--------------|
| byte | 8 bits | 1 byte | -2048 a +2047 |
| halfword | 16 bits | 2 bytes | deve ser par |
| word | 32 bits | 4 bytes | múltiplo de 4 |
| doubleword | 64 bits | 8 bytes | múltiplo de 8 |

#### Cálculo de Endereços para Arrays
```assembly
# Array A[i], onde cada elemento tem 8 bytes
# Endereço = base + i * 8

# Método 1: Multiplicação direta
SLL t0, t1, 3         # t0 = i * 8 (shift left 3)
ADD t0, t0, t2        # t0 = base + i * 8
LD t3, 0(t0)          # Carrega A[i]

# Método 2: Usando offset direto  
LD t3, 0(t2)          # A[0]
LD t3, 8(t2)          # A[1]  
LD t3, 16(t2)         # A[2]
```

### 5.4 Exemplos Complexos

```assembly
# Exemplo 1: C[i] = A[i] + B[i] (arrays de inteiros 64-bit)
# Assumindo: a0=base_A, a1=base_B, a2=base_C, a3=i
SLL t0, a3, 3         # t0 = i * 8
ADD t1, a0, t0        # t1 = &A[i]
ADD t2, a1, t0        # t2 = &B[i]
ADD t3, a2, t0        # t3 = &C[i]
LD t4, 0(t1)          # t4 = A[i]
LD t5, 0(t2)          # t5 = B[i]
ADD t6, t4, t5        # t6 = A[i] + B[i]
SD t6, 0(t3)          # C[i] = A[i] + B[i]

# Exemplo 2: Copiar string (até encontrar '\0')
copy_loop:
    LB t0, 0(a0)      # Carrega caractere da string origem
    SB t0, 0(a1)      # Armazena na string destino
    BEQZ t0, done     # Se '\0', termina
    ADDI a0, a0, 1    # Próximo caractere origem
    ADDI a1, a1, 1    # Próximo caractere destino
    J copy_loop
done:
```

---

## 6. Instruções de Controle de Fluxo

### 6.1 Desvios Condicionais

```assembly
# Comparações de igualdade
BEQ rs1, rs2, label   # Branch if rs1 == rs2
BNE rs1, rs2, label   # Branch if rs1 != rs2

# Comparações signed
BLT rs1, rs2, label   # Branch if rs1 < rs2 (signed)
BLE rs1, rs2, label   # Branch if rs1 <= rs2 (signed)
BGT rs1, rs2, label   # Branch if rs1 > rs2 (signed)
BGE rs1, rs2, label   # Branch if rs1 >= rs2 (signed)

# Comparações unsigned
BLTU rs1, rs2, label  # Branch if rs1 < rs2 (unsigned)
BLEU rs1, rs2, label  # Branch if rs1 <= rs2 (unsigned)
BGTU rs1, rs2, label  # Branch if rs1 > rs2 (unsigned)
BGEU rs1, rs2, label  # Branch if rs1 >= rs2 (unsigned)

# Comparações com zero (pseudoinstruções)
BEQZ rs1, label       # Branch if rs1 == 0
BNEZ rs1, label       # Branch if rs1 != 0
BLEZ rs1, label       # Branch if rs1 <= 0
BLTZ rs1, label       # Branch if rs1 < 0
BGEZ rs1, label       # Branch if rs1 >= 0
BGTZ rs1, label       # Branch if rs1 > 0
```

### 6.2 Saltos Incondicionais

```assembly
J label               # Jump (pseudoinstrução para JAL x0, label)
JAL rd, label         # Jump and link
JALR rd, offset(rs1)  # Jump and link register
JR rs1                # Jump register (pseudoinstrução para JALR x0, 0(rs1))
```

### 6.3 Estruturas de Controle

#### IF-ELSE
```cpp
// C++
if (a == b) {
    c = d + e;
} else {
    c = d - e;
}

// RISC-V
BNE a0, a1, else_part
    ADD a2, a3, a4        # c = d + e
    J endif
else_part:
    SUB a2, a3, a4        # c = d - e  
endif:
```

#### WHILE Loop
```cpp
// C++
while (i < n) {
    sum += array[i];
    i++;
}

// RISC-V
while_loop:
    BGE t0, t1, end_while # if i >= n, exit
    SLL t2, t0, 3         # t2 = i * 8
    ADD t3, a0, t2        # t3 = &array[i]
    LD t4, 0(t3)          # t4 = array[i]
    ADD t5, t5, t4        # sum += array[i]
    ADDI t0, t0, 1        # i++
    J while_loop
end_while:
```

#### FOR Loop
```cpp
// C++
for (int i = 0; i < 10; i++) {
    array[i] = i * 2;
}

// RISC-V
    LI t0, 0              # i = 0
for_loop:
    LI t1, 10
    BGE t0, t1, end_for   # if i >= 10, exit
    SLL t2, t0, 1         # t2 = i * 2
    SLL t3, t0, 3         # t3 = i * 8 (offset)
    ADD t4, a0, t3        # t4 = &array[i]
    SD t2, 0(t4)          # array[i] = i * 2
    ADDI t0, t0, 1        # i++
    J for_loop
end_for:
```

#### SWITCH-CASE (Jump Table)
```cpp
// C++
switch (x) {
    case 0: y = x + 1; break;
    case 1: y = x * 2; break;
    case 2: y = x - 1; break;
    default: y = 0;
}

// RISC-V
    LI t0, 3
    BGEU a0, t0, default_case
    SLL t1, a0, 3         # t1 = x * 8 (cada endereço = 8 bytes)
    LA t2, jump_table     # Carrega endereço da tabela
    ADD t3, t2, t1        # t3 = &jump_table[x]
    LD t4, 0(t3)          # t4 = jump_table[x]
    JR t4                 # Pula para o caso

case_0:
    ADDI a1, a0, 1        # y = x + 1
    J end_switch
case_1:
    SLL a1, a0, 1         # y = x * 2
    J end_switch
case_2:
    ADDI a1, a0, -1       # y = x - 1
    J end_switch
default_case:
    LI a1, 0              # y = 0
end_switch:

.data
jump_table:
    .quad case_0
    .quad case_1  
    .quad case_2
```

---

## 7. Multiplicação e Divisão

### 7.1 Instruções de Multiplicação (RV32M/RV64M)

```assembly
# Multiplicação básica
MUL rd, rs1, rs2      # rd = (rs1 * rs2)[31:0] (lower 32/64 bits)

# Multiplicação com parte alta
MULH rd, rs1, rs2     # rd = (rs1 * rs2)[63:32] (signed × signed)
MULHU rd, rs1, rs2    # rd = (rs1 * rs2)[63:32] (unsigned × unsigned)  
MULHSU rd, rs1, rs2   # rd = (rs1 * rs2)[63:32] (signed × unsigned)

# Para RV64I
MULW rd, rs1, rs2     # 32-bit multiply, sign-extend result
```

### 7.2 Instruções de Divisão

```assembly
# Divisão com sinal
DIV rd, rs1, rs2      # rd = rs1 / rs2 (signed)
REM rd, rs1, rs2      # rd = rs1 % rs2 (signed remainder)

# Divisão sem sinal  
DIVU rd, rs1, rs2     # rd = rs1 / rs2 (unsigned)
REMU rd, rs1, rs2     # rd = rs1 % rs2 (unsigned remainder)

# Para RV64I
DIVW rd, rs1, rs2     # 32-bit signed division
DIVUW rd, rs1, rs2    # 32-bit unsigned division
REMW rd, rs1, rs2     # 32-bit signed remainder
REMUW rd, rs1, rs2    # 32-bit unsigned remainder
```

### 7.3 Casos Especiais de Divisão

| Operação | Resultado DIV | Resultado REM |
|----------|---------------|---------------|
| `x / 0` | -1 | x |
| `-2^31 / -1` | -2^31 | 0 |
| `x / y` (normal) | x/y | x%y |

### 7.4 Exemplos Práticos

```assembly
# Exemplo 1: Multiplicação por constante (x * 10)
# 10 = 8 + 2 = 2^3 + 2^1
SLL t0, a0, 3         # t0 = x * 8
SLL t1, a0, 1         # t1 = x * 2
ADD a0, t0, t1        # a0 = x * 8 + x * 2 = x * 10

# Exemplo 2: Divisão por potência de 2 (x / 8)
# Método 1: Shift aritmético (apenas positivos)
SRAI a0, a0, 3        # a0 = x / 8

# Método 2: Divisão com correção para negativos
ADDI t0, a0, 7        # t0 = x + 7
SRAI t0, t0, 3        # t0 = (x + 7) / 8
SRAI t1, a0, 63       # t1 = sinal de x (0 ou -1)
AND t1, t1, 7         # t1 = 0 se x>=0, 7 se x<0
ADD t0, a0, t1        # Adiciona correção
SRAI a0, t0, 3        # a0 = x / 8 (correto para negativos)

# Exemplo 3: Implementar x^n usando multiplicação sucessiva
# power(base=a0, exp=a1) -> result=a0
    LI t0, 1              # result = 1
    MV t1, a0             # base atual
power_loop:
    BEQZ a1, power_done   # if exp == 0, done
    ANDI t2, a1, 1        # t2 = exp & 1 (bit menos significativo)
    BEQZ t2, skip_mult
    MUL t0, t0, t1        # result *= base_atual
skip_mult:
    MUL t1, t1, t1        # base_atual = base_atual^2
    SRLI a1, a1, 1        # exp >>= 1
    J power_loop
power_done:
    MV a0, t0             # retorna resultado
```

---

## 8. Instruções de Constantes e Endereços

### 8.1 Instruções para Constantes Grandes

```assembly
# Load Upper Immediate (carrega 20 bits superiores)
LUI rd, imm           # rd[31:12] = imm, rd[11:0] = 0

# Add Upper Immediate to PC  
AUIPC rd, imm         # rd = PC + (imm << 12)
```

### 8.2 Pseudoinstruções Úteis

```assembly
# Load Immediate (para valores de 32 bits)
LI rd, constant       # Expandido pelo assembler

# Exemplos de expansão:
LI t0, 0x12345678     # → LUI t0, 0x12346
                      #   ADDI t0, t0, 0x678

# Load Address (carrega endereço de símbolo)
LA rd, symbol         # rd = endereço de symbol

# Move (copia registrador)
MV rd, rs             # rd = rs → ADDI rd, rs, 0

# Negate
NEG rd, rs            # rd = -rs → SUB rd, x0, rs

# Not  
NOT rd, rs            # rd = ~rs → XORI rd, rs, -1

# Set Equal Zero
SEQZ rd, rs           # rd = (rs == 0) ? 1 : 0 → SLTIU rd, rs, 1

# Set Not Equal Zero
SNEZ rd, rs           # rd = (rs != 0) ? 1 : 0 → SLTU rd, x0, rs
```

### 8.3 Exemplos de Constantes

```assembly
# Carregar diferentes tipos de constantes
LI t0, 42             # Pequena constante positiva
LI t1, -1000          # Pequena constante negativa  
LI t2, 0x80000000     # Constante grande (2^31)
LI t3, 0x123456789ABC # Constante de 64 bits

# Endereços de símbolos
LA t0, main           # Endereço da função main
LA t1, data_array     # Endereço de array de dados
LA t2, string_msg     # Endereço de string
```

---

## 9. Chamadas de Procedimento e Pilha

### 9.1 Convenção de Chamada (ABI)

#### Registradores de Argumentos e Retorno
```assembly
# Argumentos: a0-a7 (x10-x17)  
# Retorno: a0-a1 (x10-x11)
# Endereço de retorno: ra (x1)

# Exemplo de função: int add(int a, int b, int c)
add_function:
    ADD a0, a0, a1        # a0 = a + b
    ADD a0, a0, a2        # a0 = a + b + c
    JALR x0, 0(ra)        # return a0
```

#### Uso da Pilha (Stack)
```assembly
# Prólogo da função (salvar registradores)
addi sp, sp, -16          # Aloca 16 bytes na pilha
sd ra, 8(sp)              # Salva endereço de retorno
sd s0, 0(sp)              # Salva registrador s0

# Corpo da função
# ...

# Epílogo da função (restaurar registradores)  
ld s0, 0(sp)              # Restaura s0
ld ra, 8(sp)              # Restaura ra
addi sp, sp, 16           # Desaloca pilha
jalr x0, 0(ra)            # Retorna
```

### 9.2 Exemplo de Função Recursiva (Fatorial)

```cpp
// C++
int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

// RISC-V
factorial:
    # Prólogo
    addi sp, sp, -16      # Aloca pilha
    sd ra, 8(sp)          # Salva ra
    sd a0, 0(sp)          # Salva n
    
    # Caso base: if n <= 1
    li t0, 1
    ble a0, t0, base_case
    
    # Caso recursivo: n * factorial(n-1)
    addi a0, a0, -1       # a0 = n - 1
    jal ra, factorial     # factorial(n-1)
    
    # a0 agora contém factorial(n-1)
    ld t0, 0(sp)          # Recupera n original
    mul a0, t0, a0        # a0 = n * factorial(n-1)
    j epilogue
    
base_case:
    li a0, 1              # return 1
    
epilogue:
    # Epílogo
    ld ra, 8(sp)          # Restaura ra
    addi sp, sp, 16       # Desaloca pilha
    jalr x0, 0(ra)        # Retorna
```

### 9.3 Passagem de Muitos Argumentos

```cpp
// C++ - função com muitos argumentos
int func(int a1, int a2, int a3, int a4, int a5, 
         int a6, int a7, int a8, int a9, int a10);

// RISC-V - argumentos 9 e 10 vão para a pilha
call_func:
    # Argumentos 1-8 em a0-a7
    li a0, 1
    li a1, 2
    li a2, 3
    li a3, 4  
    li a4, 5
    li a5, 6
    li a6, 7
    li a7, 8
    
    # Argumentos 9-10 na pilha
    li t0, 9
    li t1, 10
    addi sp, sp, -16      # Aloca pilha
    sd t0, 0(sp)          # 9º argumento  
    sd t1, 8(sp)          # 10º argumento
    
    jal ra, func          # Chama função
    
    addi sp, sp, 16       # Limpa pilha
    # Resultado em a0

---

## 10. Ponto Flutuante IEEE 754

### 10.1 Registradores de Ponto Flutuante

RISC-V possui **32 registradores de ponto flutuante separados** (f0-f31):

| Reg | ABI | Descrição | Preservado |
|-----|-----|-----------|------------|
| `f0-f7` | `ft0-ft7` | FP temporaries | Não |
| `f8-f9` | `fs0-fs1` | FP saved registers | Sim |
| `f10-f11` | `fa0-fa1` | FP arguments/return values | Não |
| `f12-f17` | `fa2-fa7` | FP arguments | Não |
| `f18-f27` | `fs2-fs11` | FP saved registers | Sim |
| `f28-f31` | `ft8-ft11` | FP temporaries | Não |

### 10.2 Representação IEEE 754

#### Single Precision (32 bits)
```
31 30    23 22                    0
[S][Exponent][    Mantissa/Fraction    ]
 1     8              23
```

#### Double Precision (64 bits)
```
63 62         52 51                                0  
[S][  Exponent  ][         Mantissa/Fraction         ]
 1      11                      52
```

### 10.3 Fórmula de Representação
```
Valor = (-1)^S × (1 + Mantissa) × 2^(Exponent - Bias)

Bias:
- Single: 127 (2^7 - 1)
- Double: 1023 (2^10 - 1)
```

### 10.4 Tipos de Números IEEE 754

| Tipo | Exponent | Mantissa | Valor |
|------|----------|----------|-------|
| **Zero** | 0 | 0 | ±0.0 |
| **Subnormal** | 0 | ≠ 0 | ±0.mantissa × 2^(-bias+1) |
| **Normal** | 1 a max-1 | qualquer | ±1.mantissa × 2^(exp-bias) |
| **Infinito** | max | 0 | ±∞ |
| **NaN** | max | ≠ 0 | Not a Number |

#### Casos Especiais NaN
- **SNAN** (Signaling NaN): Gera exceção
- **QNAN** (Quiet NaN): Não gera exceção

### 10.5 Instruções de Load/Store FP

```assembly
# Single precision (32 bits)
FLW ft0, offset(rs1)      # Load float word
FSW ft0, offset(rs1)      # Store float word

# Double precision (64 bits)  
FLD ft0, offset(rs1)      # Load float double
FSD ft0, offset(rs1)      # Store float double
```

### 10.6 Operações Aritméticas de Ponto Flutuante

#### Single Precision
```assembly
FADD.S fd, fs1, fs2       # fd = fs1 + fs2
FSUB.S fd, fs1, fs2       # fd = fs1 - fs2
FMUL.S fd, fs1, fs2       # fd = fs1 × fs2
FDIV.S fd, fs1, fs2       # fd = fs1 ÷ fs2
FSQRT.S fd, fs1           # fd = √fs1

# Operações de sinal
FSGNJ.S fd, fs1, fs2      # fd = |fs1| com sinal de fs2
FSGNJN.S fd, fs1, fs2     # fd = |fs1| com sinal oposto de fs2
FSGNJX.S fd, fs1, fs2     # fd = |fs1| com sinal XOR

# Valor absoluto e negação (pseudoinstruções)
FABS.S fd, fs1            # fd = |fs1| → FSGNJ.S fd, fs1, fs1
FNEG.S fd, fs1            # fd = -fs1 → FSGNJN.S fd, fs1, fs1
```

#### Double Precision
```assembly
FADD.D fd, fs1, fs2       # fd = fs1 + fs2
FSUB.D fd, fs1, fs2       # fd = fs1 - fs2
FMUL.D fd, fs1, fs2       # fd = fs1 × fs2
FDIV.D fd, fs1, fs2       # fd = fs1 ÷ fs2
FSQRT.D fd, fs1           # fd = √fs1
FSGNJ.D fd, fs1, fs2      # Manipulação de sinal
FSGNJN.D fd, fs1, fs2
FSGNJX.D fd, fs1, fs2
```

### 10.7 Comparações de Ponto Flutuante

```assembly
# Single precision
FEQ.S rd, fs1, fs2        # rd = (fs1 == fs2) ? 1 : 0
FLT.S rd, fs1, fs2        # rd = (fs1 < fs2) ? 1 : 0
FLE.S rd, fs1, fs2        # rd = (fs1 <= fs2) ? 1 : 0

# Double precision
FEQ.D rd, fs1, fs2        # rd = (fs1 == fs2) ? 1 : 0
FLT.D rd, fs1, fs2        # rd = (fs1 < fs2) ? 1 : 0
FLE.D rd, fs1, fs2        # rd = (fs1 <= fs2) ? 1 : 0

# Máximo e mínimo
FMIN.S fd, fs1, fs2       # fd = min(fs1, fs2)
FMAX.S fd, fs1, fs2       # fd = max(fs1, fs2)
FMIN.D fd, fs1, fs2
FMAX.D fd, fs1, fs2
```

### 10.8 Conversões de Tipo

```assembly
# Float ↔ Integer
FCVT.S.W fd, rs1          # int32 → float
FCVT.S.WU fd, rs1         # uint32 → float
FCVT.S.L fd, rs1          # int64 → float
FCVT.S.LU fd, rs1         # uint64 → float

FCVT.W.S rd, fs1          # float → int32
FCVT.WU.S rd, fs1         # float → uint32
FCVT.L.S rd, fs1          # float → int64
FCVT.LU.S rd, fs1         # float → uint64

# Double ↔ Integer  
FCVT.D.W fd, rs1          # int32 → double
FCVT.D.WU fd, rs1         # uint32 → double
FCVT.D.L fd, rs1          # int64 → double
FCVT.D.LU fd, rs1         # uint64 → double

FCVT.W.D rd, fs1          # double → int32
FCVT.WU.D rd, fs1         # double → uint32
FCVT.L.D rd, fs1          # double → int64
FCVT.LU.D rd, fs1         # double → uint64

# Float ↔ Double
FCVT.D.S fd, fs1          # float → double
FCVT.S.D fd, fs1          # double → float
```

### 10.9 Modos de Arredondamento

| Modo | Código | Descrição |
|------|--------|-----------|
| RNE | 000 | Round to Nearest, ties to Even |
| RTZ | 001 | Round towards Zero |
| RDN | 010 | Round Down (-∞) |
| RUP | 011 | Round Up (+∞) |
| RMM | 100 | Round to Nearest, ties to Max |

### 10.10 Exemplos de Uso

```assembly
# Exemplo 1: Calcular distância euclidiana sqrt(x² + y²)
distance:
    FMUL.S ft0, fa0, fa0      # ft0 = x²
    FMUL.S ft1, fa1, fa1      # ft1 = y²
    FADD.S ft0, ft0, ft1      # ft0 = x² + y²
    FSQRT.S fa0, ft0          # fa0 = sqrt(x² + y²)
    JALR x0, 0(ra)

# Exemplo 2: Implementar fabs() manualmente
my_fabs:
    # Método 1: usando máscara de bits
    LI t0, 0x7FFFFFFF         # Máscara para limpar bit de sinal
    FMV.X.S t1, fa0           # Move float para int
    AND t1, t1, t0            # Remove bit de sinal
    FMV.S.X fa0, t1           # Move de volta para float
    JALR x0, 0(ra)
    
    # Método 2: usando FSGNJ
    FABS.S fa0, fa0           # Pseudoinstrução
    JALR x0, 0(ra)

# Exemplo 3: Soma de array de floats
sum_array_float:
    # a0 = ponteiro array, a1 = tamanho
    LI t0, 0                  # i = 0
    FCVT.S.W ft0, x0          # sum = 0.0
sum_loop:
    BGE t0, a1, sum_done      # if i >= size, done
    SLL t1, t0, 2             # t1 = i * 4 (float = 4 bytes)
    ADD t2, a0, t1            # t2 = &array[i]
    FLW ft1, 0(t2)            # ft1 = array[i]
    FADD.S ft0, ft0, ft1      # sum += array[i]
    ADDI t0, t0, 1            # i++
    J sum_loop
sum_done:
    FMV.S fa0, ft0            # return sum
    JALR x0, 0(ra)
```

### 10.11 Exceções de Ponto Flutuante

| Exceção | Causa | Resultado |
|---------|-------|-----------|
| **Invalid** | 0/0, ∞-∞, √(-x) | NaN |
| **Divide by zero** | x/0 onde x≠0 | ±∞ |
| **Overflow** | Resultado > máximo | ±∞ |
| **Underflow** | Resultado < mínimo | ±0 ou subnormal |
| **Inexact** | Arredondamento necessário | Valor arredondado |

---

## 11. Representação Numérica e Conversões

### 11.1 Sistemas Numéricos

#### Tabela de Conversão (4 bits)
| Decimal | Binário | Octal | Hexadecimal |
|---------|---------|-------|-------------|
| 0 | 0000 | 0 | 0 |
| 1 | 0001 | 1 | 1 |
| 2 | 0010 | 2 | 2 |
| 3 | 0011 | 3 | 3 |
| 4 | 0100 | 4 | 4 |
| 5 | 0101 | 5 | 5 |
| 6 | 0110 | 6 | 6 |
| 7 | 0111 | 7 | 7 |
| 8 | 1000 | 10 | 8 |
| 9 | 1001 | 11 | 9 |
| 10 | 1010 | 12 | A |
| 11 | 1011 | 13 | B |
| 12 | 1100 | 14 | C |
| 13 | 1101 | 15 | D |
| 14 | 1110 | 16 | E |
| 15 | 1111 | 17 | F |

### 11.2 Conversão Entre Bases

#### Decimal → Binário (Divisões sucessivas por 2)
```
37₁₀ → ?₂
37 ÷ 2 = 18 resto 1
18 ÷ 2 = 9  resto 0
9  ÷ 2 = 4  resto 1
4  ÷ 2 = 2  resto 0
2  ÷ 2 = 1  resto 0
1  ÷ 2 = 0  resto 1
Resultado: 100101₂
```

#### Binário → Decimal (Potências de 2)
```
100101₂ = 1×2⁵ + 0×2⁴ + 0×2³ + 1×2² + 0×2¹ + 1×2⁰
        = 32 + 0 + 0 + 4 + 0 + 1
        = 37₁₀
```

#### Hexadecimal ↔ Binário (Grupos de 4 bits)
```
0xAB3F → ?₂
A = 1010, B = 1011, 3 = 0011, F = 1111
0xAB3F = 1010101100111111₂

1101001010₂ → ?₁₆
Grupo: 11 0100 1010 → 011 0100 1010
3     4     A
= 0x34A
```

### 11.3 Extensão de Sinal

#### 4 bits → 8 bits
```
Positivo: 0101₂ (5) → 00000101₂ (5)
Negativo: 1101₂ (-3) → 11111101₂ (-3)
```

#### Algoritmo para Extensão
```assembly
# Extensão de 32 para 64 bits (com sinal)
sign_extend_32_to_64:
    SLLI t0, a0, 32       # Desloca para posição alta
    SRAI a0, t0, 32       # Desloca de volta (com extensão de sinal)
    JALR x0, 0(ra)

# Extensão de 32 para 64 bits (sem sinal)  
zero_extend_32_to_64:
    LI t0, 0xFFFFFFFF     # Máscara de 32 bits
    AND a0, a0, t0        # Limpa bits superiores
    JALR x0, 0(ra)
```

### 11.4 Representações de Números Negativos

#### 1. Sinal-Magnitude
```
+3: 0011
-3: 1011
Problemas: Dois zeros (+0, -0), aritmética complexa
```

#### 2. Complemento de 1
```
+3: 0011
-3: 1100 (inverte todos os bits)
Problemas: Dois zeros (0000, 1111)
```

#### 3. Complemento de 2 (Padrão usado)
```
+3: 0011
-3: 1101 (complemento de 1 + 1)
Vantagens: Um só zero, aritmética mais simples
```

### 11.5 Operações com Complemento de 2

#### Negação (Algoritmo)
```assembly
negate:
    NOT t0, a0            # Inverte todos os bits
    ADDI a0, t0, 1        # Soma 1
    JALR x0, 0(ra)
    
# Ou usando SUB
negate_alt:
    SUB a0, x0, a0        # a0 = 0 - a0
    JALR x0, 0(ra)
```

#### Detecção de Overflow em Soma
```
Overflow ocorre quando:
- Positivo + Positivo = Negativo
- Negativo + Negativo = Positivo

Fórmula: overflow = (a[31] == b[31]) && (sum[31] != a[31])
```

```assembly
add_with_overflow_check:
    ADD t0, a0, a1        # t0 = a + b
    
    # Verificar overflow
    XOR t1, a0, a1        # t1 = a ^ b
    BLTZ t1, no_overflow  # Se sinais diferentes, não há overflow
    
    XOR t2, t0, a0        # t2 = sum ^ a
    BLTZ t2, overflow     # Se sinal mudou, houve overflow
    
no_overflow:
    MV a0, t0             # Retorna resultado
    LI a1, 0              # Flag overflow = false
    JALR x0, 0(ra)
    
overflow:
    LI a1, 1              # Flag overflow = true
    JALR x0, 0(ra)
```

### 11.6 Ranges Numéricos

#### Inteiros com Sinal (n bits)
- **Mínimo**: -2^(n-1)
- **Máximo**: 2^(n-1) - 1

#### Inteiros sem Sinal (n bits)  
- **Mínimo**: 0
- **Máximo**: 2^n - 1

#### Exemplos Práticos
| Tipo | Bits | Min (signed) | Max (signed) | Max (unsigned) |
|------|------|--------------|--------------|----------------|
| byte | 8 | -128 | +127 | 255 |
| halfword | 16 | -32,768 | +32,767 | 65,535 |
| word | 32 | -2,147,483,648 | +2,147,483,647 | 4,294,967,295 |
| doubleword | 64 | -2^63 | 2^63-1 | 2^64-1 |

---

## 12. Análise de Desempenho

### 12.1 Fórmula Fundamental
```
Tempo de CPU = (Instruções/Programa) × (Ciclos/Instrução) × (Tempo/Ciclo)

Ou equivalentemente:

Tempo = Contagem_Instruções × CPI × Período_Clock
```

### 12.2 Métricas de Desempenho

#### Definições Básicas
```
• Período de Clock (T) = Segundos/Ciclo
• Frequência de Clock (f) = Ciclos/Segundo = 1/T
• CPI = Ciclos Por Instrução (média ponderada)
• IPC = Instruções Por Ciclo = 1/CPI
• MIPS = Milhões de Instruções Por Segundo
• FLOPS = Operações de Ponto Flutuante Por Segundo
```

#### Fórmulas Derivadas
```
MIPS = Frequência_Clock / (CPI × 10⁶)
MIPS = Contagem_Instruções / (Tempo_CPU × 10⁶)

Speedup = Tempo_Original / Tempo_Melhorado
Speedup = (CPI_orig × f_orig) / (CPI_new × f_new)
```

### 12.3 Tabela de Conversão de Unidades

#### Tempo
| Unidade | Símbolo | Valor (segundos) | Exemplo |
|---------|---------|------------------|---------|
| segundo | s | 1 | 1 s |
| milissegundo | ms | 10⁻³ | 1 ms = 0,001 s |
| microssegundo | μs | 10⁻⁶ | 1 μs = 0,000001 s |
| nanossegundo | ns | 10⁻⁹ | 1 ns = 10⁻⁹ s |
| picossegundo | ps | 10⁻¹² | 1 ps = 10⁻¹² s |

#### Frequência
| Unidade | Símbolo | Valor (Hz) | Período |
|---------|---------|------------|---------|
| Hertz | Hz | 1 | 1 s |
| Kilohertz | kHz | 10³ | 1 ms |
| Megahertz | MHz | 10⁶ | 1 μs |
| Gigahertz | GHz | 10⁹ | 1 ns |
| Terahertz | THz | 10¹² | 1 ps |

### 12.4 CPI por Tipo de Instrução

#### Hierarquia de Tempo de Execução
```
1. Registrador-Registrador (ADD, SUB, AND, OR)     → 1-2 ciclos
2. Imediato (ADDI, ANDI, shifts)                   → 1-2 ciclos  
3. Load/Store (LD, SD)                             → 2-5 ciclos
4. Branch (BEQ, BNE)                               → 1-3 ciclos
5. Jump (JAL, JALR)                                → 1-2 ciclos
6. Multiplicação (MUL, MULH)                       → 3-10 ciclos
7. Divisão (DIV, REM)                              → 10-40 ciclos
8. Ponto Flutuante Básico (FADD, FMUL)           → 3-6 ciclos
9. Ponto Flutuante Complexo (FDIV, FSQRT)        → 10-50 ciclos
```

#### Cálculo de CPI Médio
```
CPI_médio = Σ(CPI_i × f_i)

onde:
CPI_i = CPI da instrução tipo i
f_i = frequência da instrução tipo i no programa
```

### 12.5 Exemplos de Cálculos

#### Exemplo 1: Comparação de Máquinas
```
Máquina A: Clock = 2.5 GHz, CPI = 2.0
Máquina B: Clock = 3.0 GHz, CPI = 2.5
Qual é mais rápida para o mesmo programa?

Tempo_A = N × 2.0 × (1/2.5×10⁹) = N × 0.8×10⁻⁹ s
Tempo_B = N × 2.5 × (1/3.0×10⁹) = N × 0.833×10⁻⁹ s

Speedup = Tempo_B/Tempo_A = 0.833/0.8 = 1.04

Máquina A é 4% mais rápida.
```

#### Exemplo 2: Otimização de Compilador
```
Programa original: 100M instruções, CPI = 2.2, Clock = 2 GHz
Programa otimizado: 85M instruções, CPI = 2.5, Clock = 2 GHz

Tempo_orig = 100×10⁶ × 2.2 × 0.5×10⁻⁹ = 0.11 s
Tempo_opt = 85×10⁶ × 2.5 × 0.5×10⁻⁹ = 0.106 s

Speedup = 0.11/0.106 = 1.038 → 3.8% mais rápido
```

#### Exemplo 3: Mix de Instruções
```
Programa com:
- 40% ALU (CPI = 1)
- 30% Load/Store (CPI = 4)  
- 20% Branch (CPI = 2)
- 10% Other (CPI = 3)

CPI_médio = 0.4×1 + 0.3×4 + 0.2×2 + 0.1×3
          = 0.4 + 1.2 + 0.4 + 0.3
          = 2.3
```

### 12.6 Lei de Amdahl

#### Fórmula
```
Speedup_geral = 1 / [(1 - f) + (f / Speedup_parte)]

onde:
f = fração do tempo gasta na parte melhorada
Speedup_parte = melhoria na parte otimizada
```

#### Exemplo de Aplicação
```
Se 60% do tempo é gasto em multiplicações e conseguimos
tornar as multiplicações 5× mais rápidas:

f = 0.6
Speedup_parte = 5

Speedup_geral = 1 / [(1-0.6) + (0.6/5)]
              = 1 / [0.4 + 0.12]
              = 1 / 0.52
              = 1.92

Melhoria geral: 92%
```

### 12.7 Fatores que Afetam o Desempenho

#### Hierarquia de Influência
```
1. Algoritmo → Instruções executadas
2. Linguagem de programação → Instruções executadas  
3. Compilador → Instruções executadas, CPI
4. ISA (conjunto de instruções) → Instruções executadas, CPI, Clock
5. Organização/Arquitetura → CPI, Clock
6. Tecnologia → Clock
```

#### Princípios de Otimização
1. **Torne o caso comum mais rápido**
   - Otimize operações frequentes
   - Cache para dados mais usados
   
2. **Lei de Localidade**
   - Temporal: dados recém-usados serão reusados
   - Espacial: dados próximos serão acessados

3. **Paralelismo**
   - Instrução: pipeline, execução superescalar
   - Thread: múltiplos threads simultâneos
   - Processo: múltiplos cores/processadores

---

## 13. Instruções do Sistema e CSR

### 13.1 Control and Status Registers

```assembly
# Acesso a CSRs
CSRRW rd, csr, rs1    # rd = csr; csr = rs1 (read-write)
CSRRS rd, csr, rs1    # rd = csr; csr |= rs1 (read-set)
CSRRC rd, csr, rs1    # rd = csr; csr &= ~rs1 (read-clear)

# Versões com imediato (0-31)
CSRRWI rd, csr, imm   # rd = csr; csr = imm
CSRRSI rd, csr, imm   # rd = csr; csr |= imm  
CSRRCI rd, csr, imm   # rd = csr; csr &= ~imm
```

### 13.2 System Calls e Exceções

```assembly
ECALL                 # Environment call (system call)
EBREAK               # Environment break (debugger)
URET                 # Return from user trap
SRET                 # Return from supervisor trap  
MRET                 # Return from machine trap
WFI                  # Wait for interrupt
```

### 13.3 Barreiras de Memória

```assembly
FENCE                # Memory fence
FENCE.I             # Instruction fence
```

---

## 14. Pseudoinstruções e Macros Úteis

### 14.1 Pseudoinstruções Completas

```assembly
# Movimento e constantes
NOP                  # No operation → ADDI x0, x0, 0
MV rd, rs           # Move → ADDI rd, rs, 0
LI rd, imm          # Load immediate → LUI + ADDI
LA rd, symbol       # Load address → AUIPC + ADDI

# Negação e complemento
NEG rd, rs          # Negate → SUB rd, x0, rs
NOT rd, rs          # Bitwise NOT → XORI rd, rs, -1

# Jumps
J offset            # Jump → JAL x0, offset
JR rs               # Jump register → JALR x0, 0(rs)
RET                 # Return → JALR x0, 0(ra)
CALL offset         # Call → AUIPC + JALR

# Comparações com zero  
SEQZ rd, rs         # Set equal zero → SLTIU rd, rs, 1
SNEZ rd, rs         # Set not equal zero → SLTU rd, x0, rs
SLTZ rd, rs         # Set less than zero → SLT rd, rs, x0
SGTZ rd, rs         # Set greater than zero → SLT rd, x0, rs

# Branches com zero
BEQZ rs, offset     # Branch equal zero → BEQ rs, x0, offset
BNEZ rs, offset     # Branch not equal zero → BNE rs, x0, offset
BLEZ rs, offset     # Branch <= zero → BGE x0, rs, offset
BLTZ rs, offset     # Branch < zero → BLT rs, x0, offset
BGEZ rs, offset     # Branch >= zero → BGE rs, x0, offset  
BGTZ rs, offset     # Branch > zero → BLT x0, rs, offset

# Comparações entre registradores
BGT rs, rt, offset  # Branch greater → BLT rt, rs, offset
BLE rs, rt, offset  # Branch less equal → BGE rt, rs, offset
BGTU rs, rt, offset # Branch greater unsigned → BLTU rt, rs, offset
BLEU rs, rt, offset # Branch less equal unsigned → BGEU rt, rs, offset
```

### 14.2 Macros Úteis para Programação

```assembly
# Macro para salvar contexto
.macro SAVE_CONTEXT
    addi sp, sp, -256     # Aloca espaço para 32 registradores
    sd x1, 0(sp)
    sd x2, 8(sp)
    # ... salva todos os registradores
    sd x31, 248(sp)
.end_macro

# Macro para restaurar contexto
.macro RESTORE_CONTEXT
    ld x1, 0(sp)
    ld x2, 8(sp)  
    # ... restaura todos os registradores
    ld x31, 248(sp)
    addi sp, sp, 256      # Libera espaço
.end_macro

# Macro para imprimir inteiro (simulador)
.macro PRINT_INT reg
    mv a0, \reg
    li a7, 1              # System call print_int
    ecall
.end_macro

# Macro para imprimir string
.macro PRINT_STRING str
    la a0, \str
    li a7, 4              # System call print_string
    ecall
.end_macro

# Macro para multiplicação por potência de 2
.macro MUL_POW2 rd, rs, pow
    slli \rd, \rs, \pow
.end_macro

# Macro para divisão por potência de 2 (unsigned)
.macro DIV_POW2_U rd, rs, pow
    srli \rd, \rs, \pow
.end_macro

# Macro para divisão por potência de 2 (signed)
.macro DIV_POW2_S rd, rs, pow
    srai \rd, \rs, \pow
.end_macro
```

---

## 15. Estrutura de Programas RISC-V

### 15.1 Seções de Programa

```assembly
# Modelo completo de programa RISC-V
.data
    # Variáveis globais
    array: .word 1, 2, 3, 4, 5
    string: .string "Hello World\n"
    float_val: .float 3.14159
    double_val: .double 2.71828
    buffer: .space 100        # Reserva 100 bytes
    
.bss
    # Variáveis não inicializadas
    temp_array: .space 400    # Array de 100 inteiros
    
.text
    .globl main              # Torna main visível globalmente
    
main:
    # Código principal
    li a7, 10                # System call exit
    ecall
    
# Função auxiliar
function:
    # Código da função
    jalr x0, 0(ra)
```

### 15.2 Diretivas do Assembler

#### Diretivas de Dados
```assembly
.byte value               # 8 bits
.half value               # 16 bits  
.word value               # 32 bits
.dword value              # 64 bits
.float value              # Float IEEE 754
.double value             # Double IEEE 754
.string "text"            # String com \0
.ascii "text"             # String sem \0
.space n                  # n bytes zerados
.zero n                   # n bytes zerados (sinônimo)
.align n                  # Alinha na fronteira 2^n
```

#### Diretivas de Controle
```assembly
.text                     # Seção de código
.data                     # Seção de dados inicializados
.bss                      # Seção de dados não inicializados
.globl symbol             # Torna símbolo global
.local symbol             # Símbolo local
.weak symbol              # Símbolo fraco
.type symbol, @function   # Define tipo do símbolo
.size symbol, expression  # Define tamanho
```

### 15.3 System Calls Básicos

#### Tabela de System Calls (Simuladores)
| Código (a7) | Função | Argumentos | Retorno |
|-------------|--------|------------|---------|
| 1 | print_int | a0 = int | - |
| 2 | print_float | a0 = float | - |
| 3 | print_double | a0 = double | - |
| 4 | print_string | a0 = string addr | - |
| 5 | read_int | - | a0 = int |
| 6 | read_float | - | a0 = float |
| 7 | read_double | - | a0 = double |
| 8 | read_string | a0 = buffer, a1 = size | - |
| 9 | sbrk | a0 = bytes | a0 = address |
| 10 | exit | - | - |
| 11 | print_char | a0 = char | - |
| 12 | read_char | - | a0 = char |
| 13 | open | a0 = filename, a1 = flags | a0 = fd |
| 14 | read | a0 = fd, a1 = buffer, a2 = size | a0 = bytes |
| 15 | write | a0 = fd, a1 = buffer, a2 = size | a0 = bytes |
| 16 | close | a0 = fd | a0 = result |
| 17 | exit2 | a0 = exit code | - |

#### Exemplos de System Calls
```assembly
# Imprimir "Hello World"
print_hello:
    la a0, hello_msg
    li a7, 4              # print_string
    ecall
    jalr x0, 0(ra)

.data
hello_msg: .string "Hello World\n"

# Ler um inteiro do usuário
read_integer:
    li a7, 5              # read_int
    ecall
    # a0 agora contém o inteiro lido
    jalr x0, 0(ra)

# Alocar memória dinâmica
malloc:
    # a0 já contém o número de bytes
    li a7, 9              # sbrk
    ecall
    # a0 agora contém o endereço alocado
    jalr x0, 0(ra)
```

---

## 16. Exemplos Avançados e Algoritmos

### 16.1 Ordenação (Bubble Sort)

```cpp
// C++
void bubble_sort(int arr[], int n) {
    for (int i = 0; i < n-1; i++) {
        for (int j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
}

// RISC-V
bubble_sort:
    # a0 = array address, a1 = size
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)         # i
    sd s1, 8(sp)          # j
    sd s2, 0(sp)          # array base
    
    mv s2, a0             # s2 = array base
    li s0, 0              # i = 0
    
outer_loop:
    addi t0, a1, -1       # t0 = n-1
    bge s0, t0, sort_done # if i >= n-1, done
    
    li s1, 0              # j = 0
    sub t1, t0, s0        # t1 = n-1-i
    
inner_loop:
    bge s1, t1, next_i    # if j >= n-i-1, next i
    
    # Calcular &arr[j] e &arr[j+1]
    sll t2, s1, 2         # t2 = j * 4 (word = 4 bytes)
    add t3, s2, t2        # t3 = &arr[j]
    lw t4, 0(t3)          # t4 = arr[j]
    lw t5, 4(t3)          # t5 = arr[j+1]
    
    # if (arr[j] <= arr[j+1]) continue
    ble t4, t5, no_swap
    
    # Swap arr[j] and arr[j+1]
    sw t5, 0(t3)          # arr[j] = arr[j+1]
    sw t4, 4(t3)          # arr[j+1] = temp
    
no_swap:
    addi s1, s1, 1        # j++
    j inner_loop
    
next_i:
    addi s0, s0, 1        # i++
    j outer_loop
    
sort_done:
    ld s2, 0(sp)
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    jalr x0, 0(ra)
```

### 16.2 Busca Binária

```cpp
// C++
int binary_search(int arr[], int size, int target) {
    int left = 0, right = size - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}

// RISC-V
binary_search:
    # a0 = array, a1 = size, a2 = target
    li t0, 0              # left = 0
    addi t1, a1, -1       # right = size - 1
    
search_loop:
    bgt t0, t1, not_found # if left > right, not found
    
    # mid = left + (right - left) / 2
    sub t2, t1, t0        # t2 = right - left
    srl t2, t2, 1         # t2 = (right - left) / 2
    add t2, t0, t2        # t2 = mid = left + (right-left)/2
    
    # Load arr[mid]
    sll t3, t2, 2         # t3 = mid * 4
    add t3, a0, t3        # t3 = &arr[mid]
    lw t4, 0(t3)          # t4 = arr[mid]
    
    # Compare arr[mid] with target
    beq t4, a2, found     # if arr[mid] == target, found
    blt t4, a2, search_right
    
search_left:
    addi t1, t2, -1       # right = mid - 1
    j search_loop
    
search_right:
    addi t0, t2, 1        # left = mid + 1
    j search_loop
    
found:
    mv a0, t2             # return mid
    jalr x0, 0(ra)
    
not_found:
    li a0, -1             # return -1
    jalr x0, 0(ra)
```

### 16.3 Fibonacci (Iterativo e Recursivo)

```assembly
# Fibonacci iterativo - O(n)
fibonacci_iterative:
    # a0 = n, retorna F(n)
    li t0, 0              # a = 0 (F(0))
    li t1, 1              # b = 1 (F(1))
    
    beqz a0, return_zero  # if n == 0, return 0
    li t2, 1
    beq a0, t2, return_one # if n == 1, return 1
    
    li t2, 2              # i = 2
fib_loop:
    bgt t2, a0, fib_done  # if i > n, done
    add t3, t0, t1        # temp = a + b
    mv t0, t1             # a = b
    mv t1, t3             # b = temp
    addi t2, t2, 1        # i++
    j fib_loop
    
fib_done:
    mv a0, t1             # return b
    jalr x0, 0(ra)
    
return_zero:
    li a0, 0
    jalr x0, 0(ra)
    
return_one:
    li a0, 1
    jalr x0, 0(ra)

# Fibonacci recursivo - O(2^n)
fibonacci_recursive:
    # a0 = n
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a0, 0(sp)
    
    li t0, 1
    ble a0, t0, base_case # if n <= 1, return n
    
    # F(n-1)
    addi a0, a0, -1
    jal ra, fibonacci_recursive
    mv t0, a0             # t0 = F(n-1)
    
    # F(n-2)  
    ld a0, 0(sp)          # Restore original n
    addi a0, a0, -2
    jal ra, fibonacci_recursive
    
    add a0, a0, t0        # return F(n-1) + F(n-2)
    j fib_return
    
base_case:
    # return n (0 ou 1)
    ld a0, 0(sp)
    
fib_return:
    ld ra, 8(sp)
    addi sp, sp, 16
    jalr x0, 0(ra)
```

### 16.4 Manipulação de Strings

```assembly
# Comprimento de string
strlen:
    # a0 = string address
    li t0, 0              # counter = 0
strlen_loop:
    lb t1, 0(a0)          # Load character
    beqz t1, strlen_done  # if '\0', done
    addi t0, t0, 1        # counter++
    addi a0, a0, 1        # next character
    j strlen_loop
strlen_done:
    mv a0, t0             # return length
    jalr x0, 0(ra)

# Copia string (strcpy)
strcpy:
    # a0 = dest, a1 = src
    mv t0, a0             # Save dest start
strcpy_loop:
    lb t1, 0(a1)          # Load from src
    sb t1, 0(a0)          # Store to dest
    beqz t1, strcpy_done  # if '\0', done
    addi a0, a0, 1        # next dest
    addi a1, a1, 1        # next src
    j strcpy_loop
strcpy_done:
    mv a0, t0             # return dest
    jalr x0, 0(ra)

# Compara strings (strcmp)
strcmp:
    # a0 = str1, a1 = str2
strcmp_loop:
    lb t0, 0(a0)          # Load from str1
    lb t1, 0(a1)          # Load from str2
    bne t0, t1, not_equal # if different, not equal
    beqz t0, equal        # if both '\0', equal
    addi a0, a0, 1        # next char str1
    addi a1, a1, 1        # next char str2
    j strcmp_loop
    
equal:
    li a0, 0              # return 0
    jalr x0, 0(ra)
    
not_equal:
    sub a0, t0, t1        # return difference
    jalr x0, 0(ra)
```

### 16.5 Operações com Matrizes

```assembly
# Multiplicação de matrizes C = A * B
# A[m][k], B[k][n], C[m][n]
matrix_multiply:
    # a0 = A, a1 = B, a2 = C, a3 = m, a4 = k, a5 = n
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s0, 32(sp)         # i
    sd s1, 24(sp)         # j  
    sd s2, 16(sp)         # l
    sd s3, 8(sp)          # matrix A
    sd s4, 0(sp)          # matrix B
    
    mv s3, a0             # s3 = A
    mv s4, a1             # s4 = B
    li s0, 0              # i = 0
    
mat_i_loop:
    bge s0, a3, mat_done  # if i >= m, done
    li s1, 0              # j = 0
    
mat_j_loop:
    bge s1, a5, mat_next_i # if j >= n, next i
    li s2, 0              # l = 0
    li t6, 0              # sum = 0
    
mat_l_loop:
    bge s2, a4, mat_store # if l >= k, store result
    
    # Calculate A[i][l]
    mul t0, s0, a4        # t0 = i * k
    add t0, t0, s2        # t0 = i * k + l
    sll t0, t0, 2         # t0 = (i*k + l) * 4
    add t0, s3, t0        # t0 = &A[i][l]
    lw t1, 0(t0)          # t1 = A[i][l]
    
    # Calculate B[l][j]  
    mul t2, s2, a5        # t2 = l * n
    add t2, t2, s1        # t2 = l * n + j
    sll t2, t2, 2         # t2 = (l*n + j) * 4
    add t2, s4, t2        # t2 = &B[l][j]
    lw t3, 0(t2)          # t3 = B[l][j]
    
    # sum += A[i][l] * B[l][j]
    mul t4, t1, t3
    add t6, t6, t4
    
    addi s2, s2, 1        # l++
    j mat_l_loop
    
mat_store:
    # Store C[i][j] = sum
    mul t0, s0, a5        # t0 = i * n
    add t0, t0, s1        # t0 = i * n + j
    sll t0, t0, 2         # t0 = (i*n + j) * 4
    add t0, a2, t0        # t0 = &C[i][j]
    sw t6, 0(t0)          # C[i][j] = sum
    
    addi s1, s1, 1        # j++
    j mat_j_loop
    
mat_next_i:
    addi s0, s0, 1        # i++
    j mat_i_loop
    
mat_done:
    ld s4, 0(sp)
    ld s3, 8(sp)
    ld s2, 16(sp)
    ld s1, 24(sp)
    ld s0, 32(sp)
    ld ra, 40(sp)
    addi sp, sp, 48
    jalr x0, 0(ra)
```

---

## 17. Dicas de Programação e Otimização

### 17.1 Técnicas de Otimização

#### 1. Loop Unrolling
```assembly
# Original loop
loop:
    lw t0, 0(a0)
    addi t0, t0, 1
    sw t0, 0(a0)
    addi a0, a0, 4
    addi a1, a1, -1
    bnez a1, loop

# Unrolled loop (4x)
unrolled_loop:
    lw t0, 0(a0)
    lw t1, 4(a0)
    lw t2, 8(a0)
    lw t3, 12(a0)
    addi t0, t0, 1
    addi t1, t1, 1
    addi t2, t2, 1
    addi t3, t3, 1
    sw t0, 0(a0)
    sw t1, 4(a0)
    sw t2, 8(a0)
    sw t3, 12(a0)
    addi a0, a0, 16
    addi a1, a1, -4
    bgtz a1, unrolled_loop
```

#### 2. Strength Reduction
```assembly
# Evitar multiplicação custosa
# x = i * 8
sll x, i, 3           # Melhor que: mul x, i, 8

# Divisão por potência de 2
sra x, y, 3           # x = y / 8 (signed)
srl x, y, 3           # x = y / 8 (unsigned)
```

#### 3. Uso Eficiente de Registradores
```assembly
# Ruim - muitos loads/stores
lw t0, var1
lw t1, var2
add t2, t0, t1
sw t2, result

# Melhor - mantenha valores em registradores
# Carregue uma vez, use muitas vezes
```

### 17.2 Padrões Comuns

#### Troca de Variáveis sem Temporário
```assembly
# Método 1: XOR
xor a0, a0, a1
xor a1, a0, a1
xor a0, a0, a1

# Método 2: Adição/Subtração (cuidado com overflow)
add a0, a0, a1
sub a1, a0, a1
sub a0, a0, a1
```

#### Verificar se Número é Potência de 2
```assembly
# n é potência de 2 se (n & (n-1)) == 0 e n != 0
check_power_of_2:
    beqz a0, not_power    # if n == 0, not power of 2
    addi t0, a0, -1       # t0 = n - 1
    and t1, a0, t0        # t1 = n & (n-1)
    beqz t1, is_power     # if result == 0, is power of 2
not_power:
    li a0, 0              # return false
    jalr x0, 0(ra)
is_power:
    li a0, 1              # return true
    jalr x0, 0(ra)
```

#### Contar Bits Set (Population Count)
```assembly
popcount:
    # a0 = número, retorna quantidade de bits 1
    li t0, 0              # count = 0
popcount_loop:
    beqz a0, popcount_done
    addi t0, t0, 1        # count++
    addi t1, a0, -1       # t1 = a0 - 1
    and a0, a0, t1        # a0 = a0 & (a0-1) remove rightmost 1
    j popcount_loop
popcount_done:
    mv a0, t0             # return count
    jalr x0, 0(ra)
```

---

## 18. Resumo dos Conceitos Principais

### 18.1 Hierarquia de Conhecimento

```
1. ARQUITETURA RISC-V
   ├── 32 registradores de 64 bits
   ├── Instruções de 32 bits
   ├── Principios: simplicidade, regularidade
   └── 6 formatos de instrução (R, I, S, B, U, J)

2. TIPOS DE INSTRUÇÕES
   ├── Aritméticas: ADD, SUB, MUL, DIV
   ├── Lógicas: AND, OR, XOR, shifts
   ├── Memória: LD, SD, LW, SW, LB, SB
   ├── Controle: BEQ, BNE, BLT, BGE, JAL, JALR
   └── Sistema: ECALL, CSR operations

3. REPRESENTAÇÃO NUMÉRICA
   ├── Sistemas: binário, octal, decimal, hexadecimal
   ├── Inteiros: complemento de 2, overflow
   └── Ponto flutuante: IEEE 754, NaN, infinito

4. DESEMPENHO
   ├── Tempo = Instruções × CPI × Período
   ├── MIPS, speedup, lei de Amdahl
   └── Fatores: algoritmo, compilador, arquitetura

5. PROGRAMAÇÃO ASSEMBLY
   ├── Estruturas: if, while, for, funções
   ├── Convenções: ABI, pilha, argumentos
   └── Otimizações: loop unrolling, strength reduction
```

### 18.2 Comandos Essenciais por Categoria

#### Movimento de Dados
```assembly
MV rd, rs                # Copia registrador
LI rd, imm              # Carrega imediato
LA rd, label            # Carrega endereço
LD/SD rd, offset(rs)    # Load/Store 64-bit
LW/SW rd, offset(rs)    # Load/Store 32-bit
```

#### Aritmética Básica
```assembly
ADD/SUB rd, rs1, rs2    # Soma/subtração
ADDI rd, rs1, imm       # Soma com imediato
MUL/DIV rd, rs1, rs2    # Multiplicação/divisão
SLL/SRL/SRA             # Shifts lógicos/aritmético
```

#### Controle de Fluxo
```assembly
BEQ/BNE rs1, rs2, label # Branch igual/diferente
BLT/BGE rs1, rs2, label # Branch menor/maior igual
JAL/JALR                # Jump com link
BEQZ/BNEZ rs, label     # Branch com zero
```

#### Lógica e Bits
```assembly
AND/OR/XOR rd, rs1, rs2 # Operações lógicas
ANDI/ORI/XORI           # Com imediato
NOT rd, rs              # Complemento (pseudo)
SLT/SLTU rd, rs1, rs2   # Set less than
```

---

## 19. Tabelas de Referência Rápida

### 19.1 Registradores por Categoria

| Categoria | Registradores | Uso Principal |
|-----------|---------------|---------------|
| **Especiais** | x0 (zero) | Constante 0 |
| **Sistema** | x1 (ra), x2 (sp) | Return addr, Stack ptr |
| **Argumentos** | x10-x17 (a0-a7) | Parâmetros de função |
| **Temporários** | x5-x7, x28-x31 (t0-t6) | Cálculos temporários |
| **Salvos** | x8-x9, x18-x27 (s0-s11) | Preservados entre chamadas |
| **Ponteiros** | x3 (gp), x4 (tp), x8 (fp) | Global, Thread, Frame |

### 19.2 Tamanhos de Dados

| Nome | Bits | Bytes | Range (signed) | Range (unsigned) |
|------|------|-------|----------------|------------------|
| **byte** | 8 | 1 | -128 a 127 | 0 a 255 |
| **halfword** | 16 | 2 | -32K a 32K-1 | 0 a 64K-1 |
| **word** | 32 | 4 | -2G a 2G-1 | 0 a 4G-1 |
| **doubleword** | 64 | 8 | -2^63 a 2^63-1 | 0 a 2^64-1 |

### 19.3 Codificação de Formatos

| Formato | Opcode | Uso Típico | Exemplo |
|---------|--------|------------|---------|
| **R** | 0110011 | reg-reg ops | ADD, SUB, AND |
| **I** | vários | immediates, loads | ADDI, LD, JALR |
| **S** | 0100011 | stores | SD, SW, SB |
| **B** | 1100011 | branches | BEQ, BNE, BLT |
| **U** | 0110111/0010111 | upper imm | LUI, AUIPC |
| **J** | 1101111 | jumps | JAL |

### 19.4 IEEE 754 Quick Reference

| Formato | Sign | Exponent | Mantissa | Bias | Range |
|---------|------|----------|----------|------|-------|
| **Single** | 1 bit | 8 bits | 23 bits | 127 | ±1.4×10⁻⁴⁵ a ±3.4×10³⁸ |
| **Double** | 1 bit | 11 bits | 52 bits | 1023 | ±4.9×10⁻³²⁴ a ±1.8×10³⁰⁸ |

---

## Conclusão

Este resumo abrange os **conceitos fundamentais de Organização de Computadores I** com foco em **RISC-V Assembly**:

### Tópicos Principais Cobertos:
1. ✅ **Arquitetura RISC-V**: ISA, registradores, formatos de instrução
2. ✅ **Instruções Assembly**: aritméticas, lógicas, memória, controle
3. ✅ **Representação numérica**: inteiros, ponto flutuante IEEE 754
4. ✅ **Análise de desempenho**: CPI, speedup, otimizações
5. ✅ **Programação**: estruturas de controle, funções, algoritmos
6. ✅ **Conceitos avançados**: exceções, system calls, CSR

### Para Estudar:
- **Pratique** convertendo código C para RISC-V
- **Memorize** os registradores mais usados (a0-a7, t0-t6, s0-s11)
- **Entenda** os formatos de instrução e como calcular endereços
- **Domine** análise de desempenho e cálculos de speedup
- **Implemente** algoritmos básicos em assembly

> **"Torne o caso comum mais rápido!"** - Princípio fundamental da otimização em arquitetura de computadores.