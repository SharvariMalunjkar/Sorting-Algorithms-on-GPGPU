#include<stdio.h>
#include<stdlib.h>
#include <cutil_inline.h>
#include<cuda.h>
//#define N 1000

int size;

// input array vlaues 
unsigned int *h_In =0;
unsigned int *h_Out = 0;
unsigned int *d_In = 0;
unsigned int *d_Out=0;


unsigned int timer_GPU =0;

void ParseArguments(int, char**);
void Cleanup(void);
/// Write kernel code here....///

__global__ void Selection_Sort(unsigned int *data_in,unsigned int *data_out, int left, int right)
{

    unsigned int tid = threadIdx.x;
 
   // for (int i = left ; i <= right ; ++i)
    for(int i =tid; i< (tid+right);i++)
    {
        unsigned min_val = data_in[i];
        int min_idx = i;

        // Find the smallest value in the range [left, right].
        for (int j = i+1 ; j <= right ; ++j)
        {
            unsigned val_j = data_in[j];

            if (val_j < min_val)
            {
                min_idx = j;
                min_val = val_j;
            }
        }

        // Swap the values.
        if (i != min_idx)
        {
            data_out[min_idx] = data_in[i];
            data_out[i] = min_val;
        }
    }
}








// Host code here...//
int main(int argc, char **argv)
{

  ParseArguments(argc,argv);
  int N =size;
  printf("sorting for number of elements %d\n",N);
  // unsigned int *h_data =0;
  // unsigned int *d_data = 0;
   
   // Allocate Host Memory
   h_In =(unsigned int*) malloc(N*sizeof(unsigned int));
   h_Out =(unsigned int*) malloc(N*sizeof(unsigned int));
   // Random number array in host memory
   
   for (int x = 0; x < N; ++x) {
                        h_In[x] = rand() % 100;
                        //printf("%d ", values[x];
   }
   // Device Memory allocation
   cutilSafeCall(cudaMalloc((void **)&d_In, N * sizeof(unsigned int)));
   cutilSafeCall(cudaMalloc((void **)&d_Out, N * sizeof(unsigned int)));
   // Copy data to GPU from CPU
   cutilSafeCall(cudaMemcpy(d_In, h_In, N * sizeof(unsigned int), cudaMemcpyHostToDevice));

   // Initializing the timer to zero cycles
   cutilCheckError(cutCreateTimer(&timer_GPU));

   // Start the timer
   cutilCheckError(cutStartTimer(timer_GPU));

   // call Kernel
   int left =0;
   int right = N-1;
   Selection_Sort<<<N,N>>>(d_In,d_Out,left,right);


  // Stop the timer
   cutilCheckError(cutStopTimer(timer_GPU));

   //Copy results back to CPU
   cutilSafeCall(cudaMemcpy(d_Out, h_Out, N * sizeof(unsigned int), cudaMemcpyHostToDevice)); 

   // checking for correctness of results

   printf("\nTesting results...\n");
                for (int x = 0; x < N - 1; x++) {
                        if (h_Out[x] > h_Out[x + 1]) {
                                printf("Sorting failed.\n");
                                break;
                        }
                        else
                                if (x == N - 2)
                                        printf("SORTING SUCCESSFUL\n");
                }
     // print the timer
   printf("GPU execution time is %f(ms)\n",cutGetTimerValue(timer_GPU));


     Cleanup();
     return 0;
   

}
void Cleanup(void)
{
// Free device memory
if (d_In)
   cudaFree(d_In);
if(d_Out)
  cudaFree(d_Out);

// free host memory

if (h_In)
   free(h_In);
if (h_Out)
   free(h_Out);

cutilCheckError(cutDeleteTimer(timer_GPU));
cutilSafeCall(cudaThreadExit());
exit(0);
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





