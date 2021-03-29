;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000  ; absolute address to place my code/constant data

; variable/data section

            ORG RAMStart
output_string1   DS.B  112     ; allocate a string length at the adress output_string 1 for task 1
output_string2   DS.B  112     ; allocate a string length at the address output_string 2 for task 2
output_string3   DS.B  112     ; allocate a string length at the address output_string 3 for task 3
output_string4   DS.B  112     ; allocate a string length at the address output_string 4 for task 4

input_string    FCC  " thIS iS AlSO a VALID input. that WiLL LOOK DIFFERENT when applying these Functions. good LUCK" ; make a string in memory, and the length of this string should not exceed the bytes for the output_string
null            FCB   $00                 ; set a null terminator at the end of the input_string
space           FCC   " "                 ; define variable space with space 
full_stop       FCC   "."                 ; define variable full_stop with full stop

upper_limit_Z     FCB $5A     ; upper_limit for upper case, which is Z
lower_limit_A     FCB $41     ; lower_limit for upper case, which is A

upper_limit_z     FCB $7A     ; upper_limit for lower case, which is z
lower_limit_a     FCB $61     ; lower_limit for lower case, which is a

case_gap          FCB $20
previous_letter   DS.B  1     ; allocate memory for later use (storing the previous letter in this variable)




; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1         ; initialize the stack pointer

            CLI                     ; enable interrupts

;**************************************************************
;*                    Task 1 Block                            *
;**************************************************************

task1_init:
            LDX   #input_string       ; load the address of the start of the input_string to X
            LDY   #output_string1     ; load the address of the start of the output_string1 to Y
            

task1_loop:

            LDAB   1, x+              ; Load the value of the current letter in input_string to Accumulator B
            CMPB   null               ; If we reach the end of the string go to task 2
            BEQ    task2_init
            
            JSR    all_lower          ; Make each letter lowercase
            BRA    task1_loop

;**************************************************************
;*                    Task 2 block                            *
;**************************************************************
task2_init:
            
            LDX   #input_string       ; load the address of the start of the input_string to X
            LDY   #output_string2     ; load the address of the start of the output_string1 to Y      



task2_loop:
          
            LDAB   1, x+              ; Load the value of the current letter in input_string to Accumulator B
            CMPB   null               ; If we reach the end of the string go to task 3
            BEQ    task3_init
            
            JSR    all_cap            ; Make each letter uppercase
            BRA    task2_loop
            
;**************************************************************
;*                 Subroutine block 1                         *
;**************************************************************

; Make all letters uppercase
all_cap:
            test1:                                    ; Check if the ascii value is more than or the same as 'a'
                          CMPB   lower_limit_a
                          BHS    test2
            
                          JSR    skip_update
                          RTS
            
            test2:
                          CMPB   upper_limit_z        ; Check if the ascii value is less than or the same as 'z'
                          BLS    change_lower
            
                          BSR    skip_update
                          RTS
                          
            change_lower:                             ; If it is within range, make it uppercase
                          SUBB   case_gap
                          STAB   0,y
                          INY
                          RTS

; Make all letters lowercase            
all_lower:            
            
            check1:                                   ; Check if the ascii value is more than or the same as 'A'
                          CMPB   lower_limit_A
                          BHS    check2
     
                          JSR    skip_update
                          RTS           
            

            check2:                                   ; Check if the ascii value is less than or the same as 'Z'
            
                          CMPB   upper_limit_Z
                          BLS    change_upper
            
                          BSR    skip_update
                          RTS    
            
            change_upper:                             ; If it is within range, make it lowercase
                          ADDB   case_gap
                          STAB   0,y
                          INY
                          RTS              
                                                      ; If the letter is not within range, store the current letter
skip_update:
            
            STAB   0,y
            INY
            RTS    

;**************************************************************
;*                     Task 3 block                           *
;**************************************************************

task3_init:

            LDX   #input_string       ; load the address of the start of the input_string to X
            LDY   #output_string3     ; load the address of the start of the output_string1 to Y       
          
            STAB  previous_letter     ; Store the previous letter
            LDAA  previous_letter
      
task3_loop:       
            LDAB  1,x+                ; Load the value of the current letter in input_string to Accumulator B
            
            CMPA  null                ; If we are at the start of the string, capitalise
            BEQ   cap_x               
            
            CMPA  space               ; If the previous string was a space, capitalise
            BEQ   cap_x
            
            CMPB   null               ; If we reach the end of the string go to task 4
            BEQ    task4_init   

            JSR   lower_the_rest      ; Make the rest of the string lower
            BRA   task3_loop


;**************************************************************
;*             Subroutines for task 3 and 4                   *
;**************************************************************
 ; Makes letters lowercase
lower_the_rest:
            
            JSR   all_lower
            JSR   store_prev
            RTS

; Makes letters uppercase
cap_x:
            JSR   all_cap
            JSR   store_prev
            BRA   task3_loop

; Tracks the previous character
store_prev:
            STAB  previous_letter
            LDAA  previous_letter
            RTS            
            
;**************************************************************
;*                       Task 4 Block                         *
;**************************************************************            

task4_init

            LDX   #input_string       ; load the address of the start of the input_string to X
            LDY   #output_string4     ; load the address of the start of the output_string1 to Y
            STAB  previous_letter     ; Store the previous letter
            LDAA  previous_letter
            
            
task4_loop:       
            LDAB  1,x+                ; Load the value of the current letter in input_string to Accumulator B
            
            CMPA  null                ; If we are at the start of the string, capitalise
            BEQ   cap_x2
            
            CMPA  full_stop           ; If the previous character is a full stop, check for a space
            BEQ   space_check
      
continue_routine:
            CMPB   #$00               ; If we reach the end of the string, end the program
            BEQ    end_task
            
            JSR   lower_the_rest      ; Make the rest of the string lower
            BRA   task4_loop            

; Capitalise the current letter
cap_x2:
            JSR   all_cap
            JSR   store_prev
            BRA   task4_loop

; Check if the current letter is a space, if so capitalise the next letter, otherwise continue as normal
space_check:

            CMPB  space
            BEQ   cap_after_full_stop
            BRA   continue_routine

cap_after_full_stop:
            
            STAB  0,y
            INY  
            LDAB  1,x+
            BRA   cap_x2

; End the program
end_task:
            LDX   #input_string
            

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
