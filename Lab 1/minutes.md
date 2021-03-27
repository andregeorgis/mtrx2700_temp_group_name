See the actual minutes document for time-stamp and history purposes: https://docs.google.com/document/d/11tVVRpa6-D32x74uQeaCCPebgMqqlY3TeMmid7Z1oNw/edit?usp=sharing

# Meeting Week 1 Tuesday Lab

**Group Name:** temp_group_name

**Meeting on 02/03/2021, 14:00-17:00**

**Location:** Zoom

**Duration:** 3 hours

**Attendees:**

| Andre | Hilton | Jasmine | Zhengbo |
| ----- | ------ | ------- | ------- |



Apologies:**

None

**Minutes**

1. Jasmine Read Through Hardware Document

	Specifies hardware descriptions including number of ports, voltage capabilities and hardware functions.

2. Hilton Read Through Brief Summary

	Condensed version of all the capabilities of the HCS6812 in regards to the instructions we can provide.

3. Andre and Zhengbo Read Through Detailed Summary

	A very well-explained and spaced-out document discussing all capabilities of the HCS6812 om regards to the instructions we can provide and the actual layout of the CPU in terms of memory, registers etc.

4. Got the Board and cable - able to supply power but unable to establish communication between the board and laptop.
5. Set up a basic project with the full chip simulation, that loads the accumulator A with decimal 50, then stores this at memory address $1500.

	LDAA -- Load Accumulator A

	STAA -- Store Accumulator A to Memory

	SPC -- Shows the memory region at given value

	FILL -- Fills a memory range with the given value

6. Set up a slightly more complex project with the full chip simulation that has an infinite loop. Every iteration we add one memory value to another - which keeps growing until it reaches 255, and then the next iteration it rolls back to 0 as expected. We did this via a single step debug and also a breakpoint method debug.

	ADDA -- Add without carry to A

	BRA -- Branch Always

7. Figured out that the board we were given was actually messed up and got a new board that we confirmed worked!

8. Did an even more complex project with the full chip simulation that intended to turn on an LED for one second then turn it off for one second and so on. We managed to set the delay to about 3-4 seconds due to some miscalculations and running out of time in the lab - we did so by repeating the exercise in part 6 but with nested for loops.

   If we increment a byte of memory starting at 0 until it reaches 0 again this takes 255 instructions. If we do this for two bytes of memory, incrementing one only once the other has reached 0, this takes 255 * 255 commands. Adding a third byte (a third nested loop) is 255 * 255 * 255 which brings us in the right order of magnitude (into the 24MGHz range).
	​	BSR -- Branch to Subroutine
	​	BNE -- Branch if Not Equal - i.e. if Z = 0 (if zero bit in Code Condition Register is off)
	​	CLR -- Clear memory location (sets to 0)
	​	INC -- Increment Memory Byte

#Meeting Week 2 Tuesday Lab

**Group Name:** temp_group_name

**Meeting on 09/03/2021, 14:00-17:00**

**Location:** Zoom

**Duration:** 3 hours

**Attendees:**

| Andre | Hilton | Jasmine | Zhengbo |
| ----- | ------ | ------- | ------- |

 

**Apologies:**

None

**Minutes**

1. Split up into groups to solve each exercise first. Hilton and Jasmine are on Exercise 1, Zhengbo is on Exercise 2 and Andre is on Exercise 3.
2. Updated the README for appropriate documentation.
3. Did a bit of research for how to approach each of the exercises summarised below: (see google doc attached above)

**Action Items** 

| Action                                          | Person to do    | Deadline |
| ----------------------------------------------- | --------------- | -------- |
| Start filling some subroutines for Exercise One | Hilton, Jasmine | Next Lab |
| Start filling some subroutines for Exercise Two | Andre, Zhengbo  | Next Lab |



#Meeting Week 3 Tuesday Lab

**Group Name:** temp_group_name

**Meeting on 16/03/2021, 14:00-17:00**

**Location:** Zoom

**Duration:** 3 hours

Attendees:

| Andre | Hilton | Jasmine | Zhengbo |
| ----- | ------ | ------- | ------- |

 

**Apologies:**

None

**Minutes**

