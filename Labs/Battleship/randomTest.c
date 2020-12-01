#include <stdio.h>
int main()
{
    srand(time(0)); 
    int x = 0;
    x = rand() % 10;
    return x;
}