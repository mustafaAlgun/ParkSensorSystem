;ADC conversion is done in this subroutine.

ADC0_SSFIFO3		EQU		0x400380A8		;channel 3 results
ADC0_PC				EQU		0x40038FC4		;sample rate
ADC0_ISC			EQU		0x4003800C	
ADC0_RIS			EQU		0x40038004		;interrupt status
ADC0_PSSI			EQU		0x40038028		;initiate sample
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
			EXTERN 	DELAY
			EXTERN	CLEAR_SCREEN
			EXTERN	PRINT_STRING
			EXTERN	CONVERT_PRINT
			EXTERN	THRESHOLD_MODE_OUTPUT
			EXPORT 	ADC_THRESHOLD

;**************************************************
				
meas					DCB		"MEAS: ",0x04
thre					DCB		"THRE: ",0x04
adjustment				DCB		"			-> THRE. ADJ.",0x04
bosluk					DCB		"	  ",0x04
buyuk_bosluk			DCB		"	 												 ",0x04
mm						DCB		"mm",0x04
no_meas					DCB		"***",0x04
adjustment_bar			DCB		"*************",0x04

;--------------- ADC SUBROUTINE STARTS -------------- 
ADC_THRESHOLD  PROC	;ADC WITH POTENTIOMETER
		PUSH{LR}
		LDR R3, =ADC0_RIS ; interrupt address
		LDR R6, =ADC0_SSFIFO3 ; result address
		LDR R5, =ADC0_PSSI ; sample sequence initiate address
		LDR R2,= ADC0_ISC
		LDR R0, [R5]
		ORR R0, R0, #0x08 ; set bits 3 to 1 for SS3
		STR R0, [R5]
		ALIGN
		LTORG
		; check for sample complete (bit 3 of ADC0_RIS set)
Cont 	LDR R0, [R3]
		AND R0, R0, #8
		BNE Cont
		;branch fails if the flag is set so data can be read and flag is cleared
		;-----
		LDR R0,[R6]
		MOV R7,R0 		;FIRST DATA
		MOV R8,#90		
		MUL R7,R7,R8
		MOV R8,#369
		UDIV R7,R7,R8	;multipying 0xFFF with 90/369 gives us 998	
		; PREP FOR OTHER DATA
		LDR R2,= ADC0_ISC
		MOV R0,#8
		STR R0,[R2] ; clear flag		
		LDR R3, =ADC0_RIS ; interrupt address
		LDR R6, =ADC0_SSFIFO3 ; result address
		LDR R5, =ADC0_PSSI ; sample sequence initiate address
		LDR R2,= ADC0_ISC		

Cont2 	LDR R0, [R3]
		AND R0, R0, #8
		BNE Cont2
	
		LDR R0,[R6]
		MOV R4,R0 		;SECOND DATA	
		MOV R8,#90
		MUL R4,R4,R8
		MOV R8,#369
		UDIV R4,R4,R8	;multipying 0xFFF with 90/369 gives us 998	
	
		CMP  R4,R7		
		SUBHI R10,R4,R7
		SUBLS R10,R7,R4
		CMP  R10,#10		; check for 0.1V difference
		BLS	BIR				; if less than or equal to 0.1V go to ONE
		BHI IKI				; if greater than 0.1V go to IKI
BIR		MOV R8,#0			; R8 = 0 (DO NOT PRINT ANYTHING) 
		B FINAL		
IKI		MOV R8,#1			; R8 = 1 (PRINT THE VALUE) 
		
FINAL	;PRINTS THE CURRENT POTENTIOMETER VALUE
		CMP R8,#0
		BEQ SKIP
		
		BL THRESHOLD_MODE_OUTPUT	; PRINT ON THE SCREEN
		
SKIP	BL DELAY			
		BL DELAY			
		LDR R2,= ADC0_ISC
		MOV R0,#8
		STR R0,[R2] ; clear flag to receive new data
		POP{LR}
		BX	LR
		ALIGN
		ENDP
		END