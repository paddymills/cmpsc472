Patrick Miller

# 1)
1) new
2) ready
3) running
4) waiting or blocked
5) ready
6) running
7) waiting or blocked
8) ready
9) running
10) terminated

- first `printf` is at steps 3-6
- second `printf` is at steps 6-9

# 2)
|time|P1|P2|P3|P4|
|---|---|---|---|---|
|12|blocked waiting|blocked waiting|ready,running|blocked waiting|
|23|ready,running,terminated|ready,running,terminated|blocked suspend|blocked waiting|
|27|ready,running,terminated|ready,running,terminated|ready suspend|blocked waiting|

# 3)
A = 2103, since `fork()` gives the parent the child's pid
B = 1179, since `getpid()` will return the parent's pid (executed within the parent's context)
C = 0, since `fork()` gives the child 0
D = 2103, since `getpid()` will return the child's pid (executed within the child's context)

<div style="page-break-after: always;"></div>

# 4)
TGIF is printed 9 times

```mermaid
flowchart TB
	start --> |printf| p0

	p0 -->|fork1| f1p0[p0]
	p0 -->|fork1| f1p1[p1]

	f1p0 -->|fork2| f2p00[p0]
	f1p0 -->|fork2| f2p01[p01]
	f1p1 -->|fork2| f2p10[p1]
	f1p1 -->|fork2| f2p11[p11]

	f2p00 -->|fork3| f3p000[p0] -->|printf| e[end]
	f2p00 -->|fork3| f3p001[p001] -->|printf| e
	f2p01 -->|fork3| f3p010[p01] -->|printf| e
	f2p01 -->|fork3| f3p011[p011] -->|printf| e
	f2p10 -->|fork3| f3p100[p1] -->|printf| e
	f2p10 -->|fork3| f3p101[p101] -->|printf| e
	f2p11 -->|fork3| f3p110[p11] -->|printf| e
	f2p11 -->|fork3| f3p111[p111] -->|printf| e
```

<div style="page-break-after: always;"></div>


# 5)
```mermaid
flowchart TB
	start -->|p0| f1{fork}
	
	f1 -->|p0| f3
	f1 -->|p1| f2
	
	f2 -->|p11| r[return]
	w1 -->|p1| r
	w2 -->|p0,p2| r
	
	f4 -->|p21| w2
	
	subgraph if
		direction TB
		f2{fork} -->|p1| w1
		
		subgraph ifif[if]
			w1{wait}
		end
	end

	subgraph else
		direction TB
		f3{fork} -->|p0| w2{wait}
		f3 -->|p2| f4
		f4 -->|p2| w2

		subgraph elseif[if]
			direction TB
			f4{fork}
		end
	end
```

a) the code produces 5 processes during execution
b) no zombie processes are created because all parent processes call `wait()`
c) since this is before any forks, this would replace the entire program with a call to `ls`, as such

```mermaid
flowchart TB
	start -->|p0| e1{exec} -->|p0| ls(ls output) -->|p0| r[return]
```
