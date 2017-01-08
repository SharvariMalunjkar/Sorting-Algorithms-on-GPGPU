#include<stdio.h>
# include<stdlib.h>
#include<cutil_inline.h>

//#define N 100

void ParseArguments(int, char**);

unsigned int timer_CPU =0;
int size;


int getMax(int arr[], int n)
{
    int mx = arr[0];
    for (int i = 1; i < n; i++)
        if (arr[i] > mx)
            mx = arr[i];
    return mx;
}
 
// A function to do counting sort of arr[] according to
// the digit represented by exp.
void countSort(int arr[], int n, int exp)
{
    int output[n]; // output array
    int i, count[10] = {0};
 
    // Store count of occurrences in count[]
    for (i = 0; i < n; i++)
        count[ (arr[i]/exp)%10 ]++;
 
    // Change count[i] so that count[i] now contains actual
    //  position of this digit in output[]
    for (i = 1; i < 10; i++)
        count[i] += count[i - 1];
 
    // Build the output array
    for (i = n - 1; i >= 0; i--)
    {
        output[count[ (arr[i]/exp)%10 ] - 1] = arr[i];
        count[ (arr[i]/exp)%10 ]--;
    }
 
    // Copy the output array to arr[], so that arr[] now
    // contains sorted numbers according to current digit
    for (i = 0; i < n; i++)
        arr[i] = output[i];
}
 
// The main function to that sorts arr[] of size n using 
// Radix Sort
void radixsort(int arr[], int n)
{
    // Find the maximum number to know number of digits
    int m = getMax(arr, n);
 
    // Do counting sort for every digit. Note that instead
    // of passing digit number, exp is passed. exp is 10^i
    // where i is current digit number
    for (int exp = 1; m/exp > 0; exp *= 10)
        countSort(arr, n, exp);
}
 
// A utility function to print an array
void print(int arr[], int n)
{
    for (int i = 0; i < n; i++)
        printf("Array is %d \n",arr[i]);
}
 
// Driver program to test above functions
int main(int argc, char** argv)
{
   ParseArguments(argc,argv);
   int N =size;
   printf("size is N:%d\n",N);
   // Initialize the timer to zero cycles
   cutilCheckError(cutCreateTimer(&timer_CPU));


    //int arr[] = {170, 45, 75, 90, 802, 24, 2, 66};
    int values[N];
     for (int x = 0; x < N; ++x) {
                        values[x] = rand() % 100;
                        //printf("%d ", values[x]);
                }
    int n = sizeof(values)/sizeof(values[0]);
   /* for (int i =0; i<n; i++){
    printf("given array is : %d\n",arr[i]);
    }*/

    // start the timer
    cutilCheckError(cutStartTimer(timer_CPU));
  
    radixsort(values, n);
    //print(arr, n);

    //stop timer
    cutilCheckError(cutStopTimer(timer_CPU));
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
    // print the timing
    printf("\n CPU timing is: %f(ms) for N (Number of elemenets getting sorted): %d\n",cutGetTimerValue(timer_CPU),N);

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
