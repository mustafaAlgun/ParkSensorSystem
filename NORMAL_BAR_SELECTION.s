						AREA    routines, CODE, READONLY
						THUMB
						EXTERN OutStrNokia
						EXPORT NORMAL_BAR_SELECTION
							
buyuk_bosluk				DCB		"	 												 ",0x04
normal_bar11				DCB		"CAR X|||||||||",0x04	;0-99
normal_bar12				DCB		"CAR X-||||||||",0x04	
normal_bar13				DCB		"CAR X--|||||||",0x04	
normal_bar14				DCB		"CAR X---||||||",0x04	
normal_bar15				DCB		"CAR X----|||||",0x04	
normal_bar16				DCB		"CAR X-----||||",0x04	
normal_bar17				DCB		"CAR X------|||",0x04	
normal_bar18				DCB		"CAR X-------||",0x04	
normal_bar19				DCB		"CAR X--------|",0x04	


normal_bar21				DCB		"CAR -X||||||||",0x04	;100-199
normal_bar22				DCB		"CAR -X-|||||||",0x04	
normal_bar23				DCB		"CAR -X--||||||",0x04	
normal_bar24				DCB		"CAR -X---|||||",0x04	
normal_bar25				DCB		"CAR -X----||||",0x04	
normal_bar26				DCB		"CAR -X-----|||",0x04	
normal_bar27				DCB		"CAR -X------||",0x04	
normal_bar28				DCB		"CAR -X-------|",0x04	

normal_bar31				DCB		"CAR --X|||||||",0x04	;200-299
normal_bar32				DCB		"CAR --X-||||||",0x04	
normal_bar33				DCB		"CAR --X--|||||",0x04	
normal_bar34				DCB		"CAR --X---||||",0x04	
normal_bar35				DCB		"CAR --X----|||",0x04	
normal_bar36				DCB		"CAR --X-----||",0x04	
normal_bar37				DCB		"CAR --X------|",0x04	

normal_bar41				DCB		"CAR ---X||||||",0x04	;300-399	
normal_bar42				DCB		"CAR ---X-|||||",0x04	
normal_bar43				DCB		"CAR ---X--||||",0x04	
normal_bar44				DCB		"CAR ---X---|||",0x04	
normal_bar45				DCB		"CAR ---X----||",0x04	
normal_bar46				DCB		"CAR ---X-----|",0x04	

normal_bar51				DCB		"CAR ----X|||||",0x04	;400-499	
normal_bar52				DCB		"CAR ----X-||||",0x04	
normal_bar53				DCB		"CAR ----X--|||",0x04	
normal_bar54				DCB		"CAR ----X---||",0x04	
normal_bar55				DCB		"CAR ----X----|",0x04		

normal_bar61				DCB		"CAR -----X||||",0x04	;500-599	
normal_bar62				DCB		"CAR -----X-|||",0x04	
normal_bar63				DCB		"CAR -----X--||",0x04	
normal_bar64				DCB		"CAR -----X---|",0x04

normal_bar71				DCB		"CAR ------X|||",0x04	;600-699	
normal_bar72				DCB		"CAR ------X-||",0x04	
normal_bar73				DCB		"CAR ------X--|",0x04

normal_bar81				DCB		"CAR -------X||",0x04	;700-799	
normal_bar82				DCB		"CAR -------X-|",0x04

normal_bar91				DCB		"CAR --------X|",0x04	;800-899	

				
NORMAL_BAR_SELECTION 	PROC
						PUSH{R2,LR}
			
			LDR R2,=799
			CMP R8,R2
			BHI ONE
			LDR R2,=699
			CMP R8,R2
			BHI TWO
			LDR R2,=599
			CMP R8,R2
			BHI THREE
			LDR R2,=499
			CMP R8,R2
			BHI FOUR
			LDR R2,=399
			CMP R8,R2
			BHI FIVE
			LDR R2,=299
			CMP R8,R2
			BHI.W SIX
			LDR R2,=199
			CMP R8,R2
			BHI.W SEVEN
			LDR R2,=99
			CMP R8,R2
			BHI.W EIGHT
			B 	NINE
						
ONE			;THRESHOLD = 800-899			
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar91
			BL	OutStrNokia
			B EXIT
TWO			;THRESHOLD = 700-799
			LDR R2,=899
			CMP R4,R2
			BHI TWO1
			LDR R2,=799
			CMP R4,R2
			BHI TWO2
			B EXIT
TWO1
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar82
			BL	OutStrNokia
			B EXIT
TWO2
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar81
			BL	OutStrNokia
			B EXIT

THREE		;THRESHOLD = 600-699
			LDR R2,=899
			CMP R4,R2
			BHI THREE1
			LDR R2,=799
			CMP R4,R2
			BHI THREE2
			LDR R2,=699
			CMP R4,R2
			BHI THREE3
			B EXIT
THREE1
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar73
			BL	OutStrNokia
			B EXIT
THREE2
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar72
			BL	OutStrNokia
			B EXIT
THREE3
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar71
			BL	OutStrNokia
			B EXIT
			
FOUR		;THRESHOLD = 500-599
			LDR R2,=899
			CMP R4,R2
			BHI FOUR1
			LDR R2,=799
			CMP R4,R2
			BHI FOUR2
			LDR R2,=699
			CMP R4,R2
			BHI FOUR3
			LDR R2,=599
			CMP R4,R2
			BHI FOUR4
			B EXIT
FOUR1
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar64
			BL	OutStrNokia
			B EXIT
FOUR2
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar63
			BL	OutStrNokia
			B EXIT
FOUR3
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar62
			BL	OutStrNokia
			B EXIT
FOUR4
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar61
			BL	OutStrNokia
			B EXIT

