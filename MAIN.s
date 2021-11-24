; ********************************* Laboratory Project ********************************************
; ********************************* Park Sensor System ********************************************
;Mustafa Algun
;2165777


; Timer0 PB6 pin -> Generates PWM 
; Timer1 PF2 pin -> Measures Distance
; Timer2 is used to drive the motor with interrupts

;CONNECTIONS

;***DISTANCE SENSOR****
;TRIGGER = PB6
;ECHO = PF2
;VDD = VBUS
;GND = GND

;******ADC & POT*******
;PE3 = POTENTIOMETER
;VDD = 3.3V
;GND = GND

;*******MOTOR**********
;IN1 = PC4
;IN2 = PC5
;IN3 = PC6
;IN4 = PC7
;VDD = VBUS
;GND = GND

;*******NOKIA 5110 LCD**********
; 3.3V			(VCC) = 3.3V
; Ground 		(GND) = GND
; SSI0Fss  		(SCE) = PA3
; Reset         (RST) = PA7
; Data/Command  (D/C) = PA6
; SSI0Tx        (DN)  = PA5
; SSI0Clk       (SCL) = PA2
; Back light    (LED) = Vbus


;Due to static pool error I added some lines in the code as below,
;LTORG
;Align
;Please ignore these commands, they are there just to solve the problem.


; Timer registers
TIMER0_CTL			EQU 0x4003000C
TIMER2_CTL			EQU 0x4003200C
	
;**************************************************

		AREA |.text|, READONLY, CODE, ALIGN=2
		THUMB
		EXTERN  INIT_ADC
		EXTERN  INIT_GPIO
		EXTERN	DELAY
		EXTERN  My_GPIO_PORTF_Handler
		EXTERN  PWM_AND_MOTOR_INIT
		EXTERN  MEASURE_PWM
		EXTERN  ADC_THRESHOLD
		EXTERN	INIT_NOKIA_5510
		EXTERN	CLEAR_SCREEN
		EXTERN	PRINT_STRING
		EXTERN	CONVERT_PRINT
		EXTERN	NORMAL_BAR_SELECTION
		EXTERN 	NORMAL_MODE_OUTPUT
		EXTERN 	PREVENTATIVE_BREAK_MODE_OUTPUT
		EXPORT __main
			
;**************************************************


__main	PROC
		BL INIT_GPIO
		BL INIT_ADC
		BL PWM_AND_MOTOR_INIT
		BL INIT_NOKIA_5510
		CPSIE I
			

;		R11 is used to store how many times SW1 is pressed. If it is pressed twice, threshold is set. It is used in My_GPIO_PORTF_Handler.		
		MOV R11,#0
;		R8 holds the threshold value
		MOV R8,#50	; DEFAULT THRESHOLD
;		MODE CHECK
		MOV R9,#0
;		R9 = 0	; NORMAL MODE
;		R9 = 1	; PREVENTIVE BRAKING MODE
;		R9 = 2	; THRESHOLD MODE
		
		
START		
		CMP R9,#0
		BEQ	NORMAL_MODE
		CMP R9,#1
		BEQ	PREVENTATIVE_BRAKING_MODE
		CMP R9,#2
		BEQ.W	THRESHOLD_MODE
		
NORMAL_MODE	

		BL	MEASURE_PWM	; Stores result in R0
		MOV		R1, #94 ; 16/0.17	;DISTANCE ARITHMETIC
		UDIV	R0, R0, R1	; MEASUREMENT*(0.17)/16 = DISTANCE
		CMP	R0,#1000	; Assures that measurement stops for values greater than 999mm
		BHI	START
		CMP		R0, R8
		MOVLS	R9,#1		
		BLS PREVENTATIVE_BRAKING_MODE_FIRST
		CMP		R9, #2
		BEQ.W		THRESHOLD_MODE



		BL	CLEAR_SCREEN
		MOV	R4, R0		; NOW R4 HOLDS THE DISTANCE
		
		BL	NORMAL_MODE_OUTPUT	;PRINTING ON THE SCREEN	
		B	START

PREVENTATIVE_BRAKING_MODE	

		B START	; MAIN LOOP
		
PREVENTATIVE_BRAKING_MODE_FIRST	
		BL	PREVENTATIVE_BREAK_MODE_OUTPUT	;PRINTING ON THE SCREEN	
		LDR R1, =TIMER2_CTL ; STOP MOTOR
		LDR R2, [R1]
		BIC R2, R2, #0x03
		STR R2, [R1]
		ALIGN
		LTORG
		LDR R1, =TIMER0_CTL ; STOP DISTANCE MEASUREMENT
		LDR R2, [R1]
		BIC R2, R2, #0x03
		STR R2, [R1]
		ALIGN
		LTORG
		B PREVENTATIVE_BRAKING_MODE

THRESHOLD_MODE
		BL ADC_THRESHOLD	; Go to ADC subroutine
		B START	; MAIN LOOP
		

		ALIGN 
		END