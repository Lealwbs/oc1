// Problema 1: Cálculo de one-time pad (prob1.s)
 
#include <iostream>
#include <string>
#include <cstring>  

void one_time_pad(const char* msg, const char* key, char* result, int length){
    for(int i = 0; i < length; i++){
        result[i] = (char)( (int)(msg[i]) ^ (int)(key[i]) );
    }
}

int main(){

    char msg[] = "ola mundo como vai voce";
    char key[] = "chavealeatoria1234567890";
    int length = strlen(msg);

    char msg_encrypted[100] = "";
    char msg_uncrypted[100] = "";

    std::cout << "Mensagem original:" << std::endl;
    std::cout << msg << std::endl << std::endl;
    
    one_time_pad(msg, key, msg_encrypted, length);
    std::cout << "Mensagem encriptada:" << std::endl;
    std::cout << msg_encrypted << std::endl << std::endl;

    one_time_pad(msg_encrypted, key, msg_uncrypted, length);
    std::cout << "Mensagem desencriptada:" << std::endl;
    std::cout << msg_uncrypted << std::endl << std::endl;

    return 0;
}