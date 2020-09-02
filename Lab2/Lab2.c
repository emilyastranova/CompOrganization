#include <math.h>
#include <stdio.h>
#include <stdlib.h>

// Written by Tyler Harrison

int main(int argc, char *argv[])
{

    int binNum = atoi(argv[1]);
    int decNum = 0;
    //printf("Input binary number: ");
    //scanf("%d", &binNum);

    // Count how many digits
    int numDigits = 0; // Init numDigits for counting for power function
    int tempNum = binNum; // Don't modify original binary number
    while(tempNum)
    {
        int n = tempNum % 10;   //n will be the last digit in the loop (right to left reading)
        tempNum = tempNum /10; // Chop off the last digit
        decNum += (n * pow(2, numDigits)); // Do the actual calculation
        numDigits++; // Increment number of digits for power exponent
    }
    printf("Decimal number: ");
    printf("%d", decNum); // Output final answer
    printf("\n");
    return 0;
}