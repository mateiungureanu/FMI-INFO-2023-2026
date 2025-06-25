#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>

int main() {
	pid_t pid = fork();
	if(pid > 0) {
		printf("My PID = %d, Child PID = %d\n", getppid(), getpid());
		wait(NULL);
		printf("Child %d finished\n", getpid());
	}
	else if (pid == 0) {
		char* argv[]= {"ls", NULL};
		execve("/usr/bin/ls", argv, NULL);
	}	
	return 0;
}
