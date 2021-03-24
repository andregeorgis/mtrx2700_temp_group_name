# Lab 1

## Members and Roles

Hilton Nguyen - Exercise 1 Memory and Pointers

Jasmine Huang - Exercise 1 Memory and Pointers

Zhengbo Feng - Exercise 2 Digital Input/Output

Andre Georgis - Exercise 3 Serial Input/Output


## Exercise 1 Memory and Pointers

#### Code Functionality
The code is broken up into four task sections with two blocks of subroutines. 
The first task block changes the letters to lowercase. The code would check along each character in the input string. If the current character being checked is an uppercase letter, the code jump into a subroutine to change it into lowercase. Otherwise, the character would be printed onto the output string. The code would then check the next character in the string and the process repeats until the end of the string is reached.
The second task block changes the letters to uppercase. THe code would check along each character in the input string. The character would be printed onto the output string unless if the character being checked is lowercase which is changed to uppercase. THe code would usually branch through different condition branches which determine if the character needs to be transformed.
The third task block changes the first letter of each word to uppercase and rest lowercase. A word is defined as string of letters between two special characters, which is usually two spaces but it can have a full stop at the end. THe code would also store the value of the previous character. This is because it needs to recognise a space  character to determine if the the charcater needs to be capitalised. 
The fourth task block changes the first letter of each sentence to uppercase and the rest lowercase. A sentence is defined as a string of characters between first letter and a full stop for the first sentence and from full stop to full stop for other sentences.

#### Code Modularity
The main code is broken up into four sections in order of which is task is mean to be completed. Each of these sections would perform one task and the next task can't be performed until the current task is completed. So task two can only start if task one is completed, task three can only start if task two is completed and task four can only start once task three is finished. The subroutines are also set into two blocks depending on how many tasks require it, similar roles they perform and their relative location. In our case, the subroutine to transform letters into uppercase or lowercase would be used by all tasks at some point, but the storing the previous character would only be used by tasks 3 and 4.

#### Instructions
1. Memory has been allocated for the required output strings, as a result of transforming the input string and required variables that are either stored of constantly checking over throughout.
2. Global variables have been set values, which correspond their ASCII number. The code also goes into section 1.
3. Task 1 is performed. The 1st output string involves making sure that all of the letters are lowercase. If the end of the string is reached by the null character, this indicates that this task is complete and the code now goes into the next section.
4. Task 2 is performed. The 2nd output string involves making sure that all of the letters are uppercase. If the end of the string is reached by the null character, this indicates that this task is complete and the code now goes to the next task.
5. Task 3 is performed. The 3rd output string involves making sure that only the first letter of each word is uppercase with the rest being in lowercase. If the end of the string is reached by the null character, this indicates that this task is complete and the code now goes to the next task.
6. Task 4 is performed. The 2nd output string involves making sure that only the first letter of each sentence is uppercase and the rest are in lowercase. If the end of the string is reached by the null character, this indicates that this task is complete and the code would run the final steps before ending.

#### Testing Procedures
The testing process involves entering an input string that fits within the memory space determined by each string. A theoretical approach is used to determine what the output strings should look like as a result of the transforming the input string using the four functions. Breakpoints are set to indicate the beginning of each task and the code is simulated quickly, ensuring that the simulated output is the same as the theoretical output. Single steps would also be used to make sure that the code is functioning properly as planned. To ensure that the code is consistently working with different inputs and not reliant on the one input string, the code would be simulated with a different string input. The debugging should be done based on a function by task by task basis. So task one would be debugged until it is consistenty working for a variety of different outputs and this continues for the other tasks.

## Exercise 2 Digital Input/Output

#### Code Functionality


#### Code Modularity


#### Instructions


#### Testing Procedures

## Exercise 3 Serial Input/Output

#### Code Functionality


#### Code Modularity


#### Instructions


#### Testing Procedures
