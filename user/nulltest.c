#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

// Validates the null-pointer protection: dereferencing address 0x0 must
// cause the kernel to kill this process. The "FAIL" line below must never
// be printed if the protection is working.

int
main(int argc, char *argv[])
{
  int *p = 0;

  printf("nulltest: about to dereference null pointer (0x0)...\n");

  int val = *p;            // should fault here -> process killed by kernel

  printf("nulltest: FAIL - read succeeded, got %d (null page is mapped!)\n", val);
  exit(0);
}
