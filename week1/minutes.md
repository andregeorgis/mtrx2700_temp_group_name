**Group Name:** temp_group_name

**Meeting on 02/03/2021, 14:00-17:00**

**Location:** Zoom

**Duration:** 3 hours

**Attendees:**

| Andre | Hilton | Jasmine | Zhengbo |
| ----- | ------ | ------- | ------- |

 

**Apologies:**

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


   BSR -- Branch to Subroutine
   BNE -- Branch if Not Equal - i.e. if Z = 0 (if zero bit in Code Condition Register is off)
   CLR -- Clear memory location (sets to 0)
   INC -- Increment Memory Byte