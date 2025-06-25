#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define MAX_RESOURCES 5

int available_resources = MAX_RESOURCES;
pthread_mutex_t mtx;

int decrease_count(int count) {
    	pthread_mutex_lock(&mtx);
    	if (available_resources < count) {
        	pthread_mutex_unlock(&mtx);
        	return -1;
    	} else {
        	available_resources -= count;
        	printf("Got %d resources %d remaining\n", count, available_resources);
        	pthread_mutex_unlock(&mtx);
        	return 0;
    	}
}

int increase_count(int count) {
    	pthread_mutex_lock(&mtx);
    	available_resources += count;
    	printf("Released %d resources %d remaining\n", count, available_resources);
    	pthread_mutex_unlock(&mtx);
    	return 0;
}

void* routine(void* arg) {
    	int count = *(int*)arg;
    	if (decrease_count(count) == 0) {
    	    	increase_count(count);
    	} else {
    	    	printf("Not enough resources for %d\n", count);
    	}
    	return NULL;
}

int main() {
    	pthread_t threads[5];
    	int resources[5] = {2, 2, 1, 3, 2};
    	pthread_mutex_init(&mtx, NULL);
    	printf("MAX_RESOURCES=%d\n", MAX_RESOURCES);
    	for (int i = 0; i < 5; i++) {
        	pthread_create(&threads[i], NULL, routine, &resources[i]);
    	}
    	for (int i = 0; i < 5; i++) {
        	pthread_join(threads[i], NULL);
    	}
    	pthread_mutex_destroy(&mtx);
    	return 0;
}

