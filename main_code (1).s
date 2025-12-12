	AREA    DATA, READWRITE
halfSec  EQU     2666666 ;5333333               ; approximately 0.5s delay at ~16 MHz clock

        AREA    |.text|, CODE, READONLY
        IMPORT  PORTB_Init
		IMPORT  PORTB_Output
        IMPORT  PORTE_Init
		IMPORT  PORTE_Input
        THUMB
        EXPORT  Start

Start
        BL      PORTB_Init            ; initializes output pins of Port B (PB7-PB0) (LEDS)
        BL      PORTE_Init            ; initializes input  pins of Port E (PE2-PE0) (SWITCHES) 
		
main
        ; switches are active-high 
        BL      PORTE_Input           ; read the switches on(PE2-PE0)
        ANDS    R1, R0, #0x07         ; mask to only 3 bits; 001? or 010? 100? 

        ; branch to appropriate label based on the switch selection 
        CMP     R1, #1                ; PE0?
        BEQ     R2L
        CMP     R1, #2                ; PE1?
        BEQ     L2R
        CMP     R1, #4                ; PE2?
        BEQ     RANDOM
        B       main


; pattern selection
R2L
        MOVS    R6, R1 ; save the switch bit to check it is pressed again so that system can turn off 
        LDR     R2, =R2L_pattern ; base address of the pattern
        MOVS    R4, #8 ; length of the pattern
        B       runPattern
		
L2R
        MOVS    R6, R1
        LDR     R2, =L2R_pattern
        MOVS    R4, #8
        B       runPattern

RANDOM
        MOVS    R6, R1
        LDR     R2, =RANDOM_pattern
        MOVS    R4, #16
        B       runPattern
		
runPattern
        MOVS    R3, #0   ; current counter value; i=0

forLoop
        CMP     R3, R4
        BLT     startloading
        MOVS    R3, #0    ; initializes with zero again so that it can start loading again

startloading
        LDRB    R0, [R2, R3]           ; R0 has the current byte of the pattern 
        BL      PORTB_Output
        ; delay
        LDR     R0, =halfSec
        BL      delay
        ; check same key to stop
        BL      PORTE_Input
        ANDS    R5, R0, R6
        CMP     R5, #0  ; it checks the same switch again; if pressed, then stop the light
        BNE     patternDone                
        ADDS    R3, R3, #1 ; if not pressed again; keep loading bytes
        B       forLoop
		
patternDone  
        MOVS    R0, #0 ; turn off all lights
        BL      PORTB_Output
		
wait_and_check ; this is used to prevent stopping and starting the pattern on the same press
        BL      PORTE_Input
        ANDS    R5, R0, R6
        CMP     R5, #0
        BNE     wait_and_check    ; wait until not pressed
        B       main  ; return to rest state

;pre-made patterns
R2L_pattern  DCB 0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80
L2R_pattern  DCB 0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01
RANDOM_pattern DCB 0x3C,0x12,0xA9,0x47,0x5E,0x90,0x2D,0x71
				DCB 0xC3,0x18,0x6F,0x84,0x5A,0xE1,0x0F,0xB2
;------------delay------------
delay
        SUBS    R0, R0, #1
        BNE     delay
        BX      LR

        ALIGN
        END