#ifdef raw
#include <raw.h>
#else
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#endif
#include <math.h>
#include<cutil_inline.h>


void begin(void);
void init(void);
void print(void);
void sort(void);
void compare(int i, int j, int dir);
void bitonicMerge(int lo, int cnt, int dir);
void bitonicSort(int lo, int cnt, int dir);
void check(void);
unsigned int timer_CPU=0;

#define N 16777216     //please enter number as power of 2

/* Globals: */
//static int numiters = -1;


int main(int argc, char **argv)
{
/*  int option;

  while ((option = getopt(argc, argv, "i:")) != -1)
  {
    switch(option)
    {
    case 'i':
      numiters = atoi(optarg);
    }
  }*/

 // begin();
// intialize the timer to zero cycles
   cutilCheckError(cutCreateTimer(&timer_CPU));
    
    init();
// Strat the timer
   cutilCheckError(cutStartTimer(timer_CPU));
    sort();
// stop the timer
    cutilCheckError(cutStopTimer(timer_CPU));
// print the timer
    printf("CPU Execution time is %f (ms) for input size %d:",cutGetTimerValue(timer_CPU),N);
// Delete Timer

   cutilCheckError(cutDeleteTimer(timer_CPU));

//    print();
    check();
   /* printf("\nTesting results...\n");
                for (int x = 0; x < N - 1; x++) {
                        if (a[x] > a[x + 1]) {
                                printf("Sorting failed.\n");
                                break;
                        }
                        else
                                if (x == N - 2)
                                        printf("SORTING SUCCESSFUL\n");
                }*/

    // print timer
   // printf("CPU execution timer %f(ms)\n",cutGetTimerValue(timer_CPU));


  return 0;
}


int a[N];         // the array to be sorted
const int ASCENDING = 1;
const int DESCENDING = 0;


/** Initialize array "a" with data **/
void init() {
  int i;
  for (i = 0; i < N; i++) {
    a[i]=rand()/100;
  //  printf("Array to be sorted is %d\n",a[i]);
  }
}

/** Loop through array, printing out each element **/
void print() {
  int i;
  for (i = 0; i < N; i++) {
//#ifdef raw
  //  print_int(a[i]);
//#else
    printf("sorted array  is %d\n", a[i]);
//#endif
  }
}

/** A comparator is modelled by the procedure compare, where the
 * parameter dir indicates the sorting direction. If dir is ASCENDING
 * and a[i] > a[j] is true or dir is DESCENDING and a[i] > a[j] is
 * false then a[i] and a[j] are interchanged.
 **/
void compare(int i, int j, int dir)
{
  if (dir==(a[i]>a[j]))
    {
      int h=a[i];
      a[i]=a[j];
      a[j]=h;
    }
}

/** The procedure bitonicMerge recursively sorts a bitonic sequence in
 * ascending order, if dir = ASCENDING, and in descending order
 * otherwise. The sequence to be sorted starts at index position lo,
 * the number of elements is cnt.
 **/
void bitonicMerge(int lo, int cnt, int dir)
{
  if (cnt>1)
    {
      int k=cnt/2;
      int i;
      for (i=lo; i<lo+k; i++)
	compare(i, i+k, dir);
      bitonicMerge(lo, k, dir);
      bitonicMerge(lo+k, k, dir);
    }
}

/** Procedure bitonicSort first produces a bitonic sequence by
 * recursively sorting its two halves in opposite directions, and then
 * calls bitonicMerge.
 **/
void bitonicSort(int lo, int cnt, int dir)
{
  if (cnt>1)
    {
      int k=cnt/2;
      bitonicSort(lo, k, ASCENDING);
      bitonicSort(lo+k, k, DESCENDING);
      bitonicMerge(lo, cnt, dir);
    }
}

/** When called with parameters lo = 0, cnt = a.length() and dir =
 * ASCENDING, procedure bitonicSort sorts the whole array a.
 **/
void sort()
{
  bitonicSort(0, N, ASCENDING);
}


void check()
{
 printf("\nTesting results...\n");
                for (int x = 0; x < N - 1; x++) {
                        if (a[x] > a[x + 1]) {
                                printf("Sorting failed.\n");
                                break;
                        }
                        else
                                if (x == N - 2)
                                        printf("SORTING SUCCESSFUL\n");
                }



}



/*void ParseArguments(int argc,char** argv)
{

   for(int i =0; i< argc;i++)
   {
      if (strcmp(argv[i],"--size")==0||strcmp(argv[i], "-size")==0){
         size = atoi (argv[i+1]);
         i = i+1;
       }
   }
}*/





























