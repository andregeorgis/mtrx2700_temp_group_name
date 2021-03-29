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

upper_limit_Z     FCB $5A     ; upper_limit for upper case, which is Z
lower_limit_A     FCB $41     ; lower_limit for upper case, which is A

upper_limit_z     FCB $7A     ; upper_limit for lower case, which is z
lower_limit_a     FCB $61     ; lower_limit for lower case, which is a

previous_letter   DS.B  1     ; allocate memory for later use (storing the previous letter in this variable)

; Constants
ASCII_NL    EQU    10
ASCII_CR    EQU    13
ASCII_SP    EQU    32
START_STR   EQU    0
CASE_GAP    EQU    $20
BUTTON_ON   EQU    $FE   ; the button is on if this is the value read (input as $FE when Port H all switch on by pull up SW1, and the press button PH0/SW5 pressed down)

; Serial port configurations
BAUD_RATE   EQU    $9C
CR_1        EQU    $00
CR_2        EQU    $0C
FLAG_1      EQU    $20
FLAG_2      EQU    $80

PORT_ON     EQU    $00

; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                     ; enable interrupts

config:     LDAA  #PORT_ON
            STAA  DDRH           ; Configure PORTH as input

            LDD   #BAUD_RATE     ; Set baud rate to 9600bps
            STD   SCI1BD
            LDAA  #CR_1          ; Set Control Registers to enable reading and transmission
            STAA  SCI1CR1
            LDAA  #CR_2
            STAA  SCI1CR2

;**************************************************************
;*                  Reading function                          *
;**************************************************************

configStrR: LDX   #STRING_IN     ; Load a string

readLoop:   LDAA  SCI1SR1        ; Attempt to read from serial
            ANDA  #FLAG_1
            BEQ   readLoop
            LDAA  SCI1DRL        ; Store byte read from serial
            STAA  0, X
            CMPA  #ASCII_CR      ; If we are at end of string start modifying the string
            BEQ   modString
            INX
            BRA   readLoop       ; Otherwise keep reading

;**************************************************************
;*                 Transmission function                      *
;**************************************************************

configStrT: LDX   #STRING_MOD    ; Load the string to send

transmLoop: LDAA  SCI1SR1        ; Wait till we can send the byte
            ANDA  #FLAG_2
            BEQ   transmLoop
            LDAA  0, X           ; Send the byte
            STAA  SCI1DRL
            CMPA  #ASCII_CR      ; If we are at end of string start reading
            BEQ   configStrR
            INX                  ; Otherwise keep transmitting
            BRA   transmLoop

;**************************************************************
;*                    Modifying String                        *
;**************************************************************

modString:  LDX   #STRING_IN     ; Load string received from serial
            LDY   #STRING_MOD    ; Load memory to save modified string
            LDAA  #START_STR     ; Indicate start of string
            LDAB  PTH            ; Check if the button is on
            CMPB  #BUTTON_ON
            BEQ   capLoop        ; If so capitalise string, otherwise uppercase

; Makes string Uppercase
upperLoop:
            LDAB  0, X
            INX
            JSR   all_cap
            CMPB  #ASCII_CR
            BEQ   configStrT     ; Once we finish modifying, transmit the modified string
            BRA   upperLoop

; Capitalises the string
capLoop: ; In this routine, A is previous letter and B is current letter
            LDAB  0, X
            INX

            CMPA  #START_STR     ; Capitalise start of string
            BEQ   cap_x

            CMPA  #ASCII_SP      ; Capitalise after space
            BEQ   cap_x

            JSR   lower_the_rest

            CMPB  #ASCII_CR      ; Once we finish modifying, transmit the modified string
            BEQ   configStrT

            BRA   capLoop

;**************************************************************
;*                        Subroutines                         *
;*                   Character conversion                     *
;**************************************************************

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
                          SUBB   #CASE_GAP
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
                          ADDB   #CASE_GAP
                          STAB   0,y
                          INY
                          RTS

skip_update:

            STAB   0,y
            INY
            RTS


;**************************************************************
;*           Other subroutines (for Capitalising)             *
;**************************************************************

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
