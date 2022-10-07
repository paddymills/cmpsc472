PROGRAM dptry2;

VAR
  chopstick: ARRAY [0..4] of SEMAPHORE;
  mutex : SEMAPHORE;
  j : INTEGER;
  print : SEMAPHORE;

PROCEDURE philosopher(i: integer);
BEGIN
repeat
  WAIT(mutex);
  WAIT(chopstick[i]);
  WAIT(chopstick[(i+1) mod 5]);
  SIGNAL(mutex);
   wait(print);
   writeln('philosopher ',i, ' is eating');
   signal(print);
  SIGNAL(chopstick[i]);
  SIGNAL(chopstick[(i+1) mod 5]);
   wait(print);
   writeln('philosopher ',i, ' is thinking');
   signal(print);
until FALSE
END;

BEGIN
  FOR j := 0 to 4 DO
  BEGIN
    INITIALSEM(chopstick[j],1);
  END;
  INITIALSEM(mutex,1);
  INITIALSEM(print,1);
  COBEGIN 
   philosopher(0);
   philosopher(1);
   philosopher(2);
   philosopher(3);
   philosopher(4);
  COEND;
END.
