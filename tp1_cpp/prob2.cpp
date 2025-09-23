// Problema 2: Multiplicação de matrizes (prob2.s)

#include <iostream>
#include <iomanip>

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

            // for(int k=0; k<size; k++){
            //     c[i*size + j] += a[i*size + k] * b[k*size + j];
            // }

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

    // int identity[size][size] = {
    //     {1, 0, 0, 0},
    //     {0, 1, 0, 0},
    //     {0, 0, 1, 0},
    //     {0, 0, 0, 1}};

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

    int c[size][size] = {};

    mat_mult(*a, *b, *c, size);
    
    std::cout << "Matrix A" << std::endl;
    print_matrix(*a, size);

    std::cout << std::endl << "Matrix B" << std::endl;
    print_matrix(*b, size);

    std::cout << std::endl << "Matrix C = AxB" << std::endl;
    print_matrix(*c, size);

    int exp[4][4] = {
    {5, 7, 14, 10},
    {9, 5,  8, 12},
    {7, 9,  9,  9},
    {5, 3, 12, 12}};

    std::cout << std::endl << "Matrix C expected" << std::endl;
    print_matrix(*exp, size);

    return 0;
}




