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

; Define enables for the 7 segments
NO_SEG      EQU  $FF   ; value to enable no segments
FIRST_SEG   EQU  $FE   ; value to enable the first segment
SECOND_SEG  EQU  $FD   ; value to enable the second segment
THIRD_SEG   EQU  $FB   ; value to enable the third segment
FOURTH_SEG  EQU  $F7   ; value to enable the fourth segment

; Define the lookup codes for every special character
;SEG_CODES   FCB $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F, $77, $7C, $39, $5E, $79, $71

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
            
; Configure the direction of ports
configure:  LDAA    #$FF
            STAA    DDRB    ; Configure PORTB as output
            STAA    DDRP    ; Port P as output to enable 7 segments

mainLoop:
            
            LDAB    #$06
            STAB    PORTB          ; Assign the number 1
            LDAA    #FIRST_SEG     
            STAA    PTP            ; Enable the first segment
            LDAA    #NO_SEG
            STAA    PTP            ; Disable all segments
            LDAB    #$5B
            STAB    PORTB          ; Assign the number 2
            LDAA    #SECOND_SEG
            STAA    PTP            ; Enable the second segment
            LDAA    #NO_SEG
            STAA    PTP            ; Disable all segments
            LDAB    #$4F
            STAB    PORTB          ; Assign the number 3
            LDAA    #THIRD_SEG     
            STAA    PTP            ; Enable the third segment
            LDAA    #NO_SEG
            STAA    PTP            ; Disable all segments
            LDAB    #$66
            STAB    PORTB          ; Assign the number 4
            LDAA    #FOURTH_SEG
            STAA    PTP            ; Enable the fourth segment
            LDAA    #NO_SEG
            STAA    PTP            ; Disable all segments
            bra     mainLoop    
            

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
