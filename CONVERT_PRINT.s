; This subroutine converts the value in R4 into its ASCII value and stores it in the [R5].


FIRST 	EQU 0x20000480
;**************************************************

		AREA	routines, READONLY, CODE
		THUMB
		EXPORT	CONVERT_PRINT		; Make available	

;**************************************************


CONVERT_PRINT	PROC
start	PUSH 	{LR}
		
		PUSH 	{R0-R4,R6-R12}
		MOV		R8,#0x0A
		LDR		R5,=FIRST
		MOV     R0,R4
		MOV 	R11,#0x00 	
		MOV		R4, #10
		MOV     R12,#0x30;for X=0,Y=0
		MOV		R1,R0
		CMP     R0,#0x64;for the X>1
		BGE     loop
		CMP     R0,#0x0A;for X=0,Y>1
		BGE     loopThree
		STRB	R12,[R5],#1;X=0
		STRB	R12,[R5],#1;Y=0
		ADD		R1,R1,#0x30;for the corosponding ascii value
		STRB	R1,[R5],#1;Z in ascii
		B GO
loop	UDIV 	R2, R1,R4 ;FOR THE NUMBERS HIGH THEN 1.00	
		MUL     R6, R2,R4 
		SUBS    R3, R1,R6
		MOV		R1,R2
		ADD		R3,R3,#0x30;for the corosponding ascii value
		PUSH 	{R3}	
		ADD 	R11,R11,#1 
		CMP     R1,#0
		BNE	loop	
		POP 	{R3}
		STRB	R3,[R5],#1
		SUBS 	R11,R11,#1

loopTWO 	
		POP 	{R3}
		STRB	R3,[R5],#1
		SUBS 	R11,R11,#1 ;counter value
		BNE		loopTWO
		B GO
		
loopThree  STRB	R12,[R5],#1;FOR THE NUMBERS HIGH THEN 0.10
                           ;make X=0
loopFour  
		UDIV 	R2, R1,R4	;same as above
		MUL     R6, R2,R4
		SUBS    R3, R1,R6
		MOV		R1,R2
		ADD		R3,R3,#0x30
		PUSH 	{R3}	
		ADD 	R11,R11,#1 
		CMP     R1,#0
		BNE	loopFour	
		POP 	{R3}
		STRB	R3,[R5],#1
		SUBS 	R11,R11,#1
loopFive 	
		POP 	{R3}
		STRB	R3,[R5],#1
		SUBS 	R11,R11,#1
		BNE		loopFive
GO		
		MOV 	R10,#0x04  ;to end the value
		STRB 	R10,[R5],#1 ;	
		LDR 	R5,=FIRST	;
		

		POP		{R0-R4,R6-R12}
SKIP	POP		{LR}
		BX		LR			 	
		ENDP
		END