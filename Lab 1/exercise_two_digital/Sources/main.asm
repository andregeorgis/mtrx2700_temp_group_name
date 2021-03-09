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
Counter     DS.W 1
FiboRes     DS.W 1


; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                     ; enable interrupts
            
configure:  NOP ; should configure digital ports as input vs output before using

mainLoop:
            NOP ; no operation
            

Lookup:     NOP ; grab number, give back segment code

LookupAll:  NOP ; grab a string of numbers, give back a string of segment codes

DrawOne:    NOP ; grab one segment code and specific LED, draw on a specific LED

DrawFour:   NOP ; grab four segment codes, draw on each LED

CheckButton:NOP ; see if the button active or deactive

NumberLoop: NOP ; if button is pressed, this should keep showing all numbers on LED

Scroll:     NOP ; grab a string, call LookupAll, keep calling DrawFour until end of string


;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
