/*
#include <stdio.h>
int main ()
{
printf ("Hello, World!\n");
return 0;
}
*/

#include <unistd.h>
int main()
{
write (STDOUT_FILENO, "Hello, World!\n", 14);
return 0;
}

