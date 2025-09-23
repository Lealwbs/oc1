// Problema 1: Cálculo de one-time pad (prob1.s)
 
#include <iostream>
#include <string>
#include <cstring>  

char* one_time_pad(const char msg[], const char key[], int length){
    char result[length] = "";
    for(int i = 0; i < length; i++){
        result[i] = msg[i] ^ key[i];
    }
    return result;
}

int main(){

    char msg[] = "ola mundo como vai voce";
    char key[] = "chavealeatoria1234567890";
    int length = strlen(msg);

    std::cout << "Mensagem original:" << std::endl;
    std::cout << msg << std::endl << std::endl;
    
    char msg_encrypted[] = one_time_pad(msg, key, length);
    std::cout << "Mensagem encriptada:" << std::endl;
    std::cout << msg_encrypted << std::endl << std::endl;

    char msg_uncrypted[] = one_time_pad(msg_encrypted, key, length);
    std::cout << "Mensagem desencriptada:" << std::endl;
    std::cout << msg_uncrypted << std::endl << std::endl;

    std::cout << "Hello, World!"[0] << std::endl;

    return 0;
}