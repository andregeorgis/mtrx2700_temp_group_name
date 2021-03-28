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
NL_A        FCB    10
CR_A        FCB    13

; Constants
ASCII_NL    EQU    10
ASCII_CR    EQU    13

BAUD_RATE   EQU    $9C
CR_1        EQU    $00
CR_2        EQU    $0C

STATUS_1    EQU    $20
STATUS_2    EQU    $80



; code section
            ORG   ROMStart



Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                   ; enable interrupts

config:     LDD   #BAUD_RATE            ; configure the serial port
            STD   SCI1BD
            LDAA  #CR_1
            STAA  SCI1CR1
            LDAA  #CR_2
            STAA  SCI1CR2
            

;**************************************************************
;*                   Reading Function                         *
;**************************************************************

configStrR: LDX   #STRING_IN   

readLoop:   LDAA  SCI1SR1
            ANDA  #STATUS_1
            BEQ   readLoop
            LDAA  SCI1DRL
            STAA  0, X
            CMPA  #ASCII_CR
            BEQ   configStrT
            INX
            BRA   readLoop
  
;**************************************************************
;*                 Transmission Function                      *
;**************************************************************  
            
configStrT: LDX   #STRING_IN

transmLoop: LDAA  SCI1SR1
            ANDA  #STATUS_2
            BEQ   transmLoop
            LDAA  0, X
            STAA  SCI1DRL
            CMPA  #ASCII_CR
            BEQ   configStrR
            INX
            BRA   transmLoop
              
           

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
