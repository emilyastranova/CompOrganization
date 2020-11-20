#include <stdio.h>
#include <stdbool.h>

void moves(int n, bool leftMove)
{
    if(n == 0){
        return;
    }
    moves(n-1, !leftMove);
    // if(leftMove) {
    //     printf("%d", n);
    //     printf("%s", " left \n");
    // }
    // else{
    //     printf("%d", n);
    //     printf("%s", " right \n");
    // }
    moves(n-1, !leftMove);
}

int main()
{
    int n = 3;

    // printf("%s", "Enter number of game disks: ");
    // scanf("%d", &n);
    moves(n, true);
    // printf("%s", "done\n");

    return 0;
}