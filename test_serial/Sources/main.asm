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


; code section
            ORG   ROMStart



; String to send to Serial
input_string   FCC  "Hello, World!"
NULL_A         FCB  13


; Constants 
ASCII_CR       EQU  13
;COUNTER        FDB  0

; code section
               ORG   ROMStart






Entry:
_Startup:
           LDS   #RAMEnd+1         ; initialize the stack pointer

           CLI                     ; enable interrupts
           
           LDAA #$0
           STAA SCI0BDH
           LDAA #$0D
           STAA SCI0BDL
           LDAA #0
           STAA SCI0CR1
           LDAA #$0C
           STAA SCI0CR2
           

START           
;           LDD  #3000
;           STD  COUNTER
           
           LDX  #input_string

OVER       LDAA 1, x+
           CMPA NULL_A
           BEQ  end_loop

HERE       BRCLR SCI0SR1, mSCI0SR1_TDRE, HERE
           STAA SCI0DRL
           BRA  OVER    
           
           
end_loop:

        ;   JSR  decCounter
         ;  BNE  end_loop
           BRA  START
           

; Decrements our counter            
;decCounter: LDD     COUNTER    ; Load the counter into D
 ;           CMPB    #0        
  ;          BNE     decSecond
            
;decFirst:   DECA               ; If register B hits 0 we decrement A
            
;decSecond:  DECB               ; Decrement B
 ;           STD     COUNTER
  ;          ORAB    COUNTER    ; Check if both A and B are zero (tells subroutine that called this one to stop)
   ;         RTS



;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
