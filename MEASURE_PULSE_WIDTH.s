;Pulse width is measured in here.


GPIO_PORTF_DATA		EQU 0x400253FC 
TIMER1_CFG			EQU 0x40031000
TIMER1_TAMR			EQU 0x40031004
TIMER1_CTL			EQU 0x4003100C
TIMER1_IMR			EQU 0x40031018
TIMER1_RIS			EQU 0x4003101C ; Timer Interrupt Status
TIMER1_ICR			EQU 0x40031024 ; Timer Interrupt Clear
TIMER1_TAILR		EQU 0x40031028 ; Timer interval
TIMER1_TAPR			EQU 0x40031038
TIMER1_TBPR			EQU 0x4003103C
TIMER1_TAR			EQU	0x40031048 ; Timer register
TIMER1_AMATCHR		EQU	0x40031030	

;**************************************************

			AREA 	PULSE_WIDTH, READONLY, CODE, ALIGN=2
			EXPORT MEASURE_PWM
			THUMB
				
;**************************************************
MEASURE_PWM PROC

			PUSH	{LR, R1, R2, R10}
			


;			   FIRST_HIGH			SECOND_LOW
;					|-------------------|
;					|		   			|
;					|		   			|
;___________________|<---PULSE WIDTH--->|____________
;	FIRST LOW	
;

WAIT_FIRST_LOW	; Wait until First LOW 
			LDR R1, =GPIO_PORTF_DATA
			LDR	R0, [R1]
			AND	R0, #4		;PF2
			CMP	R0, #4 
			BEQ	WAIT_FIRST_LOW
			
			LDR	R1, =TIMER1_ICR	; Clear RIS
			LDR	R0, [R1]
			ORR	R0, #4
			STR	R0, [R1]
				
WAIT_FIRST_HIGH	; Wait until First HIGH
			LDR	R1, =TIMER1_RIS
			LDR	R0, [R1]
			AND	R0, #4		;PF2
			CMP	R0, #4
			BNE	WAIT_FIRST_HIGH
			
			LDR	R1, =TIMER1_ICR	; Clear RIS
			LDR	R0, [R1]
			ORR	R0, #4
			STR	R0, [R1]
			
			LDR	R1, =TIMER1_TAR	; First data is stored
			LDR	R2, [R1]
			
			
WAIT_SECOND_LOW	; Wait until Second LOW
			LDR	R1, =TIMER1_RIS
			LDR	R0, [R1]
			AND	R0, #4		;PF2		
			CMP	R0, #4
			BNE	WAIT_SECOND_LOW
			
			LDR	R1, =TIMER1_ICR	; Clear RIS
			LDR	R0, [R1]
			ORR	R0, #4
			STR	R0, [R1]
			
			LDR	R1, =TIMER1_TAR
			LDR	R0, [R1]	; Second data is stored
			
			SUB	R0, R0, R2	; R0 = (Second data - First data)
			
			POP	{LR, R1, R2, R10}			
			BX	LR			
			ENDP