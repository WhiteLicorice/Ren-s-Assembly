#include <stdio.h>

#include "cdecl.h"

void PRE_CDECL fibonacci ( int ) POST_CDECL; /* prototype for assembly routine */

int main( void )
{
  int n;
  printf("This program prints out a certain number of fibonacci numbers up to 47.\n");
  printf("Enter a number: ");
  scanf("%d", &n);
  
  fibonacci(n);
  return 0;
}