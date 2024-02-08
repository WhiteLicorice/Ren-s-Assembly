#include <stdio.h>

#include "cdecl.h"

void PRE_CDECL mult( int ) POST_CDECL; /* prototype for assembly routine */

int main( void )
{
  int n, product;

  printf("Input upto the table number starting from 1: ");
  scanf("%d", &n);
  printf("Multiplication table from 1 to %d \n", n);
  
  mult(n);
  return 0;
}