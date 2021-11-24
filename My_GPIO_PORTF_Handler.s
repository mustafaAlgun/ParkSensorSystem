; Switch interrupts are handled here.

GPIO_PORTF_DATA 	EQU 	0x400253FC
GPIO_PORTF_ICR		EQU 	0x4002541C
GPIO_PORTF_MIS		EQU 	0x40025418
NVIC_ST_RELOAD 		EQU 	0xE000E014
RELOAD_VALUE 		EQU 99999
TIMER2_TAILR		EQU 0x40032028 ; Timer interval
TIMER2_CTL			EQU 0x4003200C
TIMER0_CTL			EQU 0x4003000C

;**************************************************					
			AREA 	routines, CODE, READONLY
			THUMB
			EXTERN	CONVERT
			EXTERN 	DELAY
				
;**************************************************

My_GPIO_PORTF_Handler  	PROC
						EXPORT 	My_GPIO_PORTF_Handler
		PUSH{LR}
		PUSH{R0-R3,R5-R7}
		LDR R1,=GPIO_PORTF_MIS
		LDR R0,[R1]
		AND R0,#0x10
		CMP R0,#0x10
		BEQ THRESHOLD
		LDR R1,=GPIO_PORTF_MIS
		LDR R0,[R1]
		AND R0,#0x01
		CMP R0,#0x01
		BEQ BRAKE
		
THRESHOLD
		LDR R1, =GPIO_PORTF_ICR
		MOV R0,#0x10
		STR R0,[R1] ; clear interrupt flag for SW1
		
		LDR R1, =TIMER2_CTL
		LDR R2, [R1]
		BIC R2, R2, #0x03	
		STR R2, [R1]
		MOV R9,#2	; set threshold mode
		ADD R11,#1	; if R11 = 0, switch is pressed once. If it is 1, then swtich is pressed twice. Go to "THRESHOLD_IS_SET"
		CMP R11,#1
		BHI THRESHOLD_IS_SET
		BLS FINITO
		
THRESHOLD_IS_SET
		MOV R11,#0
		MOV R9,#0
		MOV R8,R4
		LDR R1, =TIMER2_CTL ; enable timer 
		LDR R2, [R1]
		ORR R2, R2, #0x03
		STR R2, [R1]
		B FINITO
		
BRAKE			
		LDR R1, =GPIO_PORTF_ICR
		MOV R0,#0x01
		STR R0,[R1] ; clear interrupt flag for SW2	
		; Enable timers back
		LDR R1, =TIMER2_CTL ; enable timer 
		LDR R2, [R1]
		ORR R2, R2, #0x03
		STR R2, [R1]
		LDR R1, =TIMER0_CTL ; enable timer
		LDR R2, [R1]
		ORR R2, R2, #0x03
		STR R2, [R1]
		MOV R9,#0	; go back to normal mode
	
			
FINITO		POP{R0-R3,R5-R7}
			POP{LR}
			BX	LR
			ALIGN
			ENDP
			END