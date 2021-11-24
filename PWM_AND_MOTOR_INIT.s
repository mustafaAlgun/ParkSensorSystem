;PWM and MOTOR initializations are done here.

;Nested Vector Interrupt Controller registers
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI5			EQU 0xE000E414 ; IRQ 20 to 23 Priority Register
;	
; 16/32 Timer Registers
TIMER0_CFG			EQU 0x40030000
TIMER0_TAMR			EQU 0x40030004
TIMER0_CTL			EQU 0x4003000C
TIMER0_IMR			EQU 0x40030018
TIMER0_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER0_TAILR		EQU 0x40030028 ; Timer interval
TIMER0_TAPR			EQU 0x40030038
TIMER0_TBPR			EQU 0x4003003C
TIMER0_TAR			EQU	0x40030048 ; Timer register
TIMER0_AMATCHR		EQU	0x40030030

; Timer 1 registers
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

; Timer 2 registers
TIMER2_CFG			EQU 0x40032000
TIMER2_TAMR			EQU 0x40032004
TIMER2_CTL			EQU 0x4003200C
TIMER2_IMR			EQU 0x40032018
TIMER2_RIS			EQU 0x4003201C ; Timer Interrupt Status
TIMER2_ICR			EQU 0x40032024 ; Timer Interrupt Clear
TIMER2_TAILR		EQU 0x40032028 ; Timer interval
TIMER2_TAPR			EQU 0x40032038
TIMER2_TBPR			EQU 0x4003203C
TIMER2_TAR			EQU	0x40032048 ; Timer register
TIMER2_AMATCHR		EQU	0x40032030	

	
;GPIO Registers
GPIO_PORTB_DATA			EQU		0x400053FC
GPIO_PORTB_DIR			EQU		0x40005400
GPIO_PORTB_AFSEL		EQU		0x40005420
GPIO_PORTB_DEN			EQU		0x4000551C
GPIO_PORTB_PCTL		 	EQU 	0x4000552C ; Alternate Functions


GPIO_PORTF_DATA		EQU 0x400253FC ; Access BIT2
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_AMSEL 	EQU 0x40025528 ; Analog enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions

;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
;**************************************************

			AREA 	pwm, READONLY, CODE, ALIGN=2
			EXPORT PWM_AND_MOTOR_INIT
			THUMB

;**************************************************

PWM_AND_MOTOR_INIT PROC
			PUSH{LR}
			PUSH{R0-R12}	
;************************************************** 
			;TIMER 0A PORTB
			; Configuration for PORTB6
			LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x02
			STR R0, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			
			LDR R1, =GPIO_PORTB_DIR ;direction 
			LDR R0, [R1]
			ORR	R0, R0, #0x40 ; set bit6 OUTPUT
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTB_AFSEL
			LDR R0, [R1]
			ORR R0, R0, #0x40
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTB_PCTL
			LDR R0, [R1]
			ORR R0, R0, #0x07000000
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTB_DEN ;digital
			LDR R0, [R1]
			ORR R0, R0, #0x40
			STR R0, [R1]
			
;**************************************************
			;TIMER 1A PORTF
			; Configuration for PORTF2
			LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x20
			STR R0, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			
			LDR R1, =GPIO_PORTF_DIR ; set direction of PF2
			LDR R0, [R1]
			BIC R0, R0, #0x04 ; SET INPUT
			ORR	R0, R0, #0x10
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTF_AFSEL
			LDR R0, [R1]
			ORR R0, R0, #0x04
			ORR R0, R0, #0x10
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTF_PCTL
			LDR R0, [R1]
			BIC	R0, R0, #0x00000F00
			ORR R0, R0, #0x00000700
			BIC	R0, R0, #0x000F0000
			ORR R0, R0, #0x00070000
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTF_DEN ; enable port digital
			LDR R0, [R1]
			ORR R0, R0, #0x04
			ORR	R0, R0, #0x10
			STR R0, [R1]

			
