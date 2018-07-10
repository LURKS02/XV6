#include "types.h"
#include "user.h"

#define STDOUT 1


int main(int argc, char *argv[])
{

  int fd1, fd2;

  fd1 = atoi(argv[1]);
  fd2 = atoi(argv[2]);

//  fd1 = open(argv[1], 1);
//  fd2 = open(argv[2], 1);
  
  if (dup2(fd1, fd2) < 0) {
    printf(2, "dup2 failed\n");
    exit();
  }

  // your code to print the time in any format you like...

  printf(2, "dup2 is done\n");
  exit();
}


