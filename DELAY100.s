COUNT		EQU 0x0004E200			; COUNT VALUE FOR t=100ms		
	
			AREA routines, READONLY, CODE
			THUMB
			EXPORT DELAY
			
DELAY 		PUSH	{LR}
			PUSH 	{R2}
			LDR 	R2,=COUNT		;Decrement COUNT until it is ZERO
LOOP 		SUB 	R2,R2,#1   		;spends 1 cycle	/ Decrement R2 by one
			CMP		R2,#0       	;spends 1 cycle / is R2 ZERO?
			BNE 	LOOP    		;spends 1 or 2 cycle
			POP 	{R2}
			POP 	{LR}
			BX		LR
			ALIGN
			END