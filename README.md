# Organização de Computadores I - UFMG
**Guia Completo: RISC-V Assembly e Arquitetura de Computadores**

## 1. Fundamentos da Arquitetura RISC-V

### 1.1 ISA - Instruction Set Architecture
**RISC-V** (RISC Five) é uma ISA aberta baseada nos princípios RISC desenvolvida na UC Berkeley.

### 1.2 Princípios de Design RISC
1. **Simplicidade favorece regularidade**
2. **Menor é mais rápido**
3. **Bom design exige bons compromissos**
4. **Torne o caso comum rápido**

### 1.3 Características Fundamentais
- **Instruções de 32 bits** (4 bytes cada)
- **Todas as instruções têm 3 operandos**
- **Ordem fixa**: destino primeiro `OP rd, rs1, rs2`
- **32 registradores de 64 bits** (arquitetura RV64I)
- **Memória endereçada por bytes**
- **Little-endian** (byte menos significativo no menor endereço)

### 1.4 RISC vs CISC

| Característica | RISC | CISC |
|----------------|------|------|
| **Instruções** | Simples, tamanho fixo | Complexas, tamanho variável |
| **Registradores** | Muitos (32+) | Poucos (8-16) |
| **Ciclos/Instrução** | 1-2 | 2-15 |
| **Compilador** | Complexo | Simples |
| **Pipeline** | Fácil | Difícil |
| **Exemplo** | RISC-V, ARM | x86, x86-64 |

---

## 2. Sistema de Registradores RISC-V

### 2.1 Mapeamento Completo dos Registradores

| Reg | ABI Name | Descrição | Preservado? | Uso |
|-----|----------|-----------|-------------|-----|
| `x0` | `zero` | Hardwired zero | - | Sempre 0 |
| `x1` | `ra` | Return address | Não | Endereço de retorno |
| `x2` | `sp` | Stack pointer | Sim | Ponteiro da pilha |
| `x3` | `gp` | Global pointer | - | Ponteiro global |
| `x4` | `tp` | Thread pointer | - | Ponteiro de thread |
| `x5` | `t0` | Temporary 0 | Não | Temporário |
| `x6` | `t1` | Temporary 1 | Não | Temporário |
| `x7` | `t2` | Temporary 2 | Não | Temporário |
| `x8` | `s0/fp` | Saved 0/Frame pointer | Sim | Registrador salvo |
| `x9` | `s1` | Saved 1 | Sim | Registrador salvo |
| `x10` | `a0` | Function arg 0 | Não | Argumento/retorno |
| `x11` | `a1` | Function arg 1 | Não | Argumento/retorno |
| `x12` | `a2` | Function arg 2 | Não | Argumento |
| `x13` | `a3` | Function arg 3 | Não | Argumento |
| `x14` | `a4` | Function arg 4 | Não | Argumento |
| `x15` | `a5` | Function arg 5 | Não | Argumento |
| `x16` | `a6` | Function arg 6 | Não | Argumento |
| `x17` | `a7` | Function arg 7 | Não | Argumento |
| `x18` | `s2` | Saved 2 | Sim | Registrador salvo |
| `x19` | `s3` | Saved 3 | Sim | Registrador salvo |
| `x20` | `s4` | Saved 4 | Sim | Registrador salvo |
| `x21` | `s5` | Saved 5 | Sim | Registrador salvo |
| `x22` | `s6` | Saved 6 | Sim | Registrador salvo |
| `x23` | `s7` | Saved 7 | Sim | Registrador salvo |
| `x24` | `s8` | Saved 8 | Sim | Registrador salvo |
| `x25` | `s9` | Saved 9 | Sim | Registrador salvo |
| `x26` | `s10` | Saved 10 | Sim | Registrador salvo |
| `x27` | `s11` | Saved 11 | Sim | Registrador salvo |
| `x28` | `t3` | Temporary 3 | Não | Temporário |
| `x29` | `t4` | Temporary 4 | Não | Temporário |
| `x30` | `t5` | Temporary 5 | Não | Temporário |
| `x31` | `t6` | Temporary 6 | Não | Temporário |

### 2.2 Registradores Especiais do Sistema
- **PC (Program Counter)**: Endereço da instrução atual
- **CSRs (Control and Status Registers)**: Registradores de controle e status

### 2.3 Hierarquia de Velocidade de Acesso
```
Registradores (~0.1 ns) > 
Cache L1 (~1 ns) > 
Cache L2 (~10 ns) > 
RAM (~100 ns) > 
SSD (~0.1 ms) > 
HDD (~10 ms)
```

---

## 3. Formatos de Instruções RISC-V

### 3.1 Tipos de Formato

| Tipo | Uso | Campos | Exemplo |
|------|-----|--------|---------|
| **R** | Reg-Reg | funct7 \| rs2 \| rs1 \| funct3 \| rd \| opcode | `ADD rd, rs1, rs2` |
| **I** | Imediato | imm[11:0] \| rs1 \| funct3 \| rd \| opcode | `ADDI rd, rs1, imm` |
| **S** | Store | imm[11:5] \| rs2 \| rs1 \| funct3 \| imm[4:0] \| opcode | `SW rs2, imm(rs1)` |
| **B** | Branch | imm \| rs2 \| rs1 \| funct3 \| imm \| opcode | `BEQ rs1, rs2, label` |
| **U** | Upper | imm[31:12] \| rd \| opcode | `LUI rd, imm` |
| **J** | Jump | imm[20:1] \| rd \| opcode | `JAL rd, label` |

### 3.2 Distribuição de Bits (32 bits total)
```
R: [31:25] [24:20] [19:15] [14:12] [11:7] [6:0]
   funct7    rs2     rs1    funct3   rd   opcode

I: [31:20]    [19:15] [14:12] [11:7] [6:0]
   imm[11:0]    rs1    funct3   rd    opcode
```

---

## 4. Conjunto Completo de Instruções RISC-V

### 4.1 Instruções Aritméticas (Tipo R e I)

#### Operações com Registradores (Tipo R)
```assembly
# Aritméticas básicas
ADD  rd, rs1, rs2     # rd = rs1 + rs2
SUB  rd, rs1, rs2     # rd = rs1 - rs2
SLT  rd, rs1, rs2     # rd = (rs1 < rs2) ? 1 : 0 (signed)
SLTU rd, rs1, rs2     # rd = (rs1 < rs2) ? 1 : 0 (unsigned)

# Operações lógicas
AND  rd, rs1, rs2     # rd = rs1 & rs2
OR   rd, rs1, rs2     # rd = rs1 | rs2
XOR  rd, rs1, rs2     # rd = rs1 ^ rs2

# Shifts
SLL  rd, rs1, rs2     # rd = rs1 << rs2 (shift left logical)
SRL  rd, rs1, rs2     # rd = rs1 >> rs2 (shift right logical)
SRA  rd, rs1, rs2     # rd = rs1 >> rs2 (shift right arithmetic)
```

#### Operações com Imediatos (Tipo I)
```assembly
# Aritméticas
ADDI  rd, rs1, imm    # rd = rs1 + imm (-2048 a +2047)
SLTI  rd, rs1, imm    # rd = (rs1 < imm) ? 1 : 0 (signed)
SLTIU rd, rs1, imm    # rd = (rs1 < imm) ? 1 : 0 (unsigned)

# Lógicas
ANDI  rd, rs1, imm    # rd = rs1 & imm
ORI   rd, rs1, imm    # rd = rs1 | imm
XORI  rd, rs1, imm    # rd = rs1 ^ imm

# Shifts (imm = 0-63 para RV64I)
SLLI  rd, rs1, imm    # rd = rs1 << imm
SRLI  rd, rs1, imm    # rd = rs1 >> imm (logical)
SRAI  rd, rs1, imm    # rd = rs1 >> imm (arithmetic)
```

### 4.2 Instruções de Acesso à Memória