FIVE		;THRESHOLD = 400-499
			LDR R2,=899
			CMP R4,R2
			BHI FIVE1
			LDR R2,=799
			CMP R4,R2
			BHI FIVE2
			LDR R2,=699
			CMP R4,R2
			BHI FIVE3
			LDR R2,=599
			CMP R4,R2
			BHI FIVE4
			LDR R2,=499
			CMP R4,R2
			BHI FIVE5
			B EXIT
FIVE1
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar55
			BL	OutStrNokia
			B EXIT
FIVE2
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar54
			BL	OutStrNokia
			B EXIT
FIVE3
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar53
			BL	OutStrNokia
			B EXIT
FIVE4
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar52
			BL	OutStrNokia
			B EXIT
FIVE5
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar51
			BL	OutStrNokia
			B EXIT
			
SIX			;THRESHOLD = 300-399
			LDR R2,=899
			CMP R4,R2
			BHI SIX1
			LDR R2,=799
			CMP R4,R2
			BHI SIX2
			LDR R2,=699
			CMP R4,R2
			BHI SIX3
			LDR R2,=599
			CMP R4,R2
			BHI SIX4
			LDR R2,=499
			CMP R4,R2
			BHI SIX5
			LDR R2,=399
			CMP R4,R2
			BHI SIX6
			B EXIT
SIX1
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar46
			BL	OutStrNokia
			B EXIT
SIX2
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar45
			BL	OutStrNokia
			B EXIT
SIX3
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar44
			BL	OutStrNokia
			B EXIT
SIX4
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar43
			BL	OutStrNokia
			B EXIT
SIX5
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar42
			BL	OutStrNokia
			B EXIT
SIX6
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar41
			BL	OutStrNokia
			B EXIT

SEVEN		;THRESHOLD = 200-299
			LDR R2,=899
			CMP R4,R2
			BHI SEVEN1
			LDR R2,=799
			CMP R4,R2
			BHI SEVEN2
			LDR R2,=699
			CMP R4,R2
			BHI SEVEN3
			LDR R2,=599
			CMP R4,R2
			BHI SEVEN4
			LDR R2,=499
			CMP R4,R2
			BHI SEVEN5
			LDR R2,=399
			CMP R4,R2
			BHI SEVEN6
			LDR R2,=299
			CMP R4,R2
			BHI SEVEN7
			B EXIT
SEVEN1
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar37
			BL	OutStrNokia
			B EXIT
SEVEN2
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar36
			BL	OutStrNokia
			B EXIT
SEVEN3
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar35
			BL	OutStrNokia
			B EXIT
SEVEN4
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar34
			BL	OutStrNokia
			B EXIT
SEVEN5
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar33
			BL	OutStrNokia
			B EXIT
SEVEN6
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar32
			BL	OutStrNokia
			B EXIT
SEVEN7
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar31
			BL	OutStrNokia
			B EXIT

EIGHT		;THRESHOLD = 100-199
			LDR R2,=899
			CMP R4,R2
			BHI EIGHT1
			LDR R2,=799
			CMP R4,R2
			BHI EIGHT2
			LDR R2,=699
			CMP R4,R2
			BHI EIGHT3
			LDR R2,=599
			CMP R4,R2
			BHI EIGHT4
			LDR R2,=499
			CMP R4,R2
			BHI EIGHT5
			LDR R2,=399
			CMP R4,R2
			BHI EIGHT6
			LDR R2,=299
			CMP R4,R2
			BHI EIGHT7
			LDR R2,=199
			CMP R4,R2
			BHI EIGHT8
			B EXIT
EIGHT1
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar28
			BL	OutStrNokia
			B EXIT
EIGHT2
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar27
			BL	OutStrNokia
			B EXIT
EIGHT3
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar26
			BL	OutStrNokia
			B EXIT
EIGHT4
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar25
			BL	OutStrNokia
			B EXIT
EIGHT5
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar24
			BL	OutStrNokia
			B EXIT
EIGHT6
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar23
			BL	OutStrNokia
			B EXIT
EIGHT7
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar22
			BL	OutStrNokia
			B EXIT
EIGHT8
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar21
			BL	OutStrNokia
			B EXIT

NINE		;THRESHOLD = 0-99
			LDR R2,=899
			CMP R4,R2
			BHI NINE1
			LDR R2,=799
			CMP R4,R2
			BHI NINE2
			LDR R2,=699
			CMP R4,R2
			BHI NINE3
			LDR R2,=599
			CMP R4,R2
			BHI NINE4
			LDR R2,=499
			CMP R4,R2
			BHI NINE5
			LDR R2,=399
			CMP R4,R2
			BHI NINE6
			LDR R2,=299
			CMP R4,R2
			BHI NINE7
			LDR R2,=199
			CMP R4,R2
			BHI NINE8
			LDR R2,=99
			CMP R4,R2
			BHI NINE9
			B EXIT
NINE1
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar19
			BL	OutStrNokia
			B EXIT
NINE2
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar18
			BL	OutStrNokia
			B EXIT
NINE3
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar17
			BL	OutStrNokia
			B EXIT
NINE4
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar16
			BL	OutStrNokia
			B EXIT
NINE5
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar15
			BL	OutStrNokia
			B EXIT
NINE6
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar14
			BL	OutStrNokia
			B EXIT
NINE7
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar13
			BL	OutStrNokia
			B EXIT
NINE8
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar12
			BL	OutStrNokia
			B EXIT
NINE9
			LDR R5,=buyuk_bosluk
			BL	OutStrNokia			
			LDR R5,=normal_bar11
			BL	OutStrNokia
			B EXIT

EXIT
						POP{R2,LR}
						BX	LR
						ENDP
						END