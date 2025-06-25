#include <unistd.h>
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

void* routine(void* arg) {\
	int arg_int = *((int*)arg);
	printf("Hello from thread %d\n", arg_int);
	//sleep(1);
	free(arg);
}

int main() {
	
	#define THREADS 5
	pthread_t threads[THREADS];
	for(int i = 0; i < THREADS; i++) {
		int* arg = malloc(sizeof(int));
		*arg = i;
		pthread_create(&threads[i], NULL, routine, arg);
	}
	for(int i = 0; i < THREADS; i++) {
		pthread_join(threads[i], NULL);
	}
	
	printf("All threads finished\n");
    	return 0;
}a
