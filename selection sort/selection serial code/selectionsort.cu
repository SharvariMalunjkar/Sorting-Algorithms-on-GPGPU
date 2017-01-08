#include <stdio.h>
#include<stdlib.h>
#include<cutil_inline.h>

//#define N 100
int size;

unsigned int timer_CPU=0;

void ParseArguments(int, char**);
void swap(int *xp, int *yp)
{
    int temp = *xp;
    *xp = *yp;
    *yp = temp;
}
 
void selectionSort(int arr[], int n)
{
    int i, j, min_idx;
 
    // One by one move boundary of unsorted subarray
    for (i = 0; i < n-1; i++)
    {
        // Find the minimum element in unsorted array
        min_idx = i;
        for (j = i+1; j < n; j++)
          if (arr[j] < arr[min_idx])
            min_idx = j;
 
        // Swap the found minimum element with the first element
        swap(&arr[min_idx], &arr[i]);
    }
}
 
/* Function to print an array */
void printArray(int arr[], int size)
{
    int i;
    for (i=0; i < size; i++)
        printf("%d ", arr[i]);
    printf("\n");
}
 
// Driver program to test above functions
int main(int argc, char** argv)
{

     ParseArguments(argc,argv);
     int N =size;
     int values[N];
     printf("Sorting for N Numbers: %d\n",N);
     for (int x = 0; x < N; ++x) {
                        values[x] = rand() % 100;
                        //printf("%d ", values[x]);
                }
    // Initializing the timer to zero cycles
    cutilCheckError(cutCreateTimer(&timer_CPU));

   // int arr[] = {64, 25, 12, 22, 11};
    int n = sizeof(values)/sizeof(values[0]);
    // Start Timer

    cutilCheckError(cutStartTimer(timer_CPU));
    selectionSort(values, n);
   //Stop timer
    cutilCheckError(cutStopTimer(timer_CPU)); 

   // printf("Sorted array: \n");
   // printArray(values, n);
    printf("\nTesting results...\n");
                for (int x = 0; x < N - 1; x++) {
                        if (values[x] > values[x + 1]) {
                                printf("Sorting failed.\n");
                                break;
                        }
                        else
                                if (x == N - 2)
                                        printf("SORTING SUCCESSFUL\n");
                }

    // print timer
    printf("CPU execution timer %f(ms)\n",cutGetTimerValue(timer_CPU));
   // delete timer here
   cutilCheckError(cutDeleteTimer(timer_CPU)); 
    return 0;
}

void ParseArguments(int argc,char** argv)
{

   for(int i =0; i< argc;i++)
   {
      if (strcmp(argv[i],"--size")==0||strcmp(argv[i], "-size")==0){
         size = atoi (argv[i+1]);
         i = i+1;
       }
   }
}

