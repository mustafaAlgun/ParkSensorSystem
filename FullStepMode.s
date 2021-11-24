GPIO_PORTB_DATAx	EQU 0x400053FC  
GPIO_PORTC_DATA 	EQU 0x400063FC 	
				AREA 	subroutines, READONLY, CODE, ALIGN=2
				THUMB
				EXPORT 		FullStepMode
				
FullStepMode	PROC
				; THIS CODE DRIVES MOTOR
				
				CMP		R7,#0			; R=0 CLOCKWISE
				BEQ		CLOCKWISE

				
CLOCKWISE	    LDR	 	R2,=GPIO_PORTC_DATA	 ;LAST FOUR BIT
				LDR     R3,[R2]	
				LSR		R3,#4
				CMP     R3,#0x0 ; if the output is 0 do it 8
				BEQ     CLOCKWISE1
				CMP     R3,#0x8 ; if the output is 8 do it 4
				BEQ     CLOCKWISE2     
				CMP     R3,#0x4 ; if the output is 4 do it 2
				BEQ     CLOCKWISE3
				CMP     R3,#0x2 ; if the output is 2 do it 1 	 
				BEQ     CLOCKWISE4
				CMP     R3,#0x1 ; if the output is 1 do it 8
				BEQ     CLOCKWISE5
CLOCKWISE1     	LDR     R3,=0x80
				STR     R3,[R2]
				B       FINISH    
CLOCKWISE2     LDR     R3,=0x40
				STR     R3,[R2]
				B       FINISH
CLOCKWISE3     LDR     R3,=0x20
				STR     R3,[R2]
				B       FINISH
CLOCKWISE4     LDR     R3,=0x10
				STR     R3,[R2]
				B       FINISH
CLOCKWISE5     LDR     R3,=0x80
				STR     R3,[R2]
				B       FINISH	    

FINISH     		
				BX LR
				ALIGN 
				ENDP
				END
			