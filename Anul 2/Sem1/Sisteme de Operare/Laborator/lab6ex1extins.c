#include <unistd.h>
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>

void* routine(void* arg) {
    	char* input = (char*)arg;
    	int len = strlen(input);
    	char* rev = malloc(len + 1);
    	for (int i = 0; i < len; i++) {
    		rev[i] = input[len - i - 1];
    	}
    	rev[len] = '\0';
    	return rev;
}

int main(int argc, char **argv) {
    	pthread_t threads[argc - 1];
    	char* results[argc - 1];
    	for (int i = 1; i < argc; i++) {
        	pthread_create(&threads[i - 1], NULL, routine, argv[i]);
    	}
    	for (int i = 1; i < argc; i++) {
        	pthread_join(threads[i - 1], (void**)&results[i - 1]);
    	}
    	for (int i = 1; i < argc; i++) {
        	printf("%s\n", results[i - 1]);
        	free(results[i - 1]);
      	}
    return 0;
}
