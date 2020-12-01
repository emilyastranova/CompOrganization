#include <stdio.h>
#include <stdbool.h>
int main()
{
    srand(time(0)); 

    int vertical = rand() % 2; // if false then horizontal
    int x = 0; int y = 0;
    int battleship[] = {0,0,1,1,2,2,3,3};

    // Fill battleship array
    if(vertical)
    {
        printf("Direction is vertical\n");
        x = rand() % 10;
        y = rand() % 7;
        for(int i = 0; i < 8; i+=2)
            battleship[i] = x;
        for(int i = 1; i < 8; i+=2)
            battleship[i] = y + i / 2;
    }
    else
    {
        printf("Direction is horizontal\n");
        x = rand() % 7;
        y = rand() % 10;
        for(int i = 0; i < 8; i+=2)
            battleship[i] = x + i / 2;
        for(int i = 1; i < 8; i+=2)
            battleship[i] = y;
    }

    // Print out battleship coords (for development testing only)
    for(int i = 0; i < 8; i++)
        printf("%d, ", battleship[i]);

    // Get user guess (getGuess)
    int attemptX = 0;
    int attemptY = 0;
    printf("\nInput a coordinate to try and hit (x,y): ");
    scanf("%d, %d", &attemptX, &attemptY);

    // Check array to see if user input matches any coords (hitOrMissLoop)
    bool hit = false;
    for(int i = 0; i < 7; i+=2)
        if(battleship[i] == attemptX && battleship[i+1] == attemptY)
            hit = true;
    
    // Announce hit or miss
    if(hit)
        printf("You hit!");
    else
        printf("You missed!");

    return 0;
}