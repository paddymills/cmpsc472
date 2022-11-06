# Patrick 10/31
- baci semaphores cannot be negative, so I guess we will use counting integers and use the semaphores as a mutex for said integer


# Patrick 11/5 - Idea for how to implement the hayride (pseudo code)
```
for person in hayride_queue {
    if isMother() || isChild8 {
        if numChildren < 2 && numAdults == 0 {
            hayride.append(mother);
            hayride.append(child8);
        }
    }
    
    if isAdult() {
        if numAdults == 0 && numChildren < 3 {
            hayride.append(person)
        }
        
        else if numAdults < 2 && numChildren == 0  {
            hayride.append(person)
        }
    }

    else { //child
        if numAdults == 0 && numChildren < 3 {
            hayride.append(person)
        }

        else if numAdults == 1 && numChildren < 2 {
            hayride.append(person)
        }
    }

    if numAdults == 2 || numChildren == 3 || (numAdults == 1 && numChildren == 2) {
        // hayride combo found
        break
    }
}
```


#added a function that will loop through the procs and see if a given id is in the queueu waiting for a hayride


# Patrick - I think we need to handle when a full hayride is not picked, but a full hayride can be picked from a different set in the queue

sorry, did not mean to do so much of the ride, but I had the queue so ripped apart I felt bad leaving it for you to figure out.

try implementing the hayride from the fathers end.
you will want to call build_ride(str) where str is a string that receives the output of who is on the ride.
you will then need to access hayride_pids and loop through it to wake up the processes by calling revive(pid). note that a pid of 0 is not a pid. this is the case of 2 adults on a ride (the third pid will be 0 meaning no one.)
