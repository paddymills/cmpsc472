# Patrick 10/31
- baci semaphores cannot be negative, so I guess we will use counting integers and use the semaphores as a mutex for said integer


# Patrick 11/5 - Idea for how to implement the hayride (pseudo code)
```
for person in hayride_queue {
    if isAdult() {
        if isMother() {
            if numChildren < 2 && numAdults == 0 && child8IsInQueue() {
                hayride.append(mother);
                hayride.append(child8);
            }
        }

        else if numAdults == 0 && numChildren < 3 {
            hayride.append(person)
        }
        
        else if numAdults < 2 && numChildren == 0  {
            hayride.append(person)
        }
    }

    else { //child
        if isChild8() {
            if numChildren < 2 && numAdults == 0 && motherIsInQueue() {
                hayride.append(mother);
                hayride.append(child8);
            }
        }

        else if numAdults == 0 && numChildren < 3 {
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