#### Load Instructions (Tipo I)
```assembly
# 64-bit loads
LD   rd, imm(rs1)     # rd = Mem[rs1 + imm] (64 bits)

# 32-bit loads
LW   rd, imm(rs1)     # rd = Mem[rs1 + imm] (32 bits, sign-extended)
LWU  rd, imm(rs1)     # rd = Mem[rs1 + imm] (32 bits, zero-extended)

# 16-bit loads  
LH   rd, imm(rs1)     # rd = Mem[rs1 + imm] (16 bits, sign-extended)
LHU  rd, imm(rs1)     # rd = Mem[rs1 + imm] (16 bits, zero-extended)

# 8-bit loads
LB   rd, imm(rs1)     # rd = Mem[rs1 + imm] (8 bits, sign-extended)
LBU  rd, imm(rs1)     # rd = Mem[rs1 + imm] (8 bits, zero-extended)
```

#### Store Instructions (Tipo S)
```assembly
SD   rs2, imm(rs1)    # Mem[rs1 + imm] = rs2 (64 bits)
SW   rs2, imm(rs1)    # Mem[rs1 + imm] = rs2[31:0] (32 bits)
SH   rs2, imm(rs1)    # Mem[rs1 + imm] = rs2[15:0] (16 bits)
SB   rs2, imm(rs1)    # Mem[rs1 + imm] = rs2[7:0] (8 bits)
```

### 4.3 Instruções de Controle de Fluxo

#### Branches Condicionais (Tipo B)
```assembly
BEQ  rs1, rs2, label  # if (rs1 == rs2) goto label
BNE  rs1, rs2, label  # if (rs1 != rs2) goto label
BLT  rs1, rs2, label  # if (rs1 < rs2) goto label (signed)
BGE  rs1, rs2, label  # if (rs1 >= rs2) goto label (signed)
BLTU rs1, rs2, label  # if (rs1 < rs2) goto label (unsigned)
BGEU rs1, rs2, label  # if (rs1 >= rs2) goto label (unsigned)
```

#### Jumps (Tipo J e I)
```assembly
JAL  rd, label        # rd = PC + 4; PC = PC + offset (±1MB)
JALR rd, imm(rs1)     # rd = PC + 4; PC = rs1 + imm
```

### 4.4 Instruções de Constantes (Tipo U)
```assembly
LUI   rd, imm         # rd = imm << 12 (load upper immediate)
AUIPC rd, imm         # rd = PC + (imm << 12) (add upper imm to PC)
```

### 4.5 Instruções de Multiplicação e Divisão (Extensão M)
```assembly
# Multiplicação
MUL    rd, rs1, rs2   # rd = (rs1 * rs2)[63:0]
MULH   rd, rs1, rs2   # rd = (rs1 * rs2)[127:64] (signed × signed)
MULHU  rd, rs1, rs2   # rd = (rs1 * rs2)[127:64] (unsigned × unsigned)
MULHSU rd, rs1, rs2   # rd = (rs1 * rs2)[127:64] (signed × unsigned)

# Divisão
DIV    rd, rs1, rs2   # rd = rs1 / rs2 (signed)
DIVU   rd, rs1, rs2   # rd = rs1 / rs2 (unsigned)
REM    rd, rs1, rs2   # rd = rs1 % rs2 (signed remainder)
REMU   rd, rs1, rs2   # rd = rs1 % rs2 (unsigned remainder)
```

