#include<stdio.h>
int main(void)
{
    int x = 1;
    int *ptr = &x;
    printf("%d", *ptr);
}