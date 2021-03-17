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
; Insert here your data definition.
output_string1   DS.B  16     ; allocate 16 bytes at the address output_string
output_string2   DS.B  16
output_string3   DS.B  16
output_string4   DS.B  16

input_string    FCC   "thIS i. a string"  ; make a string in memory
null            FCB   0
space           FCC   " "
full_stop       FCC   "."

upper_limit_Z     DS.B  1     ; upper_limit for lower case
lower_limit_A     DS.B  1     ; lower_limit for lower case

upper_limit_z     DS.B  1     ; upper_limit for lower case
lower_limit_a     DS.B  1     ; lower_limit for lower case


test_count   DS.B  1     ; one byte to count




; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1         ; initialize the stack pointer

            CLI                     ; enable interrupts


mainLoop:    
                                       ; first set all global variables
            
            LDAA  #$41
            STAA  lower_limit_A           ; set lower_limit for lower case to $61
            
            LDAA  #$5A
            STAA  upper_limit_Z           ; set upper_limit for lower case to $7A
            
            
            LDAA  #$61
            STAA  lower_limit_a
            
            LDAA  #$7A
            STAA  upper_limit_z
            
            LDAA  #0
            STAA  test_count
            
            
            LDX   #input_string
            LDY   #output_string1
            


; Begin Task 1

check1:

            LDAB   1, x+              ; Load the value of the current letter in input_string to Accumulator B
            CMPB   #$00
            BEQ    task2_init
            
            
            
            CMPB   lower_limit_A
            BHS    check2


skipUpdate: 
            
            STAB   0,y
            INY
            BRA    check1       
            

check2:
            
            CMPB   upper_limit_Z
            BLE    changeUpper
            
            BRA    skipUpdate
            
changeUpper:
            ADDB   #$20
            STAB   0,y
            INY
            BRA    check1  
            
                        


; Begin Task 2
task2_init:
            
            LDX   #input_string
            LDY   #output_string2
            

test1:
          
            LDAB   1, x+
            CMPB   #$00
            BEQ    task3_init
            
            CMPB   lower_limit_a
            BHS    test2
            
skipUpdate2: 
           
            STAB   0,y
            INY
            BRA    test1
            
test2:
            CMPB   upper_limit_z
            BLE    changeLower
            
            BRA    skipUpdate2
            
changeLower:
            SUBB   #$20
            STAB   0,y
            INY
            BRA    test1
            


; Begin Task 3
task3_init:

            LDX   #input_string
            LDY   #output_string3            
          
            STAB  $1056     ; transfer what's in Accumulator B to Accumulator A via a random location $1056
            LDAA  $1056
      
testA:       
            LDAB  1,x+
            
            CMPA  null
            BEQ   cap_x
            
            CMPA  space
            BEQ   cap_x
            
            CMPB   #$00
            BEQ    task4_init
            
always_lower:
            CMPB   lower_limit_A
            BHS    c2


skip1: 
            
            STAB   0,y
            INY
            STAB  $1056
            LDAA  $1056
            BRA    testA       
            

c2:
            
            CMPB   upper_limit_Z
            BLE    changeUp
            
            BRA    skip1
            
changeUp:
            ADDB   #$20
            STAB   0,y
            INY
            STAB  $1056
            LDAA  $1056
            BRA    testA

cap_x:
            CMPB  lower_limit_a
            BHS   t2
            
skip:
            STAB  0,y
            INY
            STAB  $1056
            LDAA  $1056
            BRA   testA


t2:
            CMPB  upper_limit_z
            BLE   changeLow
            
            BRA   skip
            
changeLow:
            SUBB  #$20
            STAB  0,y
            INY
            STAB  $1056
            LDAA  $1056
            BRA   testA
            
            
            
; Begin Task 4
task4_init

            LDX   #input_string
            LDY   #output_string4  
            STAB  $1056     ; transfer what's in Accumulator B to Accumulator A via a random location $1056
            LDAA  $1056
            
            
testB:       
            LDAB  1,x+
            
            CMPA  null
            BEQ   cap_x2
            
            CMPA  full_stop
            BEQ   space_check
      
continue_routine:
            
            CMPB   #$00
            BEQ    end_task
            
always_l:
            
            CMPB   lower_limit_A
            BHS    c3


skip2: 
            
            STAB   0,y
            INY
            STAB  $1056
            LDAA  $1056
            BRA   testB      
            

c3:
            
            CMPB   upper_limit_Z
            BLE    changeUp2
            
            BRA    skip2
            
changeUp2:
            ADDB   #$20
            STAB   0,y
            INY
            STAB  $1056
            LDAA  $1056
            BRA    testB

cap_x2:
            
            CMPB  lower_limit_a
            BHS   t3
            
skip3:
            STAB  0,y
            INY
            STAB  $1056
            LDAA  $1056
            BRA   testB


t3:
            CMPB  upper_limit_z
            BLE   changeLower2
            
            BRA   skip3
            
changeLower2:
            SUBB  #$20
            STAB  0,y
            INY
            STAB  $1056
            LDAA  $1056
            BRA   testB


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
            LDY   #output_string3  


;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
