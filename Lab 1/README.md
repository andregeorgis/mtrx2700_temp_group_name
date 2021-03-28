# Lab 1

# Documentation Overview

The exercises are divided into sections, of which each section has the following sub-sections:

- Usability
- Code Functionality
- Code Modularity
- Instructions
- Testing Procedures

For a user's perspective, only refer to the **Usability** sub-section. For a marker's perspective or for a more in-depth understanding of how each exercise works, refer to the other sub-sections too.



# Members and Roles

**Hilton Nguyen** - Exercise 1 Memory and Pointers + Documentation

**Jasmine Huang** - Exercise 1 Memory and Pointers + Exercise 3 Memory and Pointers

**Zhengbo Feng** - Exercise 2 Digital Input/Output

**Andre Georgis** - Exercise 2 Digital Input/Output + Exercise 3 Serial Input/Output + Integration + Documentation




# Exercise 1 Memory and Pointers

## Usability

Navigate to the `/exercise_one_strings/Sources/main.asm` file and modify the following lines of code (on line 26):

```assembly
output_string1   DS.B  16     ; allocate 16 bytes at the address output_string 1 for task 1
output_string2   DS.B  16     ; allocate 16 bytes at the address output_string 2 for task 2
output_string3   DS.B  16     ; allocate 16 bytes at the address output_string 3 for task 3
output_string4   DS.B  16     ; allocate 16 bytes at the address output_string 4 for task 4

input_string    FCC   "thIS i. a string"  ; make a string in memory, and the length of this string should not exceed the bytes for the output_string
null            FCB   0                   ; set a null terminator at the end of the input_string
```

To change the string being modified, define a new string for the `input_string` variable, and set the values of the first four variables to the length of the string.

Then run the code in the CodeWarrior simulation using the `/exercise_one_strings/exercise_one_strings.mcp` project file, and use the command `spc $1000` to view the output of the program in memory.

*The string reading does not need the length since we read until the `null` character, but the string writing does to allocate the right amount of memory.*



## Code Functionality

At its highest level the code uses constants to check whether a character is an alphabetic lowercase character, an alphabetic uppercase character or neither. Using these checks it then applies specific transformations to complete each task.

The first task block changes the letters to lowercase. The code would check along each character in the input string. If the current character being checked is an uppercase letter, the code jump into a subroutine to change it into lowercase. Otherwise, the the current character from the input string would be printed onto the output string. The code would then check the next character in the string and the process repeats until the end of the string is reached.

The second task block changes the letters to uppercase. This works similar to above, except checking if the character is initially lowercase.

The third task block changes the first letter of each word to uppercase and rest lowercase. A word is defined as string of letters between two special characters, which is usually a space. The code stores the value of the previous character in order to recognise a space  character. Condition branches would force the current character in the input string to go thorugh a process to make it an uppercase character if the previous character is either a space or null character. Otherwise, the code would jump into subroutines to change it into a lowercase. The code would then store the value of the current character into the previous character variable to allow the code to check the other characters.  

The fourth task block changes the first letter of each sentence to uppercase and the rest lowercase. A sentence is defined as a string of characters between first letter and a full stop for the first sentence and from full stop to full stop for other sentences. The previous character's value is stored and this would determine which set of branches the code would jump to. If the previous character is a full stop, the code would jump through to check if there is a space character which would then lead to an uppercase letter. Otherwise, the code would jump to subroutines to either turn the letter to lowercase or print out the current character.



## Code Modularity
The main code is broken up into four sections in order of which task is meant to be completed. Each of these sections would perform one task and the next task can't be performed until the current task is completed. So task two can only start if task one is completed, task three can only start if task two is completed and task four can only start once task three is finished. The subroutines are also set into two blocks depending on how many tasks require it, similar roles they perform and their relative location. In our case, the subroutine to transform letters into uppercase or lowercase would be used by all tasks at some point, but the storing the previous character would only be used by tasks 3 and 4.



