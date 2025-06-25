#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

int main(int argc, char** argv) {
	char *s = argv[1];
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
	}
	if(pid>0)
		wait(NULL);
	return 0;
}
