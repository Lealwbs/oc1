.data 
 
##### R1 START MODIFIQUE AQUI START ##### 
# 
# Este espaço é para você definir as suas constantes e vetores auxiliares. 
# 
 
mensagem1: .word 2, 3, 4                                      
mensagem2: .word 1, 5, 4, 7 
chave: .word 3, 5, 7, 9 
 
##### R1 END MODIFIQUE AQUI END ##### 
 
.text 
  add s0, zero, zero       # s0 armazenará o número de testes que passaram 
teste_1: 
  # Chama procedimento 
  la a0, mensagem1 
  la a1, chave 
  addi a2, zero, 3 
  jal onetime_pad 
   
  # Compara saída com a saída esperada 
  # 2 ^ 3 = 1 
  # 3 ^ 5 = 6 
  # 4 ^ 7 = 3 
  lw t1, 0(a0) 
  li t2, 1 
  bne t1, t2, teste_2 
 
  lw t1, 4(a0) 
  li t2, 6 
  bne t1, t2, teste_2 
 
  lw t1, 8(a0) 
  li t2, 3 
  bne t1, t2, teste_2 
  addi s0,s0,1 
 
teste_2: 
  # Chama procedimento 
  la a0, mensagem2 
  la a1, chave 
  addi a2, zero, 4 
  jal onetime_pad      
   
  # Compara saída com a saída esperada 
  # 1 ^ 3 = 2 
  # 5 ^ 5 = 0 
  # 4 ^ 7 = 3 
  # 7 ^ 9 = 14 
   
  lw t1, 0(a0) 
  li t2, 2 
  bne t1, t2, FIM 
 
  lw t1, 4(a0) 
  li t2, 0 
  bne t1, t2, FIM 
 
  lw t1, 8(a0) 
  li t2, 3 
  bne t1, t2, FIM 
   
  lw t1, 12(a0) 
  li t2, 14 
  bne t1, t2, FIM 
  addi s0,s0,1 
  j FIM 
 
##### R2 START MODIFIQUE AQUI START ##### 
onetime_pad: 
    #   a0 = endereço da mensagem 
    #   a1 = endereço da chave 
    #   a2 = tamanho da mensagem 
    # Realiza mensagem[i] = mensagem[i] XOR chave[i] 
jalr zero, 0(ra) 
 
##### R2 END MODIFIQUE AQUI END ##### 
 
FIM: