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

;**************************************************************
;*                                                            *
;**************************************************************

; Define enables for the 7 segments
NO_SEG      EQU  $FF   ; value to enable no segments
FIRST_SEG   EQU  $FE   ; value to enable the first segment
SECOND_SEG  EQU  $FD   ; value to enable the second segment
THIRD_SEG   EQU  $FB   ; value to enable the third segment
FOURTH_SEG  EQU  $F7   ; value to enable the fourth segment
CURR_SEG    FCB  $0    ; current segment to draw to

; Define the lookup codes for every special character
SEG_CODES   FCB  $3F, $06, $5B, $4F, $66, $6D, $7D, $07, $7F, $6F, $77, $7C, $39, $5E, $79, $71
CURR_NUM    FCB  $0  ; current number to draw
CURR_CODE   FCB  $0  ; current seg code for the number to draw

; Define a counter that will be used to time how long a string is displayed
COUNTER     FDB  $0

; Define the string to display
STRING      FCC  "012345678987654321012" ; string to display
NULL_A      FCB  13                    ; null terminator for above string
LOOP_STRING FCC  "0123456789"           ; string to display when button is pressed
NULL_B      FCB  13                    ; null terminator for above string


; Constants
ASCII_ZERO      EQU  48    ; the ascii code for '0'
COUNTER_START   EQU  6000  ; the counter starts at this value and decrements to 0
ASCII_CR        EQU  13    ; the ascii code for the carriage return
LOOP_CTR_START  EQU  24000 ; the counter starts at this value and decerements to 0 (for the loop caused by button press)
BUTTON_ON       EQU  $FE   ; the button is on if this is the value read (input as $FE when Port H all switch on by pull up SW1, and the press button PH0/SW5 pressed down)

; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                     ; enable interrupts

;**************************************************************
;*                                                            *
;**************************************************************
            
; Configure the direction of ports and index registers
configure:  LDAA    #$FF
            STAA    DDRB         ; Configure PORTB as output
            STAA    DDRP         ; Port P as output to enable 7 segments
            LDAA    #$00
            STAA    DDRH         ; Configure PORTH as input
            LDX     #SEG_CODES   ; Store all Segment Codes in Index Register X 

; Wraps the main loop of the program (which we treat as a subroutine)          
main:       
            LDAA    PTH          ; Check if the button is on
            CMPA    #BUTTON_ON   
            BEQ     configStrN   ; If it is on, do the number loop
            JSR     configStrM   ; If it is not on, keep scrolling
            BRA     main
            
; Configure the index register for the string
configStrM: LDY     #STRING      ; Store the string to display in Index Register Y


; Configure the counter for timing how long to draw
configCtrM: LDD     #COUNTER_START  ; Initialise the counter
            STD     COUNTER
            
;**************************************************************
;*                                                            *
;**************************************************************

; Calls other subroutines to draw specific output
mainLoop:          
            LDAA    PTH             ; Check if the button is on, if it is, end the loop early
            CMPA    #BUTTON_ON      
            BEQ     endMainLoop  
            JSR     DrawString      ; Draw the stored string for approximately one second  (while we wait for counter to reach 0)
            JSR     decCounter      ; Decrement counter
            BNE     mainLoop        ; Loop until counter reaches 0
            INY                     ; Increment our string
            LDAB    3, Y            ; Check if the current string portion is 4 numbers long
            JSR     checkString
            BNE     configCtrM      ; If it is keep scrolling
            
endMainLoop:RTS                     ; Otherwise end subroutine
            
; Configure the index register for the string
configStrN: LDY     #LOOP_STRING    ; Store the string to display in Index Register Y


; Configure the counter for timing how long to draw
configCtrN: LDD     #LOOP_CTR_START ; Initialise the counter
            STD     COUNTER

; Calls other subroutines to draw specific output for the number loop caused by button press
numberLoop:          
            LDAB    0, Y            ; Find the seg code for the first number
            SUBB    #ASCII_ZERO     ; We assume the string only has numbers
            STAB    CURR_NUM
            JSR     Lookup
            LDAB    #FIRST_SEG      ; Draw the first number for approximately a second (while we wait for counter to reach 0)
            STAB    CURR_SEG
            JSR     DrawOne
            JSR     decCounter      ; Decrement counter
            BNE     numberLoop      ; Loop until counter reaches 0
            INY                     ; Increment our string
            LDAB    0, Y            ; Check if we have reached the carriage return
            JSR     checkString
            BNE     configCtrN      ; If not keep looping
            BRA     main            ; Go back to the main loop
                                 
               
; Delays the program for approximately 0.043 ms
smallDelay: LDAA    #255
            JSR     delayLoop
            RTS
            
delayLoop:  DECA
            BNE     delayLoop
            RTS         

;**************************************************************
;*                                                            *
;**************************************************************

; Given a Current Number, find the segment code needed to draw it
Lookup:     LDAA    CURR_NUM     ; grab the number
            LDAB    A, X            ; convert to segment code
            STAB    CURR_CODE     ; store the segment code
            RTS

; Given a segment code and a specific segment, draw the number on the LED
DrawOne:    LDAB    CURR_CODE    ; grab one segment code and specific LED, draw on a specific LED
            LDAA    CURR_SEG     ; grab the current segment
            STAB    PORTB        ; assign the number
            STAA    PTP          ; enable the current LED
            JSR     smallDelay
            LDAA    #NO_SEG       
            STAA    PTP          ; disable all LEDs
            RTS
            
; Given a string, draw the first four characters
DrawString: LDAB    0, Y          ; Find the seg code for the first number
            SUBB    #ASCII_ZERO   ; We assume the string only has numbers
            STAB    CURR_NUM
            JSR     Lookup
            LDAB    #FIRST_SEG    ; Draw the first number
            STAB    CURR_SEG
            JSR     DrawOne
            LDAB    1, Y          ; Find the seg code for the second number
            SUBB    #ASCII_ZERO   ; We assume the string only has numbers
            STAB    CURR_NUM
            JSR     Lookup
            LDAB    #SECOND_SEG   ; Draw the first number
            STAB    CURR_SEG
            JSR     DrawOne
            LDAB    2, Y          ; Find the seg code for the third number
            SUBB    #ASCII_ZERO   ; We assume the string only has numbers
            STAB    CURR_NUM
            JSR     Lookup
            LDAB    #THIRD_SEG    ; Draw the first number
            STAB    CURR_SEG
            JSR     DrawOne
            LDAB    3, Y          ; Find the seg code for the fourth number
            SUBB    #ASCII_ZERO   ; We assume the string only has numbers
            STAB    CURR_NUM
            JSR     Lookup
            LDAB    #FOURTH_SEG   ; Draw the first number
            STAB    CURR_SEG
            JSR     DrawOne
            RTS

; Checks if we went past the end of the string
checkString:CMPB    #ASCII_CR     ; Check if it is our null terminator
            RTS

; Decrements our counter            
decCounter: LDD     COUNTER    ; Load the counter into D
            SUBD    #1         ; Decrement
            STD     COUNTER    ; Store back into counter
            RTS
                  
            
 

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