## Instructions
1. Memory has been allocated for the required output strings, as a result of transforming the input string and required variables that are either stored of constantly checking over throughout.
2. Global variables have been set values, which correspond their ASCII number. The code also goes into section 1.
3. Task 1 is performed. The 1st output string involves making sure that all of the letters are lowercase. If the character being checked is an uppercase letter, turn it into a lowercase letter. Otherwise, print out the character. If the end of the string is reached by the null character, this indicates that this task is complete and the code now goes into the next section.
4. Task 2 is performed. The 2nd output string involves making sure that all of the letters are uppercase. If the character being checked is an lowercase letter, turn it into a uppercase letter. Otherwise, print out the character. If the end of the string is reached by the null character, this indicates that this task is complete and the code now goes to the next task.
5. Task 3 is performed. The 3rd output string involves making sure that only the first letter of each word is uppercase with the rest being in lowercase. If the previous character is either a null character from the last time or a space character and the current character being checked is a letter, the letter becomes an uppercase letter. Otherwise, the character is a lowercase letter unless it is a space character. If the end of the string is reached by the null character, this indicates that this task is complete and the code now goes to the next task.
6. Task 4 is performed. The 2nd output string involves making sure that only the first letter of each sentence is uppercase and the rest are in lowercase. If the previous character is either a null character from the last time or a full stop follwed by a space character and the current character being checked is a letter, the letter becomes an uppercase letter. Otherwise, the character is a lowercase letter unless it is a space character or a full stop. If the end of the string is reached by the null character, this indicates that this task is complete and the code would run the final steps before ending.



## Testing Procedures
The testing process involves entering an input string that fits within the memory space determined by each string. Breakpoints are set to indicate the beginning of each task and the code is simulated quickly, ensuring that the simulated output is the same as the theoretical output. Single steps would also be used to make sure that the code is functioning properly as planned. To ensure that the code is consistently working with different inputs and not reliant on the one input string, the code would be simulated with a different string input - especially including **special characters** like punctuation. The debugging should be done based on a function by task by task basis. So task one would be debugged until it is consistenty working for a variety of different outputs and this continues for the other tasks.



# Exercise 2 Digital Input/Output

## Usability

Navigate to the `/exercise_two_digital/Sources/main.asm` file and modify the following lines of code (on line 43):

```assembly
STRING      FCC  "012345678987654321012" ; string to display
```

To change the string being scrolled through, modify the string in this line of code.

Then run the code in the CodeWarrior simulation using the `/exercise_two_digital/exercise_two_digital.mcp` project file, which should show the 7-segment display scrolling through the provided string. By pressing the `PH0` button (when all the DP switches are on) another animation is played - the numbers 0-9 are looped through once only on the first segment.



## Code Functionality

The code begins by configuring the direction of ports used for digital input and output. The main loop of the program checks to see if the button is currently pressed - if so the numbers 0-9 are looped through, otherwise the defined string is scrolled through.

The scrolling works by keeping an index register pointed to a string, using the next four characters as the numbers to be displayed. Each iteration a lookup table is used to grab the segment codes to display each character, which is then stored in the correct port to display the number - each time only enabling the current segment. Small delays are used to give the LED enough time to turn on, and longer delays are used to ensure that each "4-length" sub-string is displayed for approximately one second before scrolling. When the end of the string is reached we re-load the index register with the start of the string and repeat. We also constantly check if the button is being pressed, and if so we leave early and start to loop through 0-9 instead.

The looping from 0-9 works in a very similar fashion, yet only displaying on the first-segment rather than all four.



## Code Modularity

The code is separated based on the certain roles each section does. One major section is defining the variables and memory allocation which the code would call upon throughout the simulation. This is further broken down grouping them according to the role. One defines each one of the four 7-seg LEDS. Another subsection represents codes representing characters 0-9 and A-F which would be displayed on each LED segment. We also define the initial counter values, the strings for scrolling and looping and special ascii values.

The scrolling and looping are modularised into their own functions. The lookup table and actual displaying is also modularised into their own subroutines. There is one large subroutine responsible for displaying all four segments which calls a smaller subroutine responsible for displaying a single segment. Small delay routines are dispersed throughout these calls.



## Instructions

Overall:

1. Define variables and configure ports
2. Constantly check if button has been pressed throughout steps 4-5, if so skip to step 6
3. Load the input string and start the counter
4. Draw the current 4 characters until the counter has reached 0
5. Increment to the next character and go to step 4 until we have reached the end, then go back to step 3
6. Load the loop string and start the counter
7. Draw each number one by one unilt we have reached the end, then go back to step 3

Drawing One Character:

1. Take the number and find the appropriate segment code in the lookup table
2. Load the segment code
3. Enable the current segment
4. Small delay to let segment turn on
5. Disable all segments
6. Repeat for the next number/segment



## Testing Procedures

The only effective testing would be to run the program and check to see if it is exhibiting appropriate behaviour. Make sure it is scrolling correctly and that the scroll time is appropriate. Check to see that pressing the button instantly stops scrolling and starts looping (and this is possible at any point in the scroll). Check to see that once looping has finished we begin to scroll from the beginning of the string again.




