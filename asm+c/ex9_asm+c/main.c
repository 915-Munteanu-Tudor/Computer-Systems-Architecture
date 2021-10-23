#include <stdio.h>
#include <stdlib.h>


// declaration of the function that i used
int afish(int type, int nr_hexa);

int main()
{
    unsigned int i, nr_hexa=1, contor=0;
    int numbers[30];

    //reading the numbers from the input string
    while(nr_hexa != 0)
    {
        scanf("%x", &nr_hexa);
        if (nr_hexa != 0)
            {
                numbers[contor] = nr_hexa;
                contor++;
            }
    }

    printf("Signed: ");
    for(i=0; i<contor; i++)
        afish(1, numbers[i]);

    printf("\nUnsigned: ");
    for(i=0; i<contor; i++)
        afish(2, numbers[i]);

    return 0;
}
