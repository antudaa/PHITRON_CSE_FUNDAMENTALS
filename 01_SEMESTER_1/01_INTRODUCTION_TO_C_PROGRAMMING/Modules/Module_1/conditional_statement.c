#include <stdio.h>

int main()

{

    int taka;
    scanf("%d", &taka);

    if (taka >= 1000)
    {
        printf("I can buy Biryani for whole family\n");
    }
    else if (taka >= 500)
    {
        printf("I can buy Biryani for half family\n");
    }
    else if (taka >= 200)
    {
        printf("I can buy Biryani for myself\n");
    }
    else
    {
        printf("I can't buy Biryani\n");
    }

    return 0;
}