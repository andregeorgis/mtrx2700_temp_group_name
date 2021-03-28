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
output_string1   DS.B  16     ; allocate 16 bytes at the address output_string 1 for task 1
output_string2   DS.B  16     ; allocate 16 bytes at the address output_string 2 for task 2
output_string3   DS.B  16     ; allocate 16 bytes at the address output_string 3 for task 3
output_string4   DS.B  16     ; allocate 16 bytes at the address output_string 4 for task 4

input_string    FCC   "thIS i. .astring"  ; make a string in memory, and the length of this string should not exceed the bytes for the output_string
null            FCB   $00                 ; set a null terminator at the end of the input_string
space           FCC   " "                 ; define variable space with space 
full_stop       FCC   "."                 ; define variable full_stop with full stop

upper_limit_Z     FCB $5A     ; upper_limit for upper case, which is Z
lower_limit_A     FCB $41     ; lower_limit for upper case, which is A

upper_limit_z     FCB $7A     ; upper_limit for lower case, which is z
lower_limit_a     FCB $61     ; lower_limit for lower case, which is a

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
            LDX   #input_string           ; load the address of the start of the input_string to X
            LDY   #output_string1         ; load the address of the start of the output_string1 to Y
            

task1_loop:

            LDAB   1, x+              ; Load the value of the current letter in input_string to Accumulator B
            CMPB   null
            BEQ    task2_init
            
            JSR    all_lower
            BRA    task1_loop

;**************************************************************
;*                    Task 2 block                            *
;**************************************************************
task2_init:
            
            LDX   #input_string
            LDY   #output_string2           



task2_loop:
          
            LDAB   1, x+
            CMPB   null
            BEQ    task3_init
            
            JSR    all_cap
            BRA    task2_loop
            
;**************************************************************
;*                 Subroutine block 1                         *
;**************************************************************

all_cap:
            test1:
                          CMPB   lower_limit_a
                          BHS    test2
            
                          JSR    skip_update
                          RTS
            
            test2:
                          CMPB   upper_limit_z
                          BLE    change_lower
            
                          BSR    skip_update
            
            change_lower:
                          SUBB   space
                          STAB   0,y
                          INY
                          RTS
            
all_lower:            
            
            check1:
                          CMPB   lower_limit_A
                          BHS    check2
     
                          JSR    skip_update
                          RTS           
            

            check2:
            
                          CMPB   upper_limit_Z
                          BLE    change_upper
            
                          BSR    skip_update
                          RTS    
            
            change_upper:
                          ADDB   space
                          STAB   0,y
                          INY
                          RTS              

skip_update:
            
            STAB   0,y
            INY
            RTS    

;**************************************************************
;*                     Task 3 block                           *
;**************************************************************

task3_init:

            LDX   #input_string
            LDY   #output_string3            
          
            STAB  previous_letter     
            LDAA  previous_letter
      
task3_loop:       
            LDAB  1,x+
            
            CMPA  null
            BEQ   cap_x
            
            CMPA  space
            BEQ   cap_x
            
            CMPB   null
            BEQ    task4_init   

            JSR   lower_the_rest 
            BRA   task3_loop


;**************************************************************
;*             Subroutines for task 3 and 4                   *
;**************************************************************

lower_the_rest:
            
            JSR   all_lower
            JSR   store_prev
            RTS


cap_x:
            JSR   all_cap
            JSR   store_prev
            BRA   task3_loop

store_prev:
            STAB  previous_letter
            LDAA  previous_letter
            RTS            
            
;**************************************************************
;*                       Task 4 Block                         *
;**************************************************************            

task4_init

            LDX   #input_string
            LDY   #output_string4  
            STAB  previous_letter     
            LDAA  previous_letter
            
            
task4_loop:       
            LDAB  1,x+
            
            CMPA  null
            BEQ   cap_x2
            
            CMPA  full_stop
            BEQ   space_check
      
continue_routine:
            CMPB   #$00
            BEQ    end_task
            
            JSR   lower_the_rest
            BRA   task4_loop            

cap_x2:
            JSR   all_cap
            JSR   store_prev
            BRA   task4_loop

space_check:

            CMPB  space
            BEQ   cap_after_full_stop
            BRA   continue_routine

cap_after_full_stop:
            
            STAB  0,y
            INY  
            LDAB  1,x+
            BRA   cap_x2

end_task:
            LDX   #input_string
            

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
