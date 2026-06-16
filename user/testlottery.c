#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "kernel/pstat.h"
#include "user/user.h"

// Proportions: A=30, B=20, C=10 (ratio 3:2:1)
#define TICKETS_A 30
#define TICKETS_B 20
#define TICKETS_C 10

#define NSAMPLES  5
#define INTERVAL  200  // ticks between samples

int
main(void)
{
  int pids[3];
  int tickets[3] = {TICKETS_A, TICKETS_B, TICKETS_C};

  // Fork three children, each inheriting the ticket count set before fork.
  for(int i = 0; i < 3; i++){
    settickets(tickets[i]);
    pids[i] = fork();
    if(pids[i] == 0){
      // Child: busy-loop forever until killed by parent.
      volatile long x = 0;
      for(;;) x++;
    }
  }

  // Parent: reset to 1 ticket so it does not skew the lottery.
  settickets(1);

  struct pstat st;

  printf("sample\tpid_A\tticks_A\tpid_B\tticks_B\tpid_C\tticks_C\n");

  for(int s = 0; s < NSAMPLES; s++){
    pause(INTERVAL);
    getpinfo(&st);

    printf("%d", s + 1);
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < NPROC; j++){
        if(st.inuse[j] && st.pid[j] == pids[i]){
          printf("\t%d\t%d", st.pid[j], st.ticks[j]);
          break;
        }
      }
    }
    printf("\n");
  }

  // Kill and reap children.
  for(int i = 0; i < 3; i++)
    kill(pids[i]);
  for(int i = 0; i < 3; i++)
    wait(0);

  exit(0);
}