# Exercise 3 Serial Input/Output

## Usability

Open up a serial terminal connected to the `SCI1` interface of the board - locate this in your devices and use the correct communication port. Use the following settings:

- Baud Rate: 9600bps
- Data Bits: 8
- Stop Bits: 1
- Parity: none
- Flow control: none
- Transmitted text: Append CR

A suitable serial terminal for windows is [Termite](https://www.compuphase.com/software_termite.htm). 

Then run the code in the CodeWarrior simulation using the `/exercise_three_serial/exercise_three_serial.mcp` project file. Type any string into the serial terminal and send the string to initiate the exercise.



## Code Functionality

The code begins by configuring the serial interface along `SCI1`. We then have a reading loop which reads characters from the serial port until reaching a carriage return, storing each character in a string. When a carriage return is reached, the same string is sent back through the serial port, after which the program begins reading once more.



## Code Modularity

We seperate the configuration, reading and transmitting into three nice sections of code. The reading function recursively calls itself until reaching the carriage return where it calls the transmission function. The transmission function then recursively calls itself until reaching the carriage return too where it calls the reading function.



## Instructions

1. Configure the serial port with 9600 baud rate, transmission enabled and reading enabled
2. Load the beginning of dedicated memory to an index register
3. Read the first serial status register until the flag indicating a byte has been received is set
4. Store the byte received and increment the index register
5. Repeat steps 3-4 until the carriage return byte has been received and stored
6. Load the beginning of the stored string to an index register
7. Read the first serial status register until the flag indicating that there is nothing currently being transmitted is set
8. Transmit the current byte and increment the index register
9. Repeat steps 7-8 until the carriage return byte has been read and sent
10. Go to step 2



## Testing Procedures

Testing the program is done by running the simulation and attempting to send a range of input through the serial terminal. This can include varying the types of characters and messages sent, or varying the length of the messages sent. Currently the only aspect the program should not be able to handle is string lengths larger than 100 (including the carriage return). This could be fixed by increasing the memory allocated on line 26 in the file `/exercise_three_serial/Sources/main.asm` as seen below, or by integrating the use of the stack pointer as opposed to an index register.

```assembly
STRING_IN   DS.B  100
```




# Exercise 4 Integration

## Usability

Open up a serial terminal connected to the `SCI1` interface of the board - locate this in your devices and use the correct communication port. Use the following settings:

- Baud Rate: 9600bps
- Data Bits: 8
- Stop Bits: 1
- Parity: none
- Flow control: none
- Transmitted text: Append CR

A suitable serial terminal for windows is [Termite](https://www.compuphase.com/software_termite.htm). 

Then run the code in the CodeWarrior simulation using the `/exercise_four_integration/exercise_four_integration.mcp` project file. Type any string into the serial terminal and send the string to initiate the exercise. Attempt to both just send the string, and to send the string while pressing down the `PH0` button - ensuring all DP switches are on.



## Code Functionality

The code begins by configuring the serial interface along `SCI1`. We then have a reading loop which reads characters from the serial port until reaching a carriage return, storing each character in a string. When a carriage return is reached, we check to see if the `PH0` button has been pressed or not. If so, we modify the string by capitalising each word, otherwise we make all letters uppercase. Once this is done, we transmit characters to the serial port until reaching the carriage return, after which the program begins reading once more.



## Code Modularity

We seperate the code into separate blocks:

- Defining variables
- Configuring the digital ports and serial ports
- Reading from serial
- Transmitting to serial
- Checking if the button is on
- Making all letters uppercase
- Capitalising all words

We then branch between these seperate modules to achieve the intended behaviour.



## Instructions

Instructions are simplified since most is repeated from previous tasks

1. Define variables for ascii checks and configure the serial port
2. Read a string from serial until carriage return is read
3. Check to see if button `PH0` has been pressed, if so go to step 4, otherwise go to step 5
4. Capitalise the string read from serial then go to step 6
5. Make the string read from serial uppercase
6. Transmit the modified string to serial then go to step 2




## Testing Procedures

Testing the program is done by running the simulation and attempting to send a range of input through the serial terminal. This can include varying the types of characters and messages sent, or varying the length of the messages sent. This also includes sending messages both with the button pressed and not pressed. As discussed in Exercise 3, our only issue is having a fixed length for our string, as seen on line 26 of `/exercise_four_integration/Sources/main.asm` 

```assembly
STRING_IN   DS.B  100
STRING_MOD  DS.B  100
```

