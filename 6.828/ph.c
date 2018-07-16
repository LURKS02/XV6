#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <assert.h>
#include <pthread.h>
#include <sys/time.h>

#define SOL
#define NBUCKET 5
#define NKEYS 100000

pthread_mutex_t lock[NBUCKET]; //locks of each table bucket

struct entry {
  int key;
  int value;
  struct entry *next;
};
struct entry *table[NBUCKET];
int keys[NKEYS]; //int array
int nthread = 1;
volatile int done;


double
now()
{
 struct timeval tv;
 gettimeofday(&tv, 0);
 return tv.tv_sec + tv.tv_usec / 1000000.0;
}

static void
print(void)
{
  int i;
  struct entry *e;
  for (i = 0; i < NBUCKET; i++) {
    printf("%d: ", i);
    for (e = table[i]; e != 0; e = e->next) {
      printf("%d ", e->key);
    }
    printf("\n");
  }
}

static void 
insert(int key, int value, struct entry **p, struct entry *n)
{
  struct entry *e = malloc(sizeof(struct entry)); //we allocate struct entry 
  e->key = key;
  e->value = value;
  e->next = n; //initializing the allocated struct entry
  
  *p = e; // insert allocated struct entry at p
}

static 
void put(int key, int value)
{
  int i = key % NBUCKET;
  pthread_mutex_lock(&lock[i]); 
  insert(key, value, &table[i], table[i]); //multi threads insert given random numbers at table array
  pthread_mutex_unlock(&lock[i]);
}

static struct entry*
get(int key)
{
  struct entry *e = 0;
  for (e = table[key % NBUCKET]; e != 0; e = e->next) {
    if (e->key == key) break;
  }
  return e;
}

static void *
thread(void *xa) //each thread performs this function
{
  long n = (long) xa;
  int i;
  int b = NKEYS/nthread;
  int k = 0;
  double t1, t0;

  //  printf("b = %d\n", b);
  t0 = now(); 
  for (i = 0; i < b; i++) {
    // printf("%d: put %d\n", n, b*n+i);
    
    put(keys[b*n + i], n); //multi threads access the shared resource
  }
  t1 = now();
  printf("%ld: put time = %f\n", n, t1-t0);

  // Should use pthread_barrier, but MacOS doesn't support it ...
  __sync_fetch_and_add(&done, 1);
  while (done < nthread) ;

  t0 = now();
  for (i = 0; i < NKEYS; i++) {
    //pthread_mutex_lock(&lock[i]);
    struct entry *e = get(keys[i]); //get the entry 
    //pthread_mutex_unlock(&lock[i]);
    if (e == 0) k++;
  }
  t1 = now();
  printf("%ld: get time = %f\n", n, t1-t0);
  printf("%ld: %d keys missing\n", n, k);
  return NULL;
}

int
main(int argc, char *argv[])
{
  pthread_t *tha; 
  void *value;
  long i;
  double t1, t0;

  for (i = 0; i < NBUCKET; i++)
    pthread_mutex_init(&lock[i],NULL); //initialize the lock

  if (argc < 2) {
    fprintf(stderr, "%s: %s nthread\n", argv[0], argv[0]);
    exit(-1);
  }
  nthread = atoi(argv[1]); //get argument number
  tha = malloc(sizeof(pthread_t) * nthread);
  srandom(0);
  assert(NKEYS % nthread == 0);
  for (i = 0; i < NKEYS; i++) {
    keys[i] = random(); //give the random number
  }
  t0 = now(); //double value
  for(i = 0; i < nthread; i++) {
    assert(pthread_create(&tha[i], NULL, thread, (void *) i) == 0); //n threads are created and start "thread" function
  }
  for(i = 0; i < nthread; i++) {
    assert(pthread_join(tha[i], &value) == 0);
  }
  t1 = now();
  printf("completion time = %f\n", t1-t0);
}
