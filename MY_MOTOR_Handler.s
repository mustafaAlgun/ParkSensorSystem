TIMER2_ICR			EQU 0x40032024 ; Timer Interrupt Clear

					AREA    	routines, READONLY, CODE
					THUMB
					EXTERN 		FullStepMode

MY_MOTOR_Handler	PROC
					EXPORT  	MY_MOTOR_Handler	
					PUSH {LR}
					BL FullStepMode
					LDR R1, =TIMER2_ICR
					MOV R0,#0x01
					STR R0,[R1] ; clear interrupt flag for PB0						
					POP {LR}
					BX 	LR
					ALIGN
					ENDP
					END