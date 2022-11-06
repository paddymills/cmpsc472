# Concurrency

## Concurrency, Mutual Exclusion, Syncronization
Concurrent processing: overlap and interleave processes that run

Scenarios
```
p1() { x = x + 1 }
R1=x
R1=R1+1
x=R1

p2() { x = x - 1 }
R2=x
R2=R2-1
x=R2
```
1) No concurrency (processes run sequentially in some order)
	1) P1 -> P2
	2) P2 -> P1
2) Concurrency
	1) P1: R1 = 5
	2) P1: R1 = 6
	3) P2: R2 = 5
	4) P2: R2 = 4
	5) P2: X = 4
	6) P1: X = 6

### race condition
- Book says *outcome depends on the order in which processes run*
- Typically refer to something __undesireable result__
- must protect global/shared variables

### Mutual exclusion
*ensuring a given variable can only be accessed by one process at a time*
- control access to critical resources in critical section
- enforcing creates issues with deadlock & starvation

#### Requirements
- assume no process stays in the critical section indefinitely
- assume no crashes while a process is in the critical section
1) Mutual exclusion is enforced
2) Progress is made
3) Bounded waiting (anti-starvation): there exists a bound on the number of times other processes are allowed to enter the critical section after a process has made a request to enter its critical section, and before the request is granted
4) No assumptions are made about relative process speeds or interleavings
#### Hardware Solutions
1) Disable interupts
	- works, but is a dangerous idea
	- won't work in multiprocessing environment
2) Special instructions
	- built in hardware (uninterruptable)
	- example: [[#test-and-set]] instruction 

##### test-and-set

```c
bool testset(int i) {
	if (i == 0) {
		i = 1;
		return true;
	} else {
		return false;
	}
}
```

#### Software Solutions
*if mutex is no, don't bother checking progress and bounded wait*

##### Algorthm 1: turn message
- flag that denotes who's turn it is
- enter CS, and then change turn to next participant
```c
/* do something that leads to need for critical section */

// await CS
while (whos_turn != me);

/* <critical section> */
whos_turn = next()
```

1) Mutex: YES :check:
2) Progress: NO
3) Bounded Wait: YES

##### Algorithm 2:

```c
while (flag[other]);
flag[me] = true;
/* <critical section> */
flag[me] = false;
```

1) Mutex: NO (flag set after check -> both may enter)
2) Progress: YES
3) Bounded: NO

##### Algorithm 3 (modified alg2)

```c
flag[me] = true;
while (flag[other]);
/* <critical section> */
flag[me] = false;
```

1) Mutex: YES
2) Progress: NO (flag set before check -> both are blocked)
3) Bounded: YES

##### Algorithm 4
```c
flag[me] = true;
while (flag[other]) {
	flag[me] = false;
	delay(random);
	flag[me] = true;
}
/* <critical section> */
flag[me] = false;
```

1) Mutex: YES
2) Progress: NO (extremely slim chance, but still possible)
3) Bounded: NO

##### Dekkers Algorithm
```c
flag[me] = true;
while (flag[other]) {
	if (turn == other) {
		flag[me] = false;
		while (turn == other);
		flag[me] = true;
	}
}

/* <critical section> */
turn = other;
flag[me] = false;
```

##### Petersons Algorithm
```c
flag[me] = true;
turn = other;
while (flag[other] && turn == other);

/* <critical section> */
flag[me] = false;
```

## Semaphore
*OS-level busy signals introduced by Dijkstra(1964)*

1) `signal(s)` (v: up/inc)
2) `wait(s)` (p: down/dec)

### Classical defn
```c
void wait(s) {
	while (s<=0);
	s -= 1;
}

void signal(s) {
	s += 1;
}
```
- Atomic operations
- can be initialized

### Fixed defn
```rust
struct Semaphore {
	count: i32,
	queue: Vec<Process>
}

fn wait(s) {
	s.count -= 1;
	if (s.count < 0) {
		// put process in s.queue
		// block process
	}
}

fn signal(s) {
	s.count += 1;

	if (s.count <= 0) {
		// s.queue.pop() is random -> weak semaphore
		// s.queue.pop() is FIFO -> strong semaphore
		p = s.queue.pop();
	
		// place p in ready queue
	}
}
```
