	AREA DATA, READWRITE
SYSCTL_RCGCGPIO_R  EQU 0x400FE608
GPIO_PORTB_DATA_R  EQU 0x400053FC
GPIO_PORTB_DIR_R   EQU 0x40005400
GPIO_PORTB_AFSEL_R EQU 0x40005420
GPIO_PORTB_PUR_R   EQU 0x40005510
GPIO_PORTB_DEN_R   EQU 0x4000551C
GPIO_PORTB_LOCK_R  EQU 0x40005520
GPIO_PORTB_CR_R    EQU 0x40005524
GPIO_PORTB_AMSEL_R EQU 0x40005528
GPIO_PORTB_PCTL_R  EQU 0x4000552C
GPIO_PORTB_PDR_R   EQU 0x40005514
GPIO_LOCK_KEY      EQU 0x4C4F434B  ; Unlocks the GPIO_CR register

        AREA    |.text|, CODE, READONLY
        THUMB
        EXPORT  PORTB_Init
		EXPORT	PORTB_Output

;------------PORTB_Init------------
PORTB_Init
    LDR R1, =SYSCTL_RCGCGPIO_R      ; 1) activate clock for Port B
    LDR R0, [R1]                 
    ORR R0, R0, #0x02               ; set bit1 to turn on clock
    STR R0, [R1]                  
    NOP
    NOP                             ; allow time for clock to finish
    LDR R1, =GPIO_PORTB_LOCK_R      ; 2) unlock the lock register
    LDR R0, =0x4C4F434B             ; unlock GPIO Port B Commit Register
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_CR_R        ; 3) enable commit for Port B
    MOV R0, #0xFF                   ; 1 means allow access
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_AMSEL_R     ; 4) disable analog functionality
    MOV R0, #0                      ; 0 means analog is off
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_PCTL_R      ; 5) configure as GPIO
    MOV R0, #0x00000000             ; 0 means configure Port B as GPIO
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTB_DIR_R       ; 6) set direction register
    MOV R0,#0xFF                   ; PB0-PB7 are outputs
    STR R0, [R1]                    
    LDR R1, =GPIO_PORTB_AFSEL_R     ; 7) regular Port Bunction
    MOV R0, #0                      ; 0 means disable alternate function 
    STR R0, [R1]         
    LDR R1, =GPIO_PORTB_PDR_R       ; 8) pull-down resistors for port B
    MOV R0, #0x00                   
    STR R0, [R1]                  
    LDR R1, =GPIO_PORTB_PUR_R       ; pull-up resistors for port B
    MOV R0, #0x00                   
    STR R0, [R1]           
	LDR R1, =GPIO_PORTB_DEN_R       ; 9) enable Port B digital port
    MOV R0, #0xFF                   ; 1 means enable digital I/O
    STR R0, [R1]                   
    BX  LR      

;------------PORTB_Output------------
PORTB_Output
    LDR R1, =GPIO_PORTB_DATA_R ; pointer to Port B data
    STR R0, [R1]               ; write to PB7-PB0
    BX  LR                    

    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file
