// Problema 1: Cálculo de one-time pad (prob1.s)
 
#include <iostream>
#include <string>
#include <cstring>  

const char* green = "\033[1;32m";
const char* red = "\033[1;31m";
const char* yellow = "\033[1;33m";
const char* reset = "\033[0m";
const char* bold = "\033[1m";

void one_time_pad(const char* msg, const char* key, char* result, int length){
    for(int i = 0; i < length; i++){
        result[i] = (char)( (int)(msg[i]) ^ (int)(key[i]) );
    }
    result[length] = '\0';
}

void print_vec(const char* vec, int len, bool hex=false){
    for(int i=0; i<len; i++){
        if(hex) printf("%02X ", (unsigned char)vec[i]);
        else printf("%c", vec[i]);
    }
    printf("\n\n");
}
        
int main(){

    char msg[] = "essa mensagem vai sumir";
    char key[] = "chave aleatoria 123890";
    int length = strlen(msg);

    if( strlen(key) < length ){
        std::cerr << bold << red << "Erro: A chave deve ser maior ou igual que a mensagem." << reset << std::endl;
        return 1;
    };

    char msg_encrypted[50];
    char msg_uncrypted[50];

    one_time_pad(msg, key, msg_encrypted, length);
    one_time_pad(msg_encrypted, key, msg_uncrypted, length);

    std::cout << bold << green << "# Mensagem original:" << reset << std::endl;
    print_vec(msg, length);

    std::cout << bold << red << "# Mensagem encriptada:" << reset << std::endl;
    print_vec(msg_encrypted, length, true); // Hex = true makes the output in hexadecimal format

    std::cout << bold << yellow << "# Mensagem desencriptada:" << reset << std::endl;
    print_vec(msg_uncrypted, length);

    return 0;
}