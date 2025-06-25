#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>

int main(int argc, char** argv) {
	printf("Starting parent %d\n", getpid());
	char shm_name[] = "collatz_shm";
    	size_t shm_size = getpagesize();
	int shm_fd = shm_open(shm_name, O_CREAT|O_RDWR, S_IRUSR|S_IWUSR);
    	ftruncate(shm_fd, shm_size);
    	char *shm_ptr = mmap(0, shm_size, PROT_WRITE, MAP_SHARED, shm_fd, 0);
    	size_t offset = shm_size / (argc - 1);
    	for (int i = 1; i < argc; i++) {
        	pid_t pid = fork();
        	if (pid == 0) {
            		int x = atoi(argv[i]);
            		char result[100] = "";
            		char buffer[10];
            		while (x != 1) {
                		sprintf(buffer, "%d ", x);
                		strcat(result, buffer);
                		x = (x % 2 == 0) ? x / 2 : 3 * x + 1;
            		}
            		strcat(result, "1\n");
            		char *child_ptr = shm_ptr + (i - 1) * offset;
            		strncpy(child_ptr, result, offset);
            		printf("Done Parent %d Me %d\n", getppid(), getpid());
            		exit(0);
        	}
    	}
    	for (int i = 1; i < argc; i++) {
        	wait(NULL);
    	}
    	for (int i = 1; i < argc; i++) {
        	char *child_ptr = shm_ptr + (i - 1) * offset;
        	printf("%s: %s", argv[i], child_ptr);
    	}
    	munmap(shm_ptr, shm_size);
    	shm_unlink(shm_name);
    	printf("Done Parent %d Me %d\n", getppid(), getpid());
    	return 0;
}
