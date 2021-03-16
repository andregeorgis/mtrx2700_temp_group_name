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

; Define enables for the 7 segments
NO_SEG      EQU  $FF   ; value to enable no segments
FIRST_SEG   EQU  $FE   ; value to enable the first segment
SECOND_SEG  EQU  $FD   ; value to enable the second segment
THIRD_SEG   EQU  $FB   ; value to enable the third segment
FOURTH_SEG  EQU  $F7   ; value to enable the fourth segment
CURR_SEG    FCB  $0  ; current segment to draw to

; Define the lookup codes for every special character
SEG_CODES   FCB $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F, $77, $7C, $39, $5E, $79, $71
CURR_NUM    FCB  $0  ; current number to draw
CURR_CODE   FCB  $0  ; current seg code for the number to draw


; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                     ; enable interrupts
            
; Configure the direction of ports
configure:  LDAA    #$FF
            STAA    DDRB         ; Configure PORTB as output
            STAA    DDRP         ; Port P as output to enable 7 segments
            LDX     #SEG_CODES   ; Store the Segment Codes
            
mainLoop:          
            LDAB    #2
            STAB    CURR_NUM
            BSR     Lookup
            LDAB    #SECOND_SEG
            STAB    CURR_SEG
            BSR     DrawOne
            BRA     mainLoop
            
               

delay:      NOP ; naive delay to make the LEDs brighter
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            NOP
            RTS            

; Given a Current Number, find the segment code needed to draw it
Lookup:     LDAA    CURR_NUM     ; grab the number
            LDAB    A, X            ; convert to segment code
            STAB    CURR_CODE     ; store the segment code
            RTS

LookupAll:  NOP ; grab a string of numbers, give back a string of segment codes

; Given a segment code and a specific segment, draw the number on the LED
DrawOne:    LDAB    CURR_CODE    ; grab one segment code and specific LED, draw on a specific LED
            LDAA    CURR_SEG     ; grab the current segment
            STAB    PORTB        ; assign the number
            STAA    PTP          ; enable the current LED
            BSR     delay
            LDAA    #NO_SEG       
            STAA    PTP          ; disable all LEDs
            RTS
            

DrawFour:   NOP ; grab four segment codes, draw on each LED

CheckButton:NOP ; see if the button active or deactive

NumberLoop: NOP ; if button is pressed, this should keep showing all numbers on LED

Scroll:     NOP ; grab a string, call LookupAll, keep calling DrawFour until end of string



;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
