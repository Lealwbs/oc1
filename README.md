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
    sd t1, 8(sp)          # 10º