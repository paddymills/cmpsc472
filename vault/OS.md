# OS
## Key Elements
- OS
	- Service Call handler
		- Service call from process
	- Interupt handler
		- int from proc
		- int from I/O (hardware)
	- long term scheduler
		- queue of processes
	- short term scheduler
		- queue of processes
		- scheduler itself (dispatcher)
			- picks a process
			- passes control to process
			- pass control to a selected process

```mermaid
flowchart LR
	subgraph OS
		direction TB;
		sc["service call handler"];
		ih[interupt handler];
	end
	
	s["Service call from process"] --> sc;
	ip["interrup from process"] --> ih;
	iio["interrupt from I/O (h/w)"] -->ih;
```

## Modes
- user mode
	- task operating on behalf of user
- kernel mode (supervisor, protected, controlled)
	- access a special subset of instructions & special registers
	- has complete control of hardware

*user mode -> kernel mode via hardware interrupt or software trap/exception*

## Services
## System calls
- interface to services of the OS
- API (winapi, POSIX, etc.)
- Types
	- process control
	- file mgmt
	- dev mgmt
	- info maintenance
	- communication (i.e. shell pipe)

Windows | Unix
--- | ---
CreateProcess()|fork()
ExitProcess()|exit()
WaitForSingleObject()|wait()
CreateFile()|open()
...|...

## OS structure
1) Monolithic
2) Microkernel
3) Layered
	1) h/w
	2) kernel
	3) system call interface
	4) unix commands & libraries
```mermaid
flowchart TD
	subgraph unix commands & libraries
		subgraph syscall
			subgraph kernel
				hardware
			end
		end
	end
```

## Process management
- multiple processes running "concurrently"

#### Time flow
*dispatcher does not need state saved/restored (it has its own special registers)*
- A1-A4 running
- D1-D5 (dispatcher) (context switch)
	- save state
	- select process to run
	- restore new process's state
- B1-... running
```mermaid
sequenceDiagram
	participant cache
	participant running

	cache --> running: A is running
	running --> cache: Dispatcher save state of A
	cache --> running: Dispatcher select B and restore	
```

##### Process State
```mermaid
flowchart TD
	subgraph Simple
		direction LR;
		new --> nr[not running];
		nr -->|dispatch| r[running];
		r -->|?| nr;
		r --> terminated;
	end
```
? state (is it waiting on I/O? is it ready to run?)

```mermaid
flowchart TD
subgraph 5-state
		direction LR;
		new --> ready;

		ready -->|dispatch| running;
		running -->|timeout| ready;
		running -->|event wait IO| w[waiting or blocked];
		running -->|exit| terminated;
			
		w -->|event occurs| ready;
	end
```

suspending: additional state to swap waiting processes out of memory
```mermaid
flowchart TD
	subgraph 6-state
		direction LR;
		new -->|admit| ready;
	
		ready -->|dispatch| running;
		running -->|timeout| ready;
		running -->|event wait| w[waiting or blocked];
		running -->|exit| terminated;
			
		w -->|event occurs| ready;
		w -->|suspend| s[suspended];
		s -->|activate| ready;
	end
```

```mermaid

flowchart TD
	subgraph 7-state
		direction LR;
		new -->|admit| ready;
	
		ready -->|dispatch| running;
		running -->|timeout| ready;
		running -->|event wait| w[waiting/blocked];
		running -->|exit| terminated;
			
		w -->|event occurs| ready;
		w -->|suspend| bs[blocked suspend];
		bs --> w;

		rs[ready suspend] -->|activate| ready;
		ready -->|suspend| rs;
		bs -->|event occurs| rs;
	end
```

## Process Status Tables
1) Memory tables
2) I/O tables
3) File tables
4) Process tables

- Main table with each entry pointing to its appropriate status table
- each entry (process ID) in a status table points to a process image
- _Process Image_- complete physical manifestation of a process (in a stack)
	- code
	- data
	- stack
	- [[PCB]] - state of the process

example:
```
+------+
|prog N|
|prog 2|
|prog 1|
| sys  |
|  os  |
+------+
```
```mermaid
sequenceDiagram
	Prog1 ->> OS: system call
	OS --> Prog1: save Prog1 state
	OS ->> IO: start IO
	
```

### Unix Process Example
- unix syscalls in example
	- fork
	- wait
	- exit
	- exec

logical address space
```
0------+
| text |
| data |
| heap |
\ .... \
|stack |
max----+
```

```plantuml
object "logical address space" as l {
	text
	----
	data
	----
	heap
	----
	...
	----
	stack
}
```
#### fork
- constructs a new logical address space and context for child that are identical to the parent
	- clones data, heap, and stack segment
	- code segment: cloned or shared
	- registers are identical -> program counter is identical
- returns different values in the parent and the child
	- child gets a return value of 0
	- parent gets the childs PID as the return value

##### example
```c
#include <stdio.h> // printing
#include <unistd.h> // fork syscall
#Include <wait.h> // wait syscall

int main() {
	printf("Parent running\n");
	int pid = fork();

	if (pid != 0) {
		// parent: do parent stuff
		printf("Parent running after fork\n");
		wait(null); // wait until child is finished
		printf("Parent done\n");
	}

	else {
		// child: do child stuff
		printf("Child running\n");
		sleep(5);
		printf("Child done\n");
	}
}
```

#### WAIT
- `wait(int *status)` causes parent to wait on any **one** of its children
- `wait(NULL)` (no status)
#### Exit
- `exit(int rv)`: causes program to exit the main method, returning specified `rv`
#### exec
- `execl`
- `execv(prog, [*args])`
- `execvp`
- `[*args]` must end with `NULL` (`["ls", "-l", NULL]`)
- transforms the calling process into a new process
- program counter is set to the start of the new program
- {process, parent process} ID does not change

## Process Trees
```mermaid
flowchart
	a --> b
	a --> c
	a --> d
	b --> e
	b --> f
```

for assigments
```mermaid
flowchart LR
	subgraph code
		main --> child
	end

	subgraph repr
		p0 --> p1
	end

	code --> repr
```
### example
```c
int main() {
	printf("foo\n");
	fork();
	printf("bar\n");
	fork();
	printf("!!\n");
}
```

```mermaid
flowchart LR
subgraph process
	direction TB;
	p0 --> p1;
	p0 --> p2;
	p1 --> p1.1;
end

subgraph printf
	foo;
	bar;
	!!;
end

p0 --> foo;
p0 --> bar;
p1 --> bar;
p0 --> !!;
p1 --> !!;
p2 --> !!;
p1.1 --> !!;

```

```c
int main() {
	for (int i-1; i<4; i++) {
		printf("i is %d\n", i);
		fork();
	}
	
	return 0;
}
```

```mermaid
flowchart TB
	subgraph process
		direction TB
		p0 --> p1
		
		p0 --> p2
		p1 --> p1.1

		p0 --> p3
		p1 --> p1.2
		p2 --> p2.1
		p1.1 --> p1.1.1

		p0 --> p4
		p1 --> p1.3
		p2 --> p2.2
		p1.1 --> p1.1.2
		p2.1 --> p2.1.1
		p1.1.1 --> p1.1.1.1
	end
	
	subgraph printf
		0
		1
		2
		3
	end

p0 --> 0

p0 --> 1
p1 --> 1

p0 --> 2
p1 --> 2
p2 --> 2
p1.1 --> 2

p0 --> 3
p1 --> 3
p2 --> 3
p1.1 --> 3
p3 --> 3
p2.1 --> 3
p1.1.1 --> 3
```

```c
int main() {
	int child = fork();
	int c = 5;
	if (child == 0) {
		c = c + 5;
	}

	else {
		child = fork();
		c = c + 10;

		if (child != 0) {
			c = c + 5;
		}
	}
}
```

```plantuml
map p0 {
	child => --int1--, int2
	c => --5--, --15--, 20
}

map p1 {
	child => 0
	c => --5--, 10
}

map p2 {
	child => 0
	c => --5--, 15
}

p0 --> p1
p0 --> p2
```

#### Zombie process
- process that has terminated whose parent never calls `wait`
- child is only removed from process table by `wait` syscall

#### orphan process
- child whose parent has been terminated
- given to the init process
