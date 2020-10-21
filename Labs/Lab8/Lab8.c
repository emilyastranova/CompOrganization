#include<stdio.h>
int main(void)
{
    int x = 0;
    int y = 0;
    addLoop: 
        y += 2;
        if (y >= 100)
            goto end;
        x += y;
        goto addLoop;
    end: 
        return x;
}