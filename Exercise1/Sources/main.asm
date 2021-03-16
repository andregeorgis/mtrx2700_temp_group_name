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

input_string    FCC   "thIS is a string"  ; make a string in memory
null            FCB   0

upper_limit_Z     DS.B  1     ; upper_limit for lower case
lower_limit_A     DS.B  1     ; lower_limit for lower case

upper_limit_z     DS.B  1     ; upper_limit for lower case
lower_limit_a     DS.B  1     ; lower_limit for lower case




string_length   DS.B  1     ; one byte to store the string length




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
            
             
            LDAA  #$10            
            STAA  string_length         ; set string_length to 16
            
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
task3_init

            LDX   #input_string
            LDY   #output_string3            
          
      
            
            
            
; Begin Task 4
task4_init

            LDX   #input_string
            LDY   #output_string4  








;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
