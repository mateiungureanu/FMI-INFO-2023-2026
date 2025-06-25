#include <unistd.h>
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>

void* routine(void* arg) {
	char* input = (char*)arg;
	char* rev = malloc(strlen(input) + 1);
	for (int i = 0; i < strlen(input); i++) {
		rev[i] = input[strlen(input) - i - 1];
	}
	rev[strlen(input)] = '\0';
	return rev;
}

int main(int argc, char **argv) {
	pthread_t thread;
	char* result;
	pthread_create(&thread, NULL, routine, argv[1]);
	pthread_join(thread, (void**)&result);
	printf("%s\n", result);
	free(result);
	return 0;
}


