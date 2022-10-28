   { Dining Philosophers Problem}
PROGRAM d_p;
CONST
   DoomsDay = FALSE;
MONITOR dining_philosophers;
CONST
   Eating   = 0;  { do-it-yourself enumerated type }
   Hungry   = 1;
   Thinking = 2;
VAR
   i     : INTEGER; {init loop variable}
   state : ARRAY [0..4] OF INTEGER; {Eating, Hungry, Thinking}
   self  : ARRAY [0..4] OF CONDITION; { one for each Philospher }
   { place for Hungry Ph to wait until chopsticks become available }
PROCEDURE test(k : INTEGER);
  { if k's left & right neighbors aren't Eating & k is Hungry }
  { then change k's state to Eating & signalc (in case k is waitc-ing)}
BEGIN
   IF (state[(k+4) MOD 5] <> Eating) AND  {left neighbor}
      (state[k] = Hungry)            AND
      (state[(k+1) MOD 5] <> Eating) THEN {right neighbor}
   BEGIN
      state[k] := eating;
      SIGNALC(self[k]); {tell k to eat if k is waitc-ing}
   END; {if}
END; {test}
PROCEDURE pickup(i: INTEGER);
BEGIN
   state[i] := Hungry;
   WRITELN('philosopher ',i,' hungry');
   test(i); { are my neighbors eating? }
   IF state[i] <> Eating THEN {waitc if they are}
      WAITC(self[i]);
   WRITELN('philosopher ',i,' eating');
END; {pickup}
PROCEDURE putdown(i : INTEGER);
BEGIN
   state[i] := Thinking;
   WRITELN('philosopher ',i,' thinking');
   test( (i+4) MOD 5); { give left neighbor chance to eat }
   test( (i+1) MOD 5); { give right neighbor chance to eat }
END;  {putdown}
BEGIN {monitor initialization}
   FOR i := 0 TO 4 DO state[i] := Thinking;
END;  {dining_philosopher monitor}

PROCEDURE philosopher(i : INTEGER);
BEGIN
   REPEAT
      pickup(i);  { pick up chopsticks }
         {eat}
      putdown(i); { put down chopsticks }
         {think}
   UNTIL DoomsDay;
END; {philosopher}
BEGIN
   COBEGIN
      philosopher(0); philosopher(1); philosopher(2);
      philosopher(3); philosopher(4);
   COEND;
END.
