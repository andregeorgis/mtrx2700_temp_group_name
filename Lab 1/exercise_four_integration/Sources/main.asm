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
; String and ASCII definitions
STRING_IN   DS.B  100
STRING_MOD  DS.B  100

upper_limit_Z     DS.B  1     ; upper_limit for upper case, which is Z
lower_limit_A     DS.B  1     ; lower_limit for upper case, which is A

upper_limit_z     DS.B  1     ; upper_limit for lower case, which is z
lower_limit_a     DS.B  1     ; lower_limit for lower case, which is a

previous_letter   DS.B  1     ; allocate memory for later use (storing the previous letter in this variable)

; Constants
ASCII_NL    EQU    10
ASCII_CR    EQU    13
ASCII_SP    EQU    32
BUTTON_ON   EQU    $FE   ; the button is on if this is the value read (input as $FE when Port H all switch on by pull up SW1, and the press button PH0/SW5 pressed down)


; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                     ; enable interrupts
            
mainLoop:    
                                          ; first, set all global variables
            
            LDAA  #$41
            STAA  lower_limit_A           
            
            LDAA  #$5A
            STAA  upper_limit_Z          
            
            
            LDAA  #$61
            STAA  lower_limit_a
            
            LDAA  #$7A
            STAA  upper_limit_z            
            
config:     LDAA  #$00
            STAA  DDRH           ; Configure PORTH as input

            LDD   #$9C           ; Config Serial
            STD   SCI1BD
            LDAA  #$00
            STAA  SCI1CR1
            LDAA  #$0C
            STAA  SCI1CR2
             
                        
configStrR: LDX   #STRING_IN     ; Keep reading until we get a carriage return

readLoop:   LDAA  SCI1SR1
            ANDA  #$20
            BEQ   readLoop
            LDAA  SCI1DRL
            STAA  0, X
            CMPA  #ASCII_CR      ; If we get a carriage return, modify string
            BEQ   modString
            INX
            BRA   readLoop
                        
configStrT: LDX   #STRING_MOD

transmLoop: LDAA  SCI1SR1
            ANDA  #$80
            BEQ   transmLoop
            LDAA  0, X
            STAA  SCI1DRL
            CMPA  #ASCII_CR
            BEQ   configStrR
            INX
            BRA   transmLoop            
            
modString:  LDX   #STRING_IN
            LDY   #STRING_MOD
            LDAA  #$00          ; Indicate start of string
            LDAB  PTH          ; Check if the button is on
            CMPB  #BUTTON_ON
            BEQ   capLoop      ; If so capitalise string, otherwise uppercase
            
            
upperLoop:
            LDAB  0, X
            INX
            JSR   all_cap
            CMPB  #ASCII_CR
            BEQ   configStrT     ; Once we finish modifying, transmit the modified string
            BRA   upperLoop
            
capLoop: ; In this routine, A is previous letter and B is current letter       
            LDAB  0, X
            INX
            
            CMPA  #$00           ; Capitalise start of string
            BEQ   cap_x
            
            CMPA  #ASCII_SP      ; Capitalise after space
            BEQ   cap_x
            
            JSR   lower_the_rest 
            
            CMPB  #ASCII_CR      ; Once we finish modifying, transmit the modified string
            BEQ   configStrT
            
            BRA   capLoop
            
; Subroutines:

all_cap:
            test1:
                          CMPB   lower_limit_a
                          BHS    test2
            
                          JSR    skip_update
                          RTS
            
            test2:
                          CMPB   upper_limit_z
                          BLE    changeLower
            
                          JSR    skip_update
                          RTS
            
            changeLower:
                          SUBB   #$20
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
                          BLE    changeUpper
            
                          JSR    skip_update
                          RTS    
            
            changeUpper:
                          ADDB   #$20
                          STAB   0,y
                          INY
                          RTS               

skip_update:
            
            STAB   0,y
            INY
            RTS
            
            
; subroutines for task 3 and 4

lower_the_rest:
            
            JSR   all_lower
            JSR   store_prev
            RTS


cap_x:
            JSR   all_cap
            JSR   store_prev
            BRA   capLoop

store_prev:
            STAB  previous_letter
            LDAA  previous_letter
            RTS             

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