### 4.6 Pseudoinstruções Importantes
```assembly
# Movimento e constantes
MV    rd, rs1         # rd = rs1 (na verdade: ADDI rd, rs1, 0)
LI    rd, imm         # rd = imm (pode usar várias instruções)
LA    rd, label       # rd = &label (load address)

# Comparações
SEQ   rd, rs1, rs2    # rd = (rs1 == rs2) ? 1 : 0
SNE   rd, rs1, rs2    # rd = (rs1 != rs2) ? 1 : 0
SGT   rd, rs1, rs2    # rd = (rs1 > rs2) ? 1 : 0
SGE   rd, rs1, rs2    # rd = (rs1 >= rs2) ? 1 : 0

# Jumps
J     label           # goto label (na verdade: JAL x0, label)
JR    rs1             # goto rs1 (na verdade: JALR x0, 0(rs1))
RET                   # return (na verdade: JALR x0, 0(ra))

# Negação
NEG   rd, rs1         # rd = -rs1 (na verdade: SUB rd, x0, rs1)
NOT   rd, rs1         # rd = ~rs1 (na verdade: XORI rd, rs1, -1)

# Operações especiais
NOP                   # No operation (na verdade: ADDI x0, x0, 0)
```

---

## 5. Instruções de Ponto Flutuante (Extensão F/D)

### 5.1 Registradores de Ponto Flutuante
- **32 registradores FP**: `f0` até `f31` (64 bits cada)
- **Separados dos registradores inteiros**
- **FCSR**: Floating-point Control and Status Register

### 5.2 Load/Store de Ponto Flutuante
```assembly
# Single precision (32 bits)
FLW   ft1, imm(rs1)   # ft1 = Mem[rs1 + imm] (32 bits)
FSW   ft1, imm(rs1)   # Mem[rs1 + imm] = ft1[31:0]

# Double precision (64 bits)
FLD   ft1, imm(rs1)   # ft1 = Mem[rs1 + imm] (64 bits)
FSD   ft1, imm(rs1)   # Mem[rs1 + imm] = ft1
```

### 5.3 Operações Aritméticas de Ponto Flutuante
```assembly
# Single precision
FADD.S  fd, fs1, fs2  # fd = fs1 + fs2
FSUB.S  fd, fs1, fs2  # fd = fs1 - fs2
FMUL.S  fd, fs1, fs2  # fd = fs1 * fs2
FDIV.S  fd, fs1, fs2  # fd = fs1 / fs2
FSQRT.S fd, fs1       # fd = sqrt(fs1)

# Double precision
FADD.D  fd, fs1, fs2  # fd = fs1 + fs2
FSUB.D  fd, fs1, fs2  # fd = fs1 - fs2
FMUL.D  fd, fs1, fs2  # fd = fs1 * fs2
FDIV.D  fd, fs1, fs2  # fd = fs1 / fs2
FSQRT.D fd, fs1       # fd = sqrt(fs1)
```

### 5.4 Comparações de Ponto Flutuante
```assembly
# Single precision
FEQ.S   rd, fs1, fs2  # rd = (fs1 == fs2) ? 1 : 0
FLT.S   rd, fs1, fs2  # rd = (fs1 < fs2) ? 1 : 0
FLE.S   rd, fs1, fs2  # rd = (fs1 <= fs2) ? 1 : 0

# Double precision
FEQ.D   rd, fs1, fs2  # rd = (fs1 == fs2) ? 1 : 0
FLT.D   rd, fs1, fs2  # rd = (fs1 < fs2) ? 1 : 0
FLE.D   rd, fs1, fs2  # rd = (fs1 <= fs2) ? 1 : 0
```

### 5.5 Conversões de Ponto Flutuante
```assembly
# Conversões int ↔ float
FCVT.S.W  fd, rs1     # fd = (float) rs1 (int32 → float)
FCVT.S.WU fd, rs1     # fd = (float) rs1 (uint32 → float)
FCVT.S.L  fd, rs1     # fd = (float) rs1 (int64 → float)
FCVT.S.LU fd, rs1     # fd = (float) rs1 (uint64 → float)

FCVT.W.S  rd, fs1     # rd = (int32) fs1
FCVT.WU.S rd, fs1     # rd = (uint32) fs1
FCVT.L.S  rd, fs1     # rd = (int64) fs1
FCVT.LU.S rd, fs1     # rd = (uint64) fs1

# Conversões entre precisões
FCVT.D.S  fd, fs1     # double = single
FCVT.S.D  fd, fs1     # single = double
```

---

## 6. Representação Numérica

### 6.1 Sistemas de Numeração

#### Conversão Entre Bases
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

#### Método de Conversão
```
Decimal → Binário: Divisões sucessivas por 2
Binário → Decimal: Soma das potências de 2
Hex → Binário: 1 dígito hex = 4 bits
Octal → Binário: 1 dígito octal = 3 bits
```

### 6.2 Representação de Inteiros

#### Extensão de Sinal
```
4 bits → 8 bits:
0101 (+5) → 00000101 (+5)
1101 (-3) → 11111101 (-3)

Regra: Replica o bit de sinal (MSB)
```

#### Faixas de Representação
| Bits | Unsigned | Signed (Complemento de 2) |
|------|----------|---------------------------|
| 8 | 0 a 255 | -128 a +127 |
| 16 | 0 a 65.535 | -32.768 a +32.767 |
| 32 | 0 a 4.294.967.295 | -2.147.483.648 a +2.147.483.647 |
| 64 | 0 a 18.446.744.073.709.551.615 | -9.223.372.036.854.775.808 a +9.223.372.036.854.775.807 |

#### Métodos de Representação de Números Negativos

**1. Sinal-Magnitude**
- Bit mais significativo = sinal (0=+, 1=-)
- Problema: Dois zeros (+0 e -0)

**2. Complemento de 1**
- Inverte todos os bits
- Problema: Dois zeros, aritmética complicada

**3. Complemento de 2 (Padrão)**
- Para negar: Inverte todos os bits + 1
- Um único zero, aritmética simples

```
Exemplo (8 bits):
+5 = 00000101
~5 = 11111010  (complemento de 1)
-5 = 11111011  (complemento de 2 = ~5 + 1)
```

### 6.3 Overflow e Underflow

#### Detecção de Overflow em Soma (Complemento de 2)
```
Overflow ocorre quando:
- Positivo + Positivo = Negativo
- Negativo + Negativo = Positivo

Não há overflow quando:
- Positivo + Negativo (qualquer resultado)
```

#### Exemplos (4 bits)
```
  0111 (+7)     1000 (-8)
+ 0001 (+1)   + 1111 (-1)
------------ + ----------- 
  1000 (-8)     0111 (+7)
  OVERFLOW!     OVERFLOW!
```

---

## 7. Ponto Flutuante IEEE 754

### 7.1 Formato de Representação

#### Estrutura Geral: `S | Expoente | Mantissa`

| Precisão | Total | Sinal | Expoente | Mantissa | Bias |
|----------|-------|-------|----------|----------|------|
| **Half** | 16 | 1 | 5 | 10 | 15 |
| **Single** | 32 | 1 | 8 | 23 | 127 |
| **Double** | 64 | 1 | 11 | 52 | 1023 |
| **Quad** | 128 | 1 | 15 | 112 | 16383 |

### 7.2 Classificação de Números

| Tipo | Expoente | Mantissa | Valor | Exemplo |
|------|----------|----------|-------|---------|
| **Zero** | 00...0 | 00...0 | ±0 | +0.0, -0.0 |
| **Subnormal** | 00...0 | ≠0 | ±0.mantissa × 2^(1-bias) | Números muito pequenos |
| **Normal** | 00...01 a 11...10 | Qualquer | ±1.mantissa × 2^(exp-bias) | Números normais |
| **Infinito** | 11...1 | 00...0 | ±∞ | +∞, -∞ |
| **NaN** | 11...1 | ≠0 | Not a Number | SNAN, QNAN |

### 7.3 Casos Especiais

#### NaN (Not a Number)
- **SNAN (Signaling NaN)**: Gera exceção quando usado
- **QNAN (Quiet NaN)**: Não gera exceção, propaga

#### Operações que Geram NaN
```
0/0, ∞/∞, ∞-∞, 0×∞, sqrt(negativo), log(negativo)
```

#### Operações que Geram Infinito
```
1/0 = ±∞
overflow em operação = ±∞
```

### 7.4 Exemplo de Conversão (Single Precision)

**Converter -12.375 para IEEE 754:**

1. **Binário**: 12.375 = 1100.011₂
2. **Normalizar**: 1.100011 × 2³
3. **Sinal**: 1 (negativo)
4. **Expoente**: 3 + 127 = 130 = 10000010₂
5. **Mantissa**: 100011 (completar com zeros) = 10001100000000000000000₂

**Resultado**: `1 10000010 10001100000000000000000`
**Hex**: `C1460000`

### 7.5 Exceções de Ponto Flutuante

| Exceção | Causa | Resultado Padrão |
|---------|-------|------------------|
| **Invalid Operation** | 0/0, sqrt(-1) | NaN |
| **Division by Zero** | 1/0 | ±∞ |
| **Overflow** | Resultado muito grande | ±∞ |
| **Underflow** | Resultado muito pequeno | 0 ou subnormal |
| **Inexact** | Resultado arredondado | Valor arredondado |

---

## 8. Programação em Assembly RISC-V

### 8.1 Estrutura de Programa

```assembly
# Diretivas de dados
.data
    # Declaração de variáveis globais
    .align 3                    # Alinha em múltiplos de 8 bytes
    array:    .quad 1, 2, 3, 4, 5      # Array de 5 elementos (64-bit cada)
    string:   .string "Hello World\n"   # String terminada em null
    value:    .word 42                  # Valor de 32 bits
    pi:       .float 3.14159            # Ponto flutuante (32 bits)
    e:        .double 2.71828           # Ponto flutuante (64 bits)
    buffer:   .space 100               # Reserve 100 bytes zerados

# Seção de código
.text
.globl _start                   # Ponto de entrada global

_start:
    # Programa principal
    la t0, array               # Carrega endereço do array
    li t1, 5                   # Contador = 5
    
    # Chama função
    jal ra, process_array
    
    # Sai do programa
    li a7, 93                  # System call exit (Linux)
    li a0, 0                   # Código de saída
    ecall

# Função para processar array
process_array:
    # Salva registradores na pilha
    addi sp, sp, -16           # Aloca espaço na pilha
    sd s0, 8(sp)              # Salva s0
    sd s1, 0(sp)              # Salva s1
    
    # Código da função
    mv s0, t0                  # s0 = endereço do array
    mv s1, t1                  # s1 = tamanho
    
    # Processa elementos...
    
    # Restaura registradores
    ld s1, 0(sp)              # Restaura s1
    ld s0, 8(sp)              # Restaura s0
    addi sp, sp, 16           # Libera espaço da pilha
    
    # Retorna
    jr ra
```

### 8.2 Diretivas do Assembler

| Diretiva | Descrição | Exemplo |
|----------|-----------|---------|
| `.data` | Seção de dados | `.data` |
| `.text` | Seção de código | `.text` |
| `.globl` | Símbolo global | `.globl main` |
| `.align n` | Alinha em 2ⁿ bytes | `.align 3` (8 bytes) |
| `.word` | 32-bit integer | `.word 42` |
| `.quad` | 64-bit integer | `.quad 0x123456789ABCDEF` |
| `.byte` | 8-bit integer | `.byte 255` |
| `.half` | 16-bit integer | `.half 1000` |
| `.float` | 32-bit float | `.float 3.14` |
| `.double` | 64-bit float | `.double 2.71828` |
| `.string` | String com \0 | `.string "Hello"` |
| `.ascii` | String sem \0 | `.ascii "World"` |
| `.space n` | n bytes zerados | `.space 100` |
| `.equ` | Definir constante | `.equ SIZE, 10` |

### 8.3 System Calls (Linux RISC-V)

| Número | Nome | a0 | a1 | a2 | a3 | Retorno |
|---------|------|----|----|----|----|---------|
| 63 | read | fd | buffer | count | - | bytes lidos |
| 64 | write | fd | buffer | count | - | bytes escritos |
| 57 | close | fd | - | - | - | status |
| 56 | openat