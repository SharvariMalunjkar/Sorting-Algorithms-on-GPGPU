#include <stdio.h>
#include<stdlib.h>
#include<cutil_inline.h>
//#define N 1000

void ParseArguments(int,char**);
int size;

unsigned int timer_CPU =0;


/* Function to merge the two haves arr[l..m] and arr[m+1..r] of array arr[] */
void merge(int arr[], int l, int m, int r)
{
    int i, j, k;
    int n1 = m - l + 1;
    int n2 =  r - m;
 
    /* create temp arrays */
    int L[n1], R[n2];
 
    /* Copy data to temp arrays L[] and R[] */
    for(i = 0; i < n1; i++)
        L[i] = arr[l + i];
    for(j = 0; j < n2; j++)
        R[j] = arr[m + 1+ j];
 
    /* Merge the temp arrays back into arr[l..r]*/
    i = 0;
    j = 0;
    k = l;
    while (i < n1 && j < n2)
    {
        if (L[i] <= R[j])
        {
            arr[k] = L[i];
            i++;
        }
        else
        {
            arr[k] = R[j];
            j++;
        }
        k++;
    }
 
    /* Copy the remaining elements of L[], if there are any */
    while (i < n1)
    {
        arr[k] = L[i];
        i++;
        k++;
    }
 
    /* Copy the remaining elements of R[], if there are any */
    while (j < n2)
    {
        arr[k] = R[j];
        j++;
        k++;
    }
}
 
/* l is for left index and r is right index of the sub-array
  of arr to be sorted */
void mergeSort(int arr[], int l, int r)
{
    if (l < r)
    {
        int m = l+(r-l)/2; //Same as (l+r)/2, but avoids overflow for large l and h
        mergeSort(arr, l, m);
        mergeSort(arr, m+1, r);
        merge(arr, l, m, r);
    }
}
 
 
/* UITLITY FUNCTIONS */
/* Function to print an array */
void printArray(int A[], int size)
{
    int i;
    for (i=0; i < size; i++)
        printf("%d ", A[i]);
    printf("\n");
}
 
/* Driver program to test above functions */
int main(int argc, char** argv)
{

   ParseArguments(argc,argv);
   int N = size;
  //  int arr[] = {12, 11, 13, 5, 6, 7};
    int values[N];
     for (int x = 0; x < N; ++x) {
                        values[x] = rand() % 100;
                        //printf("%d ", values[x]);
                }
   
    int arr_size = sizeof(values)/sizeof(values[0]);
 
   // printf("Given array is \n");
   // printArray(arr, arr_size);
 
    // Intializing timer to zero cycles
   cutilCheckError(cutCreateTimer(&timer_CPU));

   //strat timer
   cutilCheckError(cutStartTimer(timer_CPU));

    mergeSort(values, 0, arr_size - 1);
 
   // stop timer
   cutilCheckError(cutStopTimer(timer_CPU));
   
    //printf("\nSorted array is \n");
    //printArray(arr, arr_size);

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
   printf("CPU Execution time %f (ms)\n",cutGetTimerValue(timer_CPU));

   // delete timer
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
