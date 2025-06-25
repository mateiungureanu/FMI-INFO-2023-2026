#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define MAX 10

int matA[MAX][MAX] = {
    {1, 2, 3},
    {4, 5, 6}
};
int matB[MAX][MAX] = {
    {7, 8},
    {9, 10},
    {11, 12}
};
int result[MAX][MAX] = {0};
int rowsA = 2, colsA = 3;
int rowsB = 3, colsB = 2;

void *multiply_element(void *arg) {
    int *data = (int *)arg;
    int row = data[0];
    int col = data[1];
    int sum = 0;
    for (int i = 0; i < colsA; i++) {
        sum += matA[row][i] * matB[i][col];
    }
    result[row][col] = sum;
    free(arg);
}

int main() {
    pthread_t threads[MAX * MAX];
    int thread_count = 0;
    for (int i = 0; i < rowsA; i++) {
        for (int j = 0; j < colsB; j++) {
            int *data = malloc(2 * sizeof(int));
            data[0] = i;
            data[1] = j;
            pthread_create(&threads[thread_count], NULL, multiply_element, data);
            thread_count++;
        }
    }
    for (int i = 0; i < thread_count; i++) {
        pthread_join(threads[i], NULL);
    }
    for (int i = 0; i < rowsA; i++) {
        for (int j = 0; j < colsB; j++) {
            printf("%d ", result[i][j]);
        }
        printf("\n");
    }
    return 0;
}

