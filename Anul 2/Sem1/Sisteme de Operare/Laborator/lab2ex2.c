#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
int main(int argc, char** argv)
{
int f1 = open(argv[1], O_RDONLY);
int f2 = open(argv[2], O_CREAT | O_WRONLY);
char* buf[1024];
ssize_t bytes;
while((bytes = read(f1, buf, sizeof(buf)))>0)
	write(f2, buf, bytes);
close(f1);
close(f2);
return 0;
}
