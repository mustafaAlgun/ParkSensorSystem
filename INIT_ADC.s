;ADC initialization is done here.

RCGCADC			EQU		0x400FE638		;ADC clock register
ADC0_ACTSS		EQU		0x40038000		;sample sequencer (ADC0 base adress)
ADC0_RIS		EQU		0x40038004		;interrupt status
ADC0_IM			EQU		0x40038008		;interrupt select
ADC0_EMUX		EQU		0x40038014		;trigger select
ADC0_PSSI		EQU		0x40038028		;initiate sample
ADC0_SSMUX3		EQU		0x400380A0		;input channel select
ADC0_SSCTL3		EQU		0x400380A4		;sample sequence control
ADC0_SSFIFO3	EQU		0x400380A8		;channel 3 results
ADC0_PC			EQU		0x40038FC4		;sample rate
ADC0_ISC		EQU		0x4003800C		
KONTROL			EQU		0x400FEA38	
RCGCGPIO		EQU		0x400FE608		;GPIO clock register
PORTE_DEN		EQU		0x4002451C		;digital enable
PORTE_PCTL		EQU		0x4002452C		;alternate function select
PORTE_AFSEL		EQU		0x40024420		;enable alt functions
PORTE_AMSEL		EQU		0x40024528		;enable analog
; Timer 3 registers
TIMER3_CFG			EQU 0x40033000
TIMER3_TAMR			EQU 0x40033004
TIMER3_CTL			EQU 0x4003300C
TIMER3_IMR			EQU 0x40033018
TIMER3_RIS			EQU 0x4003301C ; Timer Interrupt Status
TIMER3_ICR			EQU 0x40033024 ; Timer Interrupt Clear
TIMER3_TAILR		EQU 0x40033028 ; Timer interval
TIMER3_TAPR			EQU 0x40033038
TIMER3_TBPR			EQU 0x4003303C
TIMER3_TAR			EQU	0x40033048 ; Timer register
TIMER3_AMATCHR		EQU	0x40033030	
;Nested Vector Interrupt Controller registers
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E410 ; IRQ 16 to 19 Priority Register
;
NVIC_EN1			EQU 0xE000E104 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI8			EQU 0xE000E420 ; IRQ 16 to 19 Priority Register
;
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
	
;**************************************************

			AREA	routines, READONLY, CODE
			THUMB
			EXPORT	INIT_ADC		; Make available
				
;**************************************************	

INIT_ADC	PROC
			PUSH 	{LR}	
			PUSH{R0-R12}
			
			LDR R1,=RCGCADC 	; Turn on ADC clock
			LDR R0,[R1]
			ORR R0, R0, #0x01 	; set bit 0 to enable ADC0 clock
			STR R0,[R1]
			
			MOV R12, #30
loop1		SUB R12,#1
			CMP R12, #0
			BNE loop1
			
			NOP
			NOP
			NOP ; Let clock stabilize
			
			LDR R1,=RCGCGPIO 	; Turn on GPIO clock
			LDR R0,[R1]
			ORR R0,R0,#0x10 	; set bit 4 to enable port E clock
			STR R0,[R1]
			NOP
			NOP
			NOP ; Let clock stabilize
			
			; Setup GPIO to make PE3 input for ADC0
			; Enable alternate functions
			LDR R1, =PORTE_AFSEL
			LDR R0, [R1]
			ORR R0, R0, #0x08 ; set bit 3 to enable alt functions on PE3
			STR R0, [R1]
			
			; PCTL does not have to be configured
			; since ADC0 is automatically selected when
			; port pin is set to analog.
			; Disable digital on PE3
			LDR R1, =PORTE_DEN
			LDR R0, [R1]
			BIC R0, R0, #0x08 ; clear bit 3 to disable analog on PE3
			STR R0, [R1]
			; Eanable analog on PE3
			LDR R1, =PORTE_AMSEL
			LDR R0, [R1]
			ORR R0, R0, #0x08 ; set bit 3 to enable analog on PE3
			STR R0, [R1]
			; Disable sequencer while ADC setup
			LDR R1, =ADC0_ACTSS
			LDR R0, [R1]
			BIC R0, R0, #0x08 ; clear bit 3 to disable seq'r 3
			STR R0, [R1]
			; Select trigger source
			LDR R1, =ADC0_EMUX
			LDR R0, [R1]
			BIC R0, R0, #0xF000 ; clear bits 15:12 to select SOFTWARE
			STR R0, [R1] ; trigger
			; Select input channel
			LDR R1, =ADC0_SSMUX3
			LDR R0, [R1]
			BIC R0, R0, #0x000F ; clear bits 3:0 to select AIN0
			STR	R0, [R1]
			; Config sample sequence
			LDR R1, =ADC0_SSCTL3
			LDR R0, [R1]
			ORR R0, R0, #0x06 ; set bits 2:1 (IE0, END0)
			STR R0, [R1]
			; Set sample rate
			LDR R1, =ADC0_PC
			LDR R0, [R1]
			ORR R0, R0, #0x01 ; set bits 3:0 to 1 for 125k sps
			STR R0, [R1]
			
			; Done with setup, enable sequencer
			LDR R1, =ADC0_ACTSS
			LDR R0, [R1]
			ORR R0, R0, #0x08 ; set bit 3 to enable seq 3
			STR R0, [R1] ; sampling enabled but not initiated yet
			; start sampling routine
			; initiate sampling by enabling sequencer 3 in ADC0_PSSI
			
	
			POP{R0-R12}
			POP{LR}
			BX	LR
			ENDP
			END