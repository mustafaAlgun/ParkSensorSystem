;This subroutine outputs the corresponding screen on the LCD.
;**************************************************

			AREA 	routines, CODE, READONLY
			THUMB
			EXTERN	CLEAR_SCREEN
			EXTERN	PRINT_STRING
			EXTERN	CONVERT_PRINT
			EXTERN	NORMAL_BAR_SELECTION
			EXPORT 	NORMAL_MODE_OUTPUT
			EXPORT 	PREVENTATIVE_BREAK_MODE_OUTPUT
			EXPORT	THRESHOLD_MODE_OUTPUT
				
;**************************************************

DISTANCE_MSG			DCB		"Distance: ", 4
MM_MSG					DCB		" mm", 13, 4
BREAK_MSG				DCB		"BRAKE ON", 13, 4

meas					DCB		"MEAS: ",0x04
thre					DCB		"THRE: ",0x04
normal					DCB		"			-> NORMAL OP.",0x04
break					DCB		"			-> BREAK ON  ",0x04
adjustment				DCB		"			-> THRE. ADJ.",0x04
bosluk					DCB		"	  ",0x04
buyuk_bosluk			DCB		"	 												 ",0x04
buyuk_bosluk2			DCB		"	 												",0x04
mm						DCB		"mm",0x04
no_meas					DCB		"***",0x04
adjustment_bar			DCB		"*************",0x04
break_bar				DCB		"CAR-||||||||||",0x04
break_again					DCB		"***",0x04

;**************************************************


NORMAL_MODE_OUTPUT	PROC
		PUSH{LR}
		PUSH{R4}
		LDR R5,=meas
		BL PRINT_STRING
		ALIGN
		LTORG
		BL	CONVERT_PRINT
		BL 	PRINT_STRING
		
		LDR R5,=mm
		BL	PRINT_STRING
		ALIGN
		LTORG
		LDR R5,=bosluk
		BL	PRINT_STRING
		ALIGN
		LTORG
		LDR R5,=thre
		BL	PRINT_STRING
		ALIGN
		LTORG
		PUSH{R4}
		MOV R4,R8
		BL	CONVERT_PRINT
		BL	PRINT_STRING
		LDR R5,=mm
		BL	PRINT_STRING
		ALIGN
		LTORG
		POP{R4}
		
		LDR R5,=buyuk_bosluk
		BL	PRINT_STRING
		ALIGN
		LTORG
		LDR R5,=normal
		BL	PRINT_STRING
		ALIGN
		LTORG
		LDR R5,=buyuk_bosluk2
		BL	PRINT_STRING
		ALIGN
		LTORG
		POP{R4}
		BL NORMAL_BAR_SELECTION
		POP{LR}
		BX	LR
		ENDP

PREVENTATIVE_BREAK_MODE_OUTPUT	PROC
		PUSH{LR}
		BL	CLEAR_SCREEN
		LDR R5,=meas
		BL PRINT_STRING
		ALIGN
		LTORG
		CMP	R4,#1000	; Assures that measurement stops for values greater than 999mm
		BLS	SKIP_NEXT
		LDR R5,=break_again
		BL 	PRINT_STRING
		B	GO_ON
SKIP_NEXT 
		BL	CONVERT_PRINT
		BL 	PRINT_STRING
GO_ON	LDR R5,=mm
		BL	PRINT_STRING
		ALIGN
		LTORG
		LDR R5,=bosluk
		BL	PRINT_STRING
		ALIGN
		LTORG
		LDR R5,=thre
		BL	PRINT_STRING
		ALIGN
		LTORG
		;PUSH{R4}
		MOV R4,R8
		BL	CONVERT_PRINT
		BL	PRINT_STRING
		LDR R5,=mm
		BL	PRINT_STRING
		ALIGN
		LTORG
		;POP{R4}
		
		LDR R5,=buyuk_bosluk
		BL	PRINT_STRING
		ALIGN
		LTORG
		LDR R5,=break
		BL	PRINT_STRING
		ALIGN
		LTORG
		LDR R5,=buyuk_bosluk2
		BL	PRINT_STRING
		ALIGN
		LTORG
		LDR R5,=break_bar
		BL	PRINT_STRING
		ALIGN
		LTORG
		
		POP{LR}
		BX	LR
		ENDP


THRESHOLD_MODE_OUTPUT	PROC
		PUSH{LR}
		
		BL	CLEAR_SCREEN
		LDR R5,=meas
		BL PRINT_STRING
		
		LDR	R5,=no_meas
		BL 	PRINT_STRING
		
		LDR R5,=mm
		BL	PRINT_STRING
		
		LDR R5,=bosluk
		BL	PRINT_STRING
		
		LDR R5,=thre
		BL	PRINT_STRING

		BL	CONVERT_PRINT
		BL	PRINT_STRING
		LDR R5,=mm
		BL	PRINT_STRING
				
		LDR R5,=buyuk_bosluk
		BL	PRINT_STRING
		LDR R5,=adjustment
		BL	PRINT_STRING
		
		LDR R5,=buyuk_bosluk
		BL	PRINT_STRING
		
		LDR R5,=adjustment_bar
		BL	PRINT_STRING
		
		POP{LR}
		BX	LR
		ENDP


			
		ALIGN
		END