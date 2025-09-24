// Problema 2: Multiplicação de matrizes (prob2.s)

#include <iostream>
#include <iomanip>

const char* green = "\033[1;32m";
const char* red = "\033[1;31m";
const char* yellow = "\033[1;33m";
const char* blue = "\033[1;34m";
const char* reset = "\033[0m";
const char* bold = "\033[1m";

void dot_product(int* row, int* col, int &result, int size, int i, int j){
    result = 0;
    for(int k=0; k<size; k++){
        result += row[i*size + k] * col[k*size + j];
    }
}

void mat_mult(int* a, int* b, int* c, int size){
    for(int i=0; i<size; i++){
        for(int j=0; j<size; j++){
            dot_product(a, b, c[i*size + j], size, i, j);
        }
    }
}

void print_matrix(int* matrix, int size){
    for(int i=0; i<size; i++){
        std::cout << "[ ";   
        for(int j=0; j<size; j++){
            std::cout << matrix[i*size + j];
            if(j != size-1) std::cout << std::setw(4);
        }
        std::cout << " ]" << std::endl;
    }
}

int main(){

    int size = 4;

    int a[4][4] = {
        {2, 0, 1, 3},
        {1, 4, 2, 0},
        {3, 1, 0, 2},
        {0, 2, 3, 1}};

    int b[4][4] = {
        {1, 3, 0, 2},
        {2, 0, 1, 1},
        {0, 1, 2, 3},
        {1, 0, 4, 1}};

    std::cout << bold << blue << "Matrix A" << reset << std::endl;
    print_matrix(*a, size);

    std::cout << bold << yellow << std::endl << "Matrix B" << reset << std::endl;
    print_matrix(*b, size);

    int c[size][size] = {};
    mat_mult(*a, *b, *c, size);

    std::cout << bold << green << std::endl << "Matrix C = A x B" << reset << std::endl;
    print_matrix(*c, size);

    int exp[4][4] = {
    {5, 7, 14, 10},
    {9, 5,  8, 12},
    {7, 9,  9,  9},
    {5, 3, 12, 12}};

    std::cout << std::endl << bold << red << "Matrix C expected" << reset << std::endl;
    print_matrix(*exp, size);

    return 0;
}