;**************************************************
			;TIMER 0A CONFIG
			; Start clock for the timer 0
			LDR R1, =SYSCTL_RCGCTIMER
			LDR R2, [R1]
			ORR R2, R2, #0x01	; Enable clock 1
			STR R2, [R1]
			NOP
			NOP
			NOP
			
			; Disable timer for configuration
			LDR R1, =TIMER0_CTL ; disable timer
			LDR R2, [R1]
			BIC R2, R2, #0x03
			ORR	R2, R2, #0xC	; Both edges
			STR R2, [R1]
			
			; Configure the timer
			LDR R1, =TIMER0_CFG
			MOV R2, #0x04	;16 bit timer
			STR R2, [R1]
			
			LDR R1, =TIMER0_TAMR
			MOV	R2, #0x2	; PWM
			ORR	R2, #0x8
			STR R2, [R1]
			
			LDR		R1, =TIMER0_TAILR
			MOV32 	R2, #10000 
			STR		R2, [R1]
			
			LDR		R1, =TIMER0_AMATCHR
			MOV32 	R2, #1600 
			STR		R2, [R1]
			
			LDR R1, =TIMER0_TAPR	;prescaler
			MOV	R2, #0xFF ; 16MHz/256
			STR R2, [R1]
			
			LDR R1, =TIMER0_IMR	;no interrupt
			MOV R2, #0x00
			STR R2, [R1]

			; Enable timer
			LDR R1, =TIMER0_CTL
			LDR R2, [R1]
			ORR R2, R2, #0x03	;enable
			ORR	R2, R2, #0x40	;inverted
			STR R2, [R1]
			
			
;**************************************************
			;TIMER 1A CONFIG
			
			LDR R1, =SYSCTL_RCGCTIMER	; Start clock
			LDR R2, [R1]
			ORR R2, R2, #0x02
			STR R2, [R1]
			NOP
			NOP
			NOP
			
			LDR R1, =TIMER1_CTL ; disable timer
			LDR R2, [R1]
			BIC R2, R2, #0x03
			STR R2, [R1]
			ORR	R2, R2, #0xC	;Both edges
			STR R2, [R1]

			LDR R1, =TIMER1_CFG
			MOV R2, #0x04	;16bit
			STR R2, [R1]
			
			LDR R1, =TIMER1_TAMR
			MOV R2, #0x17	; Edge time 
			STR R2, [R1]
			
			LDR		R1, =TIMER1_TAILR
			MOV32	R2, #0xFFFF
			STR		R2, [R1]
			
			; Set prescaler
			LDR R1, =TIMER1_TAPR
			MOV R2, #0xFF ;16MHz/256
			STR R2, [R1] 
			
			LDR R1, =TIMER1_IMR
			MOV R2, #0x00	;no interrupt
			STR R2, [R1]

			LDR R1, =TIMER1_CTL
			LDR R2, [R1]
			ORR R2, R2, #0x03	; Enable timer
			STR R2, [R1]

			
;**************************************************
			;TIMER 2A CONFIG
			;Timer Interrupt initialization for MOTOR
					
			LDR R1, =SYSCTL_RCGCTIMER	; Start clock
			LDR R2, [R1]
			ORR R2, R2, #0x04	; Enable clock 2
			STR R2, [R1]
			NOP
			NOP
			NOP
			
			LDR R1, =TIMER2_CTL ; disable timer
			LDR R2, [R1]
			BIC R2, R2, #0x03
			STR R2, [R1]
			
			LDR R1, =TIMER2_CFG
			MOV R2, #0x04	;16 bit
			STR R2, [R1]
			
			LDR R1, =TIMER2_TAMR
			MOV	R2, #0x02	;periodic
			STR R2, [R1]
			
			LDR		R1, =TIMER2_TAILR
			MOV32	R2, #30000			; STEPS ADVANCE IN EVERY 30ms
			STR		R2, [R1]
					
			LDR R1, =TIMER2_TAPR	; prescaler
			MOV	R2, #15 ; divide clock by 16 to get 1us clocks
			STR R2, [R1]
			
			; Timer interrupt
			LDR R1, =TIMER2_IMR
			MOV	r2, #0x01	; Enable interrupt
			STR R2, [R1]
			
			LDR R1, =NVIC_PRI5
			LDR R2, [R1]
			AND R2, R2, #0xFF0FFFFF ; clear interrupt 23 priority
			ORR R2, R2, #0x00A00000 ; set interrupt 23 priority to 5
			STR R2, [R1]
			
			LDR R1, =NVIC_EN0
			MOVT R2, #0x80 ; set bit 23 to enable interrupt 23
			STR R2, [R1]

			; Enable timer
			LDR R1, =TIMER2_CTL
			LDR R2, [R1]
			ORR R2, R2, #0x03	;enable timer
			STR R2, [R1]
			
			POP{R0-R12}
			POP{LR}
			BX	LR
			ENDP