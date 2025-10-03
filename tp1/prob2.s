.data 
 
##### R1 START MODIFIQUE AQUI START ##### 
# 
# Este espaço é para você definir as suas constantes e vetores auxiliares. 
# 
 
matriz_a: .word 1, 2, 3, 4 
matriz_b: .word 5, 6, 7, 8 
matriz_c: .word 0, 0, 0, 0 
 
##### R1 END MODIFIQUE AQUI END ##### 
 
.text 
  add s0, zero, zero       # s0 armazenará o número de testes que passaram 
teste_1: 
  # Chama procedimento 
  la a0, matriz_a 
  la a1, matriz_b 
  la a2, matriz_c 
  addi a3, zero, 2 
  jal mat_mult 
   
  # Compara saída com a saída esperada 
  # | 1  2 | X | 5  6 |  = | 19  22 | 
  # | 3  4 |   | 7  8 |    | 43  50 | 
  la a0, matriz_c 
  lw t1, 0(a0) 
  li t2, 19 
  bne t1, t2, teste_2 
 
  lw t1, 4(a0) 
  li t2, 22 
  bne t1, t2, teste_2 
 
  lw t1, 8(a0) 
  li t2, 43 
  bne t1, t2, teste_2 
   
  lw t1, 12(a0) 
  li t2, 50 
  bne t1, t2, teste_2 
  addi s0,s0,1 
   
teste_2: 
  # Chama procedimento 
  la a0, matriz_a 
  la a1, matriz_b 
  addi a2, zero, 2 
  jal dot_product 
   
  # Compara saída com a saída esperada 
  # (1, 2) * (5, 7) = 19 
  li t1, 19 
  bne a0, t1, FIM 
  addi s0,s0,1 
  j FIM 
 
##### R2 START MODIFIQUE AQUI START ##### 
 
mat_mult:
    # a0 = endereço da matriz A
    # a1 = endereço da matriz B
    # a2 = endereço da matriz C
    # a3 = tamanho das matrizes (n)
    # Realiza C = A * B
    
    # Salva registradores na pilha (convenção RISC-V)
    addi sp, sp, -28          # aloca espaço na pilha
    sw ra, 24(sp)             # salva endereço de retorno
    sw s0, 20(sp)             # salva s0 (linha i)
    sw s1, 16(sp)             # salva s1 (coluna j)
    sw s2, 12(sp)             # salva s2 (endereço matriz A)
    sw s3, 8(sp)              # salva s3 (endereço matriz B)
    sw s4, 4(sp)              # salva s4 (endereço matriz C)
    sw s5, 0(sp)              # salva s5 (tamanho n)
    
    # Guarda argumentos em registradores salvos
    mv s2, a0                 # s2 = endereço de A
    mv s3, a1                 # s3 = endereço de B
    mv s4, a2                 # s4 = endereço de C
    mv s5, a3                 # s5 = n
    
    # Inicializa i = 0 (linha)
    addi s0, zero, 0
    
loop_linha:
    beq s0, s5, fim_mat_mult  # se i == n, termina
    
    # Inicializa j = 0 (coluna)
    addi s1, zero, 0
    
loop_coluna:
    beq s1, s5, prox_linha    # se j == n, vai para próxima linha
    
    # Calcula endereço da linha i de A: A + i*n*4
    mul t0, s0, s5            # t0 = i * n
    slli t0, t0, 2            # t0 = i * n * 4
    add a0, s2, t0            # a0 = endereço da linha i de A
    
    # Calcula endereço da coluna j de B: B + j*4
    slli t1, s1, 2            # t1 = j * 4
    add a1, s3, t1            # a1 = endereço do primeiro elemento da coluna j
    
    # a2 = n (tamanho)
    mv a2, s5
    
    # Chama dot_product
    jal dot_product           # resultado retorna em a0
    
    # Calcula posição em C: C[i][j] = C + (i*n + j)*4
    mul t2, s0, s5            # t2 = i * n
    add t2, t2, s1            # t2 = i * n + j
    slli t2, t2, 2            # t2 = (i*n + j) * 4
    add t3, s4, t2            # t3 = endereço de C[i][j]
    
    # Armazena resultado
    sw a0, 0(t3)              # C[i][j] = resultado
    
    # Incrementa j
    addi s1, s1, 1
    j loop_coluna
    
prox_linha:
    # Incrementa i
    addi s0, s0, 1
    j loop_linha
    
fim_mat_mult:
    # Restaura registradores da pilha
    lw ra, 24(sp)
    lw s0, 20(sp)
    lw s1, 16(sp)
    lw s2, 12(sp)
    lw s3, 8(sp)
    lw s4, 4(sp)
    lw s5, 0(sp)
    addi sp, sp, 28           # libera espaço da pilha
    
    jalr zero, 0(ra)          # retorna
 
dot_product:
    # a0 = endereço base da linha da matriz A
    # a1 = endereço base da coluna da matriz B
    # a2 = tamanho das matrizes (n)
    # Retorna a0 = produto interno entre a linha de A e a coluna de B
    
    # Inicializa soma = 0
    addi t0, zero, 0          # t0 = soma = 0
    addi t1, zero, 0          # t1 = i = 0
    
    # Calcula stride da coluna: n * 4 bytes
    slli t6, a2, 2            # t6 = n * 4 (stride para pular linhas em B)
    
loop_dot:
    beq t1, a2, fim_dot       # se i == n, termina
    
    # Carrega A[i]
    slli t2, t1, 2            # t2 = i * 4
    add t3, a0, t2            # t3 = endereço de A[i]
    lw t4, 0(t3)              # t4 = A[i]
    
    # Carrega B[i] (elementos da coluna, pulando linhas)
    mul t2, t1, t6            # t2 = i * n * 4 (offset para coluna)
    add t3, a1, t2            # t3 = endereço de B[i]
    lw t5, 0(t3)              # t5 = B[i]
    
    # Multiplica e acumula
    mul t4, t4, t5            # t4 = A[i] * B[i]
    add t0, t0, t4            # soma += A[i] * B[i]
    
    # Incrementa i
    addi t1, t1, 1
    j loop_dot
    
fim_dot:
    # Retorna resultado em a0
    mv a0, t0
    jalr zero, 0(ra)
 
##### R2 END MODIFIQUE AQUI END ##### 
FIM: