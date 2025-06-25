#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

#define N 5

pthread_mutex_t mutex;
sem_t sem;
int count = N;

// ruleaza, dar nu e bine ca nu e egal responsabil
// (ultimul ii trezeste pe toti)
/*
void barrier_point() {
    	pthread_mutex_lock(&mutex);
    	count--;
    	if (count == 0) {
        	for (int i = 0; i < N - 1; i++) {
            		sem_post(&sem);
        	}
        	pthread_mutex_unlock(&mutex);
    	} else {
        	pthread_mutex_unlock(&mutex);
        	sem_wait(&sem);
    	}
}
*/

void barrier_point() {
    	pthread_mutex_lock(&mutex);
    	count--;
    	if (count == 0) {
        	sem_post(&sem);
        	pthread_mutex_unlock(&mutex);
    	} else {
        	pthread_mutex_unlock(&mutex);
        	sem_wait(&sem);
        	sem_post(&sem);
    	}
}

void* routine(void* arg) {
    	int* tid = (int*)arg;
    	printf("%d reached the barrier\n", *tid);
    	barrier_point();
    	printf("%d passed the barrier\n", *tid);
    	free(tid);
    	return NULL;
}

int main() {
    	pthread_t threads[N];
    	pthread_mutex_init(&mutex, NULL);
    	sem_init(&sem, 0, 0);
    	for (int i = 0; i < N; i++) {
        	int* tid = malloc(sizeof(int));
        	*tid = i;
        	pthread_create(&threads[i], NULL, routine, tid);
    	}
    	for (int i = 0; i < N; i++) {
        	pthread_join(threads[i], NULL);
    	}
    	pthread_mutex_destroy(&mutex);
    	sem_destroy(&sem);
    	return 0;
}

