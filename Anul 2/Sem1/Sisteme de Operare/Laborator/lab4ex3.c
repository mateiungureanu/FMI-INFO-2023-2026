#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

int main(int argc, char** argv) {
	printf("Starting parent %d\n", getpid());
	for(int i = 1; i < argc; i++){
		char *s = argv[i];
		int x = atoi(s);
		pid_t pid = fork();
		if(pid==0){
			printf("%d: ", x);
			while(x!=1){
				printf("%d ", x);
				if(x%2==0) x = x/2;
				else if(x%2==1) x = 3*x+1;
			}
			printf("%d\n", x);
			printf("Done Parent %d Me %d\n", getppid(), getpid());
			exit(0);
		}
	}
	for(int i = 1; i < argc; i++) 
		wait(NULL);
	printf("Done Parent %d Me %d\n", getppid(), getpid());
	return 0;
}
