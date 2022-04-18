#include<stdio.h>
#define size 5
int main()
{
	int n = size;
    int flag = 1;
    if(flag==1)
    {
        // first n positive odd numbers
        int j = 0;
        for(int i = 1; j < n; i+=2,j+=1)
            printf("%d",i);

    }
	else
    {
        // first n positive even numbers
        int j = 0;
        for(int i = 2; j < n; i+=2,j+=1)
            printf("%d",i);
    }
}
