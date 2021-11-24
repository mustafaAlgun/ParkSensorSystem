TIMER3_ICR			EQU 0x40033024 ; Timer Interrupt Clear
					AREA    	routines, READONLY, CODE
					THUMB
					EXTERN 		ADC_THRESHOLD

MY_ADC_Handler	PROC
					EXPORT  	MY_ADC_Handler	
					PUSH {LR}
					BL ADC_THRESHOLD
					LDR R1, =TIMER3_ICR
					MOV R0,#0x04
					STR R0,[R1] ; clear interrupt flag for PB2						
					POP {LR}
					BX 	LR
					ALIGN
					ENDP
					END