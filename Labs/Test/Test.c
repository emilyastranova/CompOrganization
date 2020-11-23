#include<stdio.h>
int main(void)
{
    int x = 1;
    int *ptr = &x;
    *ptr += 1;
    //printf("%d", *ptr);
}