1. Andre and Zhengbo got the lookup table working for Exercise Two (and saved important addresses to variables so it is generalised).
   1. Able to make LEDs brighter by adding a delay
   2. Saved the configurations for turning on specific LEDs
   3. Saved the hex codes for each number display
2. Jasmine and Hilton were able to implement lowercase and uppercase transformations in Exercise One.
   1. Can check if an ascii value is in a certain range
   2. Can “imitate” OR/AND logic with branching
   3. Can transform the domain of lowercase letters to uppercase and vise-versa

**Action Items** 

| Action                                                       | Person to do | Deadline |
| ------------------------------------------------------------ | ------------ | -------- |
| Try sort out button detection (should be its own subroutine) | Zhengbo      | Weekend  |
| Sort out displaying strings with the 7 segments - firstly with 4 characters then extended to any length (scroll). | Andre        | Weekend  |
| Sort out capitalisation methods; A method to detect a special character before the current letter x  [a null character $00 means the current x is the start of the sentence, a space means the current x is the start of the word, a full stop means the current x is the start of the sentence.] | Hilton       | Weekend  |
| Sort out generalising string length [Allow the user to give input string that has less than 6500 words]   [This is solved with buffer-overflow, pre-allocating memory chunk that are large enough to handle output within a certain length] Code description and user manual for Exercise 1 | Jasmine      | Weekend  |



#Meeting Week 4 Tuesday Lab

**Meeting on 23/03/2021, 14:00-17:00**

**Location:** Zoom

**Duration:** 3 hours

**Attendees:**

| Andre | Hilton | Jasmine | Zhengbo |
| ----- | ------ | ------- | ------- |

 

**Apologies:**

None

**Completed Over the Week**

| Action                                                | Person  |
| ----------------------------------------------------- | ------- |
| Figured out how the button works                      | Zhengbo |
| Got 7-segment string displaying and scrolling working | Andre   |
| Attempted to finish Exercise 1                        | Hilton  |
| Finished Exercise 1 and refactored the code           | Jasmine |

**Minutes**

1. Jasmine and Hilton ran through how Exercise 1 works
2. Andre and Zhengbo integrated to finish Exercise 2
3. Andre went through how Exercise 2 works
4. Jasmine found some code for Serial transmission but it was weird. We asked for help from Stewart but that didn’t end that well :stuck_out_tongue:

**Action Items** 

| Action                         | Person to do            | Deadline |
| ------------------------------ | ----------------------- | -------- |
| Start working on Task 3        | Zhengbo, Andre, Jasmine | Weekend  |
| Start working on documentation | Hilton                  | Weekend  |
| Start looking at integration   | (all)                   | Weekend  |



#Meeting Week 4 Saturday (before assignment due)

**Meeting on 27/03/2021, 12:00-13:00**

**Location:** Zoom

**Duration:** 1 hours

Attendees:

| Andre | Hilton |      | Zhengbo |
| ----- | ------ | ---- | ------- |

 

**Apologies:**

Jasmine

**Completed Over the Week**

| Action                              | Person |
| ----------------------------------- | ------ |
| Exercise 3 and the Integration Task | Andre  |
| Most of the Documentation           | Hilton |

**Minutes**

1. Went through how all the tasks work and how we would present them
2. Plan out the last things that need to be ironed out

**Presentation Plan:**

1. Jasmine and Hilton present the first task
2. Andre and Zhengbo present the second task
3. Jasmine and Andre present the third task
4. (all) present the integration task

**Left To do:**

1. Design Plan for the Integration Task
2. Documentation (for half)
3. Commenting Exercise 3 and 4 more nicely
4. Big comments for all Exercises
5. Move Exercise 1 into Lab 1
6. Move minutes into the Repo
7. Get rid of magic numbers in serial code

**Action Items** 

| Action                                                       | Person to do       | Deadline |
| ------------------------------------------------------------ | ------------------ | -------- |
| Commenting Exercise 3 and 4 more nicely + Big Comments       | Hilton and Zhengbo | Monday   |
| Move Exercise 1 into Lab 1 + Get rid of magic numbers in serial | Jasmine            | Monday   |
| Move minutes into the Repo                                   | Andre              | Monday   |
| Documentation                                                | Andre              | Monday   |
| Design Plan for the Integration Task                         | (all)              | Monday   |