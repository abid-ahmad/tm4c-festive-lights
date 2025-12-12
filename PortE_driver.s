		AREA DATA, READWRITE
SYSCTL_RCGCGPIO_R  EQU 0x400FE608
GPIO_PORTE_DATA_R  EQU 0x400243FC
GPIO_PORTE_DIR_R   EQU 0x40024400
GPIO_PORTE_AFSEL_R EQU 0x40024420
GPIO_PORTE_PUR_R   EQU 0x40024510
GPIO_PORTE_DEN_R   EQU 0x4002451C
GPIO_PORTE_LOCK_R  EQU 0x40024520
GPIO_PORTE_CR_R    EQU 0x40024524
GPIO_PORTE_AMSEL_R EQU 0x40024528
GPIO_PORTE_PCTL_R  EQU 0x4002452C
GPIO_PORTE_PDR_R   EQU 0x40024514
GPIO_LOCK_KEY      EQU 0x4C4F434B  ; Unlocks the GPIO_CR register

        AREA    |.text|, CODE, READONLY
        THUMB
        EXPORT  PORTE_Init
	EXPORT	PORTE_Input

;------------PORTE_Init------------
PORTE_Init
    LDR R1, =SYSCTL_RCGCGPIO_R      ; 1) activate clock for Port E
    LDR R0, [R1]                 
    ORR R0, R0, #0x10               
    STR R0, [R1]                  
    NOP
    NOP                             ; allow time for clock to finish
    LDR R1, =GPIO_PORTE_LOCK_R      ; 2) unlock the lock register
    LDR R0, =0x4C4F434B             ; unlock GPIO Port E Commit Register
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_CR_R        ; 3) enable commit for Port E
    MOV R0, #0xFF                   ; 1 means allow access
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_AMSEL_R     ; 4) disable analog functionality
    MOV R0, #0                      ; 0 means analog is off
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_PCTL_R      ; 5) configure as GPIO
    MOV R0, #0x00000000             ; 0 means configure Port E as GPIO
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTE_DIR_R       ; 6) set direction register
    MOV R0, #0x00                   ;PE2-PE0 are inputs
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_AFSEL_R     ; 7) regular Port Function
    MOV R0, #0                      ; 0 means disable alternate function 
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTE_PDR_R       ; 8) pull-down resistors for port E
    MOV R0, #0x07                   ; all 3 switches will use internal pull-down resistors
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTE_PUR_R       ; pull-up resistors for port E are disabled
    MOV R0, #0x00                   
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTE_DEN_R       ; 9) enable Port E digital port
    MOV R0, #0xFF                   ; 1 means enable digital I/O
    STR R0, [R1]                   
    BX  LR      

;------------PORTE_Input------------
PORTE_Input
    LDR R1, =GPIO_PORTE_DATA_R ; pointer to Port E data
    LDR R0, [R1]               ; read all of Port E
    AND R0,R0,#0x07            ; just the input pins PE0, PE1 and PE2
    BX  LR                     ; return R0 with inputs

