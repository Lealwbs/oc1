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
    #   a0 = endereço da matriz A 
    #   a1 = endereço da matriz B 
    #   a2 = endereço da matriz C 
    #   a3 = tamanho das matrizes (n) 
    # Realiza C = A * B 
 
    jalr zero, 0(ra) 
 
dot_product: 
    #   a0 = endereço base da linha da matriz A 
    #   a1 = endereço base da coluna da matriz B 
    #   a2 = tamanho das matrizes (n) 
    # Retorna a0 = produto interno entre a linha de A e a coluna de B 
     
    jalr zero, 0(ra) 
 
##### R2 END MODIFIQUE AQUI END ##### 
FIM: