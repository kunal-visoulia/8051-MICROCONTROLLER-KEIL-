;                ( Developed by HIMANSHU BHUSHAN )
;
;***********************************************************************
;              SYSTEM REQUIRMENT FOR PMMS_ASM PANEL
;
;1)RECEIVE/TRANSMITE DATA ON RS-485(HALF DUPLEX)
;2)STORE EVENT INFO ON E2PROM(24C64) 
;3)DISPLY DATA ON LCD(20 X 4)                 
;4)REAL TIME CLOCK(RTC)
;5)FUSE SENCE FUNCTION 
;6)KEYBOARD FUNCTION (8 X 1)
;7)PFC RELAY OPRATION ( TWO RELAY )
;8)DIGITAL I/P SENCE
;***********************************************************************
/*----------------------------------------------------------------------
			P0 Bit Registers
----------------------------------------------------------------------*/
Keypad_Col_Port		equ	P0

sbit P0_0 = 0x80
sbit P0_1 = 0x81
sbit P0_2 = 0x82
sbit P0_3 = 0x83
sbit P0_4 = 0x84
sbit P0_5 = 0x85
sbit P0_6 = 0x86
sbit P0_7 = 0x87
/*----------------------------------------------------------------------
			P1 Bit Registers
----------------------------------------------------------------------*/
sbit LCD_RS = 0x90;
sbit LCD_RW = 0x91;
sbit LCD_ENB = 0x92;
sbit KEY_EN_BIT = 0x93;
sbit LCD_BKL = 0x94;
sbit BUZZER = 0x95;
sbit LED_FLT = 0x96;
sbit LED_CPU = 0x97;
/*----------------------------------------------------------------------
			P2 Bit Registers
----------------------------------------------------------------------*/
sbit PFC_RLY1 = 0xA0
sbit PFC_RLY2 = 0xA1
sbit REMOTE = 0xA2
sbit P2_3 = 0xA3
sbit P2_4 = 0xA4
sbit P2_5 = 0xA5
sbit P2_6 = 0xA6
sbit P2_7 = 0xA7
/*----------------------------------------------------------------------
		P3 Bit Registers (Mnemonics & Ports)
----------------------------------------------------------------------*/
sbit P3_0 = 0xB0
sbit p3_1 = 0xB1
sbit RS_RW = 0xB2
sbit INOUT = 0xB3
sbit RST = 0xB4
sbit SCLK = 0xB5
sbit SDA = 0xB6	
sbit SCL = 0xB7
;***********************************************************************
;		BIT ADDRESSABLE FIELD
;***********************************************************************
sec_flag	equ	20H.0
min_flag	equ	20H.1
TIME_OVR_FLG	EQU	20H.2
VLD_FRM_FLG	EQU	20H.3
FRM_RXD_FLG	EQU	20H.4
Not_Matched_Flag EQU	20H.5
FAULT_FLAG	EQU	20H.6

key_prsd_evt	equ	21h.0
key_dbnc_flag	equ	21h.1
key_updt_evt	equ	21h.2
TIM_GET_FLG	equ	21h.3

ERROR_FLG	equ	22h.0

Key_Temp_Evt0	equ	23h
Key_Finl_Evt0	equ	24h

Key_ACKN	equ	Key_Finl_Evt0.0
Key_CANCL	equ	Key_Finl_Evt0.1
Key_MENU	equ	Key_Finl_Evt0.2
Key_STATUS	equ	Key_Finl_Evt0.3
KEY_ENTER	equ	Key_Finl_Evt0.4
KEY_LIST	equ	Key_Finl_Evt0.5
Key_DOWN	equ	Key_Finl_Evt0.6
Key_UP		equ	Key_Finl_Evt0.7
;************************** BYTE VARIABLES *****************************
tmr_cnt1	equ	30H
tmr_cnt2	equ	31H
TIME_REMAINED	EQU	32H

TX_CNT		EQU	33H
TX_BUFF0	EQU	34H 
TX_BUFF1	EQU	35H
TX_BUFF2	EQU	36H
TX_BUFF3	EQU	37H
TX_BUFF4	EQU	38H
TX_BUFF5	EQU	39H
TX_BUFF6	EQU	3AH
TX_BUFF7	EQU	3BH

RX_BUFF0	EQU	3CH
RX_BUFF1	EQU	3DH
RX_BUFF2	EQU	3EH
RX_BUFF3	EQU	3FH
RX_BUFF4	EQU	40H
RX_BUFF5	EQU	41H
RX_BUFF6	EQU	42H
RX_BUFF7	EQU	43H

Data_E2Prom	EQU	44H
Byte_AddrLo	EQU	45H
Byte_AddrHi	EQU	46H
TIM_ENTERED	EQU	47H
HEX		EQU	48H
DECIMAL		EQU	49H
ASCII_LO	EQU	4AH
ASCII_HI	EQU	4BH
RX_BUFF8	EQU	4CH
RX_BUFF9	EQU	4DH

PTID_HI		EQU	4EH
PTID_MI		EQU	4FH
PTID_LO		EQU	50H

V_POLARITY	EQU	51H
V1_DIGIT	EQU	52H
V2_DIGIT	EQU	53H
V3_DIGIT	EQU	54H
V4_DIGIT	EQU	55H

I_POLARITY	EQU	56H
I1_DIGIT	EQU	57H
I2_DIGIT	EQU	58H
I3_DIGIT	EQU	59H
I4_DIGIT	EQU	5AH

REMOT_STATUS	EQU	5BH
FUSE_STATUS	EQU	5CH
POINT_STATUS	EQU	5DH
XTRA_STATUS	EQU	5EH	;FOR FUTURE USE OR NOT USED
TIMEOUT		EQU	5FH
TIME_OUT	EQU	60H

ERROR_EPROM	EQU	61H
TIME_EPROM	EQU	62H
;************************ CONSTANTS ************************************
#define		device_address	0XA0
#define		PASSWRD_EEPROM	0X00 ;2BYTES	"
#define		PT_ERR_EEPROM	0X0F ;1BYTE(STARTING ADDRAS OR EROR LIST)
#define		PT_TIM_EEPROM	0X1F ;1BYTES (FOR ERROR TIME STORE)
;***********************************************************************
		ORG  	0000H
		LJMP 	START
;***********************************************************************
;              Int 0 Interrupt(NOT USED)
;***********************************************************************
		ORG 	0003H
		RETI		
;***********************************************************************
;              Timer 0 Interrupt
;***********************************************************************
		ORG 	000BH
		LJMP	TIMER0
;***********************************************************************
;               Int 1 Interrupt(NOT USED) 
;***********************************************************************
		ORG 	0013H
		RETI
;***********************************************************************
		ORG 	0023H               
		LJMP	INT_RXD
;***********************************************************************
;               INITIALIZATION   
;***********************************************************************
START: 
		MOV	SP,#80H 
		MOV 	IE,#00H
		mov	PSW,#0x00

		mov     R4,#100
		lcall   ms_delay

		MOV	R0,#0X20
		MOV	R1,#0x40
CLEAR_RAM:
		MOV	A,#0X00
		MOV	@R0,A
		inc	R0
		DJNZ	R1,CLEAR_RAM

		LCALL   INIT_CPU
		LCALL	INIT_LCD
		LCALL	INIT_1380
		LCALL	DISP_INI_MSG
MAIN:
		LCALL	GET_ERR_ADD
		LCALL	GET_TIM_ADD
		LCALL	DISP_SEC_MSG
;***********************************************************************
;			MAIN LOOP
;***********************************************************************
AGAIN:		
		LCALL	MAIN_FLAG
		LCALL	TIMER_RTC
		LCALL	SEND_TIME

		LCALL	FLT_DELAY

		AJMP	AGAIN
;***********************************************************************
; 		 FAULT CHECK AND DISPLAY
;***********************************************************************
FLT_DELAY:
		lcall	init_timer0
		mov	tmr_cnt2,#15
HIM:
		LCALL	KEY_FUNCTION
		LCALL	FAULT_CHECK

		JNB	MIN_FLAG,HIM
		CLR	TR0

		RET
;***********************************************************************
; 		 FAULT CHECK AND CHANGE DISPLAY MASSEGE
;***********************************************************************
FAULT_CHECK:
		JNB	FAULT_FLAG,EXIT_FLT_CHK
		
		SETB	LED_FLT
		SETB	BUZZER
		SETB	PFC_RLY1
		SETB	PFC_RLY2

		mov     dptr,#SEC12_message
		mov     R5,#0C0h
		lcall   dis_message

		mov     dptr,#SEC13_message
		mov     R5,#94h
		lcall   dis_message 

		mov     dptr,#USE_FLT_KEY
		mov     R5,#0D4h
		lcall   dis_message

		LCALL	STORE_ERROR
		LCALL	STOR_TIM_ERROR

		LCALL	SEND_OK

		CLR	FAULT_FLAG
		SETB	ERROR_FLG

		AJMP	AGAIN

EXIT_FLT_CHK:
		RET
;***********************************************************************
; 		   	KEY    FUNCTION
;***********************************************************************
KEY_FUNCTION:
		LCALL	GET_KEY
		JB	Key_ACKN,GET_ACKN
		JB	Key_MENU,GET_MENU
		JB	KEY_LIST,GET_LIST
		JB	KEY_STATUS,GET_STATUS
		mov	Key_Finl_Evt0,#00H

		RET
;***********************************************************************
GET_MENU:
		LCALL	MENU_MODE_FST
		RET
GET_STATUS:
		LCALL	STATUS_MODE
		RET
GET_LIST:
		LCALL	LIST_MODE
		RET
GET_ACKN:
		LCALL	ACK_MODE	
		RET
;***********************************************************************
;		MENU MODE SETTING 
;***********************************************************************
MENU_MODE_FST:	
		CLR	IE.4
		mov	Key_Finl_Evt0,#00H

		LCALL	ASK_PSWD
MENU_MODE:
		mov     dptr,#MENU_KEY_MSG0
		mov     R5,#80h
		lcall   dis_message
		mov     dptr,#MENU_KEY_MSG8
		mov     R5,#94h
		lcall   dis_message
		mov     dptr,#MENU_KEY_MSG9
		mov     R5,#0D4h
		lcall   dis_message
;-----------------------------------------------------------------------
SCREEN1:
		mov     dptr,#MENU_MOD_MSG1
		mov     R5,#0C0h
		lcall   dis_message

		LCALL	GET_KEY
		JNB	KEY_UPDT_EVT,SCREEN1

		JB	KEY_ENTER,CHG_PSWD
		JB	Key_DOWN,SCREEN2
		JB	Key_UP,SCREEN4
		JB	Key_CANCL,CHG_PSW_ZONE_E

		AJMP	SCREEN1
		
CHG_PSWD:
		LJMP	CHANGE_PSWD

CHG_PSW_ZONE_E:	
		LJMP	MAIN
;-----------------------------------------------------------------------
SCREEN2:
		mov     dptr,#MENU_MOD_MSG2
		mov     R5,#0C0h
		lcall   dis_message

		LCALL	GET_KEY
		JNB	KEY_UPDT_EVT,SCREEN2

		JB	KEY_ENTER,CHG_DATE_TIM
		JB	Key_DOWN,SCREEN3
		JB	Key_UP,SCREEN1
		JB	Key_CANCL,CHG_DATE_TIM_E

		AJMP	SCREEN2
		
CHG_DATE_TIM:
		LJMP	CHNG_DATE_TIM

CHG_DATE_TIM_E:	
		LJMP	MAIN
;-----------------------------------------------------------------------
SCREEN3:
		mov     dptr,#MENU_MOD_MSG3
		mov     R5,#0C0h
		lcall   dis_message

		LCALL	GET_KEY
		JNB	KEY_UPDT_EVT,SCREEN3

		JB	KEY_ENTER,DEL_EVENT
		JB	Key_DOWN,SCREEN4
		JB	Key_UP,SCREEN2
		JB	Key_CANCL,DEL_EVENT_E

		AJMP	SCREEN3
		
DEL_EVENT:
		LJMP	DELETE_EVNT

DEL_EVENT_E:	
		LJMP	MAIN
;-----------------------------------------------------------------------
SCREEN4:
		mov     dptr,#MENU_MOD_MSG4
		mov     R5,#0C0h
		lcall   dis_message

		LCALL	GET_KEY
		JNB	KEY_UPDT_EVT,SCREEN4

		JB	KEY_ENTER,PT_SETT
		JB	Key_DOWN,SCREEN1
		JB	Key_UP,SCREEN3
		JB	Key_CANCL,PT_SETT_E

		AJMP	SCREEN4
		
PT_SETT:
		LJMP	POINT_SETTING

PT_SETT_E:	
		LJMP	MAIN
;**********************************************************************
;		NEW PSWD ENTER AND STORE
;**********************************************************************
CHANGE_PSWD:	
		mov     dptr,#NEW_PSWD_MSG0
		mov     R5,#80h
		lcall   dis_message
		mov     dptr,#NEW_PSWD_MSG1
		mov     R5,#0C0h
		lcall   dis_message
		mov     dptr,#NEW_PSWD_MSG2
		mov     R5,#94h
		lcall   dis_message
		MOV	r5,#0D4H
		MOV	DPTR,#USE_FUN_KEY
		Lcall   dis_message

		LCALL	GET_NEW_PSWD
		LCALL	STORE_PASSWORD

		mov     dptr,#OLD_CHG_mess
		mov     R5,#0D4H
		lcall   dis_message
		LCALL	DELAY_2S
		
		LJMP	MENU_MODE
;**********************************************************************
;		SET DATE,TIME,DAY AND STORE
;**********************************************************************
CHNG_DATE_TIM:
		MOV	r5,#80h
		MOV	DPTR,#CURRENT_DATE
		Lcall   dis_message

		MOV	r5,#0C0h
		MOV	DPTR,#CURRENT_DAY
		Lcall   dis_message

		MOV	r5,#94h
		MOV	DPTR,#CURRENT_TIME
		Lcall   dis_message

		MOV	r5,#0D4H
		MOV	DPTR,#USE_FUN_KEY
		Lcall   dis_message

		LCALL	GET_DATE_TIME
		MOV	rx_buff1,rx_buff7
		MOV	rx_buff2,rx_buff8
		MOV	rx_buff3,rx_buff9	
;**********************************************************************
		MOV	r5,#0C0H
		MOV	DPTR,#CURRENT_DAY
		Lcall   dis_message

		MOV	TIM_ENTERED,#0x01	;FOR SUNDAY
WAIT_DAY:	MOV	A,#0C6H
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		LCALL	DISP_HEX

		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_DAY
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_DAY	
		MOV	A,TIM_ENTERED
		LCALL	ASSCI_BCD
		mov	rx_buff6,a
;**********************************************************************
		MOV	r5,#94H
		MOV	DPTR,#CURRENT_TIME
		Lcall   dis_message

		LCALL	GET_DATE1_TIME
		LCALL	STORE_DATE_TIME

		mov     dptr,#OLD_CHG_mess
		mov     R5,#0D4h
		lcall   dis_message
		LCALL	DELAY_2S

		LJMP	MENU_MODE
;***********************************************************************
;		DATA NOT FOUND IN DELELE MODE
;***********************************************************************
JMP_NO_ERR:
		mov     dptr,#ERROR_MODE_MSG
		mov     R5,#80h
		LCALL   DIS_message
	
		mov     dptr,#STAR_ONE_MSG
		mov     R5,#0C0h
		lcall   dis_message

		mov     dptr,#STAR_TWO_MSG
		mov     R5,#94h
		lcall   dis_message	

		mov     dptr,#LIST_LINE_NO
		mov     R5,#0D4h
		LCALL   DIS_message

		LCALL	DELAY_2S
		SETB	IE.4
		
		LJMP	MAIN
;***********************************************************************
;		Routine DELETE ERROR LIST FROM EPROM
;***********************************************************************
DELETE_EVNT:
		CLR	IE.4
		JNB	ERROR_FLG,JMP_NO_ERR

		mov     dptr,#ERROR_MODE_MSG
		mov     R5,#80h
		LCALL   DIS_message

		mov     dptr,#SELE_MODE_MSG
		mov     R5,#0C0h
		LCALL   DIS_message

		mov     dptr,#EROR_DEL_MSG
		mov     R5,#94h
		LCALL   DIS_message

		mov     dptr,#USE_FUN_KEY
		mov     R5,#0D4h
		LCALL   DIS_message
DEL_NO:
		mov     dptr,#NO_MSG
		mov     R5,#0A5h
		LCALL   DIS_message	

		lcall	get_key
		JNB	KEY_UPDT_EVT,DEL_NO
		JB	KEY_UP,DEL_YES
		JB	KEY_ENTER,DEL_EXIT
		JB	KEY_DOWN,DEL_YES
		JB	Key_CANCL,DEL_EXIT
		LJMP	DEL_NO
DEL_YES:
		mov     dptr,#YES_MSG
		mov     R5,#0A5h
		LCALL   DIS_message	

		lcall	get_key
		JNB	KEY_UPDT_EVT,DEL_YES
		JB	KEY_UP,DEL_NO
		JB	KEY_ENTER,DEL_DATA
		JB	KEY_DOWN,DEL_NO
		JB	Key_CANCL,DEL_EXIT
		LJMP	DEL_YES

DEL_DATA:
		mov     dptr,#ERROR_MODE_MSG
		mov     R5,#80h
		LCALL   DIS_message

		mov     dptr,#STAR_ONE_MSG
		mov     R5,#0C0h
		LCALL   DIS_message

		mov     dptr,#STAR_TWO_MSG
		mov     R5,#94h
		LCALL   DIS_message

		mov     dptr,#WAIT_MSG
		mov     R5,#0D4h
		LCALL   DIS_message

		LCALL	EROR_COUNT_CLR

		mov     dptr,#DATA_DELETED
		mov     R5,#0D4h
		LCALL   DIS_message

		LCALL	DELAY_2S
DEL_EXIT:
		SETB	IE.4
		LJMP	MAIN
;**********************************************************************
;		DELETE ALL ERROR LIST FROM EEPROM
;**********************************************************************
EROR_COUNT_CLR:	
		MOV	ERROR_EPROM,#03
DEL_CONTINUE:	
		mov	A,ERROR_EPROM	
		ANL     A,#0FH
		SWAP	A
		ADD     A,#00H		;1
		MOV	Byte_AddrLo,A
		mov	A,ERROR_EPROM
		ANL     A,#0F0H
		SWAP    A
		MOV	Byte_AddrHi,A

		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;2
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;3
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;4
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;5
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;6
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;7
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;8
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;9
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;10
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;11
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;12
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;13
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;14
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;15
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM

		INC	Byte_AddrLo	;16
		MOV	DATA_E2PROM,#0FFH
		LCALL	WR_E2PROM
		
		MOV	A,ERROR_EPROM
		ADD	A,#1
		MOV	ERROR_EPROM,A
		CJNE	A,#0FFH,DEL_JMP

		MOV 	ERROR_EPROM,#03
		LCALL	STORE_ERR_ADD

		MOV 	TIME_EPROM,#04
		LCALL	STORE_TIM_ADD

		CLR	ERROR_FLG
		CLR	LED_FLT
		RET

DEL_JMP:	LJMP	DEL_CONTINUE
;**********************************************************************
;		POINT M/C SETTING
;**********************************************************************
POINT_SETTING:

;		NOT IN USE TEMPRORY

		LJMP	MENU_MODE
;************************************************************************
JMP_NO_LIST:
		mov     dptr,#LIST_MODE_MSG
		mov     R5,#80h
		LCALL   DIS_message

		mov     dptr,#STAR_ONE_MSG
		mov     R5,#0C0h
		lcall   dis_message

		mov     dptr,#STAR_TWO_MSG
		mov     R5,#94h
		lcall   dis_message	

		mov     dptr,#LIST_LINE_NO
		mov     R5,#0D4h
		LCALL   DIS_message

		LCALL	DELAY_2S
		SETB	IE.4

		LJMP	MAIN
;***********************************************************************
;		LIST MODE (DISPLAY ALL ERROR LIST ONE BY ONE)
;***********************************************************************
LIST_MODE:
		CLR	IE.4
		JNB	ERROR_FLG,JMP_NO_LIST

		MOV 	ERROR_EPROM,#03
		MOV 	TIME_EPROM,#04

		mov     dptr,#CLR_LINE_MSG	;FOR TIME
		mov     R5,#80h
		lcall   dis_message
		mov     dptr,#STS_VI_message
		mov     R5,#0C0h
		lcall   dis_message
		mov     dptr,#STA11_message
		mov     R5,#94h
		lcall   dis_message
		MOV	r5,#0D4H
		MOV	DPTR,#FAULT_MSG
		Lcall   dis_message

AGAIN_ERROR:
		mov	A,ERROR_EPROM	     ;; XY
		ANL     A,#0FH               ;; 0Y
		SWAP	A		     ;; Y0
		ADD     A,#00H               ;; Y0
		MOV	Byte_AddrLo,A

		mov	A,ERROR_EPROM	     ;; XY
		ANL     A,#0F0H              ;; X0
		SWAP    A                    ;; 0X
		MOV	Byte_AddrHi,A

		lcall	RD_E2Prom
		mov	V_POLARITY,DATA_E2PROM	;FOR VOLTAGE POLARITY

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	V4_DIGIT,DATA_E2PROM	;FOR VOLTAGE MSB

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	V3_DIGIT,DATA_E2PROM	

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	V2_DIGIT,DATA_E2PROM

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	V1_DIGIT,DATA_E2PROM	;FOR VOLTAGE LSB
;************************************************************************
		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	I_POLARITY,DATA_E2PROM	;FOR CURRENT POLARITY

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	I4_DIGIT,DATA_E2PROM	;FOR CURRENT MSB

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	I3_DIGIT,DATA_E2PROM	

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	I2_DIGIT,DATA_E2PROM

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	I1_DIGIT,DATA_E2PROM	;FOR CURRENT LSB
;************************************************************************
		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	FUSE_STATUS,DATA_E2PROM
;************************************************************************
		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	REMOT_STATUS,DATA_E2PROM
;************************************************************************
		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	POINT_STATUS,DATA_E2PROM
;************************************************************************
		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	XTRA_STATUS,DATA_E2PROM
;************************************************************************
		LCALL	GET_ERR_TIME	;GET ERROR TIME & ID FROM EPROM
;************************************************************************
		MOV	A,V_POLARITY	;CHECK FOR END LIST
		CJNE	A,#0FFH,CONTINUE

		mov     dptr,#LIST_MODE_MSG
		mov     R5,#80h
		LCALL   DIS_message

		mov     dptr,#STAR_ONE_MSG
		mov     R5,#0C0h
		lcall   dis_message

		mov     dptr,#STAR_TWO_MSG
		mov     R5,#94h
		lcall   dis_message	

		mov     dptr,#LIST_END_MSG
		mov     R5,#0D4h
		LCALL   DIS_message

		LCALL	DELAY_2S

		CLR	LED_FLT
		SETB	IE.4
		LJMP	MAIN
;************************************************************************
CONTINUE:
		LCALL	DISP_TIME
		LCALL	DISP_OTHER
CONTI_0:
		LCALL	GET_KEY
		JNB	KEY_UPDT_EVT,CONTI_0

		JB	KEY_UP,UP_ERR
		JB	KEY_DOWN,DN_ERR
		JB	Key_CANCL,EXIT_ERR

		SJMP	CONTI_0	
;************************************************************************
UP_ERR:	
		MOV	A,ERROR_EPROM		;FOR INC ERROR COUNT	
		ADD	A,#02
		MOV	ERROR_EPROM,A

		CJNE	A,#0FEH,AGAIN_WK

		MOV	ERROR_EPROM,#03
AGAIN_WK:
		MOV	A,TIME_EPROM		;FOR INC TIME COUNT	
		ADD	A,#02
		MOV	TIME_EPROM,A

		CJNE	A,#0FFH,AGAIN_TIME

		MOV	TIME_EPROM,#04
AGAIN_TIME:
		LJMP	AGAIN_ERROR
;************************************************************************
DN_ERR:		
		MOV	A,ERROR_EPROM	;FOR DEC ERROR COUNT	
		DEC	A
		DEC	A
		MOV	ERROR_EPROM,A
		CJNE	A,#01,AGAIN_DN

		MOV	ERROR_EPROM,#03
AGAIN_DN:
		MOV	A,TIME_EPROM	;FOR DEC TIME COUNT	
		DEC	A
		DEC	A
		MOV	TIME_EPROM,A
		CJNE	A,#02,AGAIN_DN_CONT

		MOV	TIME_EPROM,#04
AGAIN_DN_CONT:

		LJMP	AGAIN_ERROR
;************************************************************************		
EXIT_ERR:	
		CLR	LED_FLT
		SETB	IE.4
		LJMP	MAIN
;************************************************************************
;		READ ERROR TIME STORED IN EPROM
;************************************************************************
GET_ERR_TIME:
		mov	A,TIME_EPROM	     ;; XY
		ANL     A,#0FH               ;; 0Y
		SWAP	A		     ;; Y0
		ADD     A,#00H               ;; Y0
		MOV	Byte_AddrLo,A

		mov	A,TIME_EPROM	     ;; XY
		ANL     A,#0F0H              ;; X0
		SWAP    A                    ;; 0X
		MOV	Byte_AddrHi,A

		lcall	RD_E2Prom
		mov	TX_BUFF1,DATA_E2PROM	;FOR DATE BCD

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	TX_BUFF2,DATA_E2PROM	;FOR MONTH BCD

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	TX_BUFF3,DATA_E2PROM	;FOR YEAR BCD	

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	TX_BUFF4,DATA_E2PROM	;FOR HOUR BCD	

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	TX_BUFF5,DATA_E2PROM	;FOR MINT BCD

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	TX_BUFF6,DATA_E2PROM	;FOR SEC BCD

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	TX_BUFF7,DATA_E2PROM	;FOR DAY BCD

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	PTID_HI,DATA_E2PROM	;FOR ID HI	

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	PTID_MI,DATA_E2PROM	;FOR ID MI

		inc	Byte_AddrLo
		lcall	RD_E2Prom
		mov	PTID_LO,DATA_E2PROM	;FOR ID LO

		RET
;***********************************************************************
;	DISPLAY VOLTAGE & CURRENT & OTER INFO READED FROM EPROM
;***********************************************************************
DISP_OTHER:
		MOV	A,#0XE3
		LCALL	PUT_LCD_DATA
	
		MOV	A,PTID_HI
		LCALL	disp_hex
		MOV	A,PTID_MI
		LCALL	disp_hex
		MOV	A,PTID_LO
		LCALL	HEX_ASCII_1
;-----------------------------------------------------
		mov     dptr,#STS_VI_message
		mov     R5,#0C0h
		lcall   dis_message

		MOV	A,#0C2H
		LCALL	put_lcd_data

		MOV	A,V_POLARITY
		LCALL	WR_message
		MOV	A,V4_DIGIT
		LCALL	WR_message
		MOV	A,V3_DIGIT
		LCALL	WR_message
		MOV	A,V2_DIGIT
		LCALL	WR_message
		MOV	A,#'.'
		LCALL	WR_message
		MOV	A,V1_DIGIT
		LCALL	WR_message
;-----------------------------------------------------
		MOV	A,#0CDH
		LCALL	put_lcd_data

		MOV	A,I_POLARITY
		LCALL	WR_message
		MOV	A,I4_DIGIT
		LCALL	WR_message
		MOV	A,I3_DIGIT
		LCALL	WR_message
		MOV	A,#'.'
		LCALL	WR_message
		MOV	A,I2_DIGIT
		LCALL	WR_message
		MOV	A,I1_DIGIT
		LCALL	WR_message
;-----------------------------------------------------
		mov     dptr,#STA11_message
		mov     R5,#94h
		lcall   dis_message

		MOV	A,FUSE_STATUS
		CJNE	A,#00H,F_DISP10

		mov     dptr,#FUSE_OK_mesg
		mov     R5,#94h
		lcall   dis_message
		
		SJMP	DI_STATUS_1
F_DISP10:
		MOV	A,FUSE_STATUS
		CJNE	A,#01H,F_DISP20

		mov     dptr,#MAIN_BL_mesg
		mov     R5,#94h
		lcall   dis_message
		
		SJMP	DI_STATUS_1
F_DISP20:
		MOV	A,FUSE_STATUS
		CJNE	A,#10H,F_DISP30

		mov     dptr,#STBY_BL_mesg
		mov     R5,#94h
		lcall   dis_message
		
		SJMP	DI_STATUS_1
F_DISP30:
		MOV	A,FUSE_STATUS
		CJNE	A,#03H,DI_STATUS_1

		mov     dptr,#BOTH_BL_mesg
		mov     R5,#94h
		lcall   dis_message
		
		SJMP	DI_STATUS_1
;-----------------------------------------------------
DI_STATUS_1:
		MOV	A,REMOT_STATUS
		CJNE	A,#00H,DI_DISP10

		mov     dptr,#RET_OK_mesg
		mov     R5,#9Dh
		lcall   dis_message
		
		SJMP	PM_STATUS_1
DI_DISP10:
		MOV	A,REMOT_STATUS
		CJNE	A,#01H,PM_STATUS_1

		mov     dptr,#RET_FL_mesg
		mov     R5,#9Dh
		lcall   dis_message
		
		SJMP	PM_STATUS_1
;-----------------------------------------------------
PM_STATUS_1:
		MOV	A,POINT_STATUS
		CJNE	A,#00H,PM_DISP10

		mov     dptr,#PM_OK_mesg
		mov     R5,#0A3h
		lcall   dis_message
		
		RET
PM_DISP10:
		MOV	A,POINT_STATUS
		CJNE	A,#01H,PM_EXT_1

		mov     dptr,#PM_FL_mesg
		mov     R5,#0A3h
		lcall   dis_message
PM_EXT_1:		
		RET
;**********************************************************************
;		STATUS KEY FUNCTION
;**********************************************************************
STATUS_MODE:	CLR	IE.4
		
		mov     dptr,#STATUS_messag
		mov     R5,#80h
		lcall   dis_message
		mov     dptr,#MENU_KEY_MSG8
		mov     R5,#94h
		lcall   dis_message
		mov     dptr,#MENU_KEY_MSG9
		mov     R5,#0D4h
		lcall   dis_message
;-----------------------------------------------------------------------
SCRN1:
		mov     dptr,#STATUS_CURRE
		mov     R5,#0C0h
		lcall   dis_message

		LCALL	GET_KEY
		JNB	KEY_UPDT_EVT,SCRN1

		JB	KEY_ENTER,STATS_CRNT
		JB	Key_DOWN,SCRN2
		JB	Key_UP,SCRN2
		JB	Key_CANCL,STS_EXT0

		AJMP	SCRN1
		
STATS_CRNT:
		LJMP	CURRNT_STATS

STS_EXT0:	
		LJMP	MAIN
;-----------------------------------------------------------------------
SCRN2:
		mov     dptr,#STATS_ACTIVE
		mov     R5,#0C0h
		lcall   dis_message

		LCALL	GET_KEY
		JNB	KEY_UPDT_EVT,SCRN2

		JB	KEY_ENTER,STATS_ACTIV
		JB	Key_DOWN,SCRN1
		JB	Key_UP,SCRN1
		JB	Key_CANCL,STS_EXT1

		AJMP	SCRN2
		
STATS_ACTIV:
		LJMP	ACTIVE_STATS	

STS_EXT1:	
		LJMP	MAIN
;-----------------------------------------------------------------------
;		CURRENT STATUS
;-----------------------------------------------------------------------
CURRNT_STATS:
		mov     dptr,#STATUS_messag
		mov     R5,#80h
		lcall   dis_message
		mov     dptr,#STAT_CUR_MSG
		mov     R5,#0C0h
		lcall   dis_message
		mov     dptr,#STAT_ID_MSG
		mov     R5,#94h
		lcall   dis_message
		mov     dptr,#USE_FUN_KEY
		mov     R5,#0D4h
		lcall   dis_message

		LCALL	GET_ID_NAME
;------------------------------------------------------------------------
		mov	Tx_buff0,#'S'
		MOV	Tx_buff1,#'N'
		mov	Tx_buff2,#'I'
		MOV	Tx_buff3,#'D'
		MOV	Tx_buff4,PTID_HI
		MOV	Tx_buff5,PTID_MI
		MOV	Tx_buff6,PTID_LO
		mov	Tx_buff7,#' '

		MOV	TX_CNT,#08H
		LCALL	TX_FRAME

		LCALL	RXD_DATA

		mov     dptr,#STS_CT_ID_MSG
		mov     R5,#80h
		lcall   dis_message

		LCALL	DISP_DATA_RXD

		LCALL	SEND_OK
SCRN_CNT:
		LCALL	GET_KEY
		JNB	KEY_UPDT_EVT,SCRN_CNT
		JB	KEY_STATUS,CNT_STATS
		JB	Key_CANCL,CNT_EXT

		AJMP	SCRN_CNT

CNT_STATS:
		AJMP	STATUS_MODE

CNT_EXT:
		LJMP	MAIN
;-----------------------------------------------------------------------
;		ACTIVE STATUS
;-----------------------------------------------------------------------
ACTIVE_STATS:
		mov     dptr,#STATUS_messag
		mov     R5,#80h
		lcall   dis_message
		mov     dptr,#STAT_ACT_MSG
		mov     R5,#0C0h
		lcall   dis_message
		mov     dptr,#STAT_ID_MSG
		mov     R5,#94h
		lcall   dis_message
		mov     dptr,#USE_FUN_KEY
		mov     R5,#0D4h
		lcall   dis_message

		LCALL	GET_ID_NAME
;------------------------------------------------------------------------
		mov	Tx_buff0,#'S'
		MOV	Tx_buff1,#'M'
		mov	Tx_buff2,#'I'
		MOV	Tx_buff3,#'D'
		MOV	Tx_buff4,PTID_HI
		MOV	Tx_buff5,PTID_MI
		MOV	Tx_buff6,PTID_LO
		mov	Tx_buff7,#' '

		MOV	TX_CNT,#08H
		LCALL	TX_FRAME

		LCALL	RXD_DATA

		mov     dptr,#STS_AT_ID_MSG
		mov     R5,#80h
		lcall   dis_message

		LCALL	DISP_DATA_RXD

		LCALL	SEND_OK
SCRN_ACT:
		LCALL	GET_KEY
		JNB	KEY_UPDT_EVT,SCRN_ACT
		JB	KEY_STATUS,ACT_STATS
		JB	Key_CANCL,ACT_EXT

		AJMP	SCRN_ACT

ACT_STATS:
		AJMP	STATUS_MODE

ACT_EXT:
		LJMP	MAIN
;***********************************************************************
;		BUZZER ACKNOLAGEMENT CHECK
;***********************************************************************
ACK_MODE:
		CLR	BUZZER
		RET
;***********************************************************************
;		DISPLAY (PRINT ON LCD)
;***********************************************************************
FST01_message:	DB  " ADVANCE GREENPOWER ",0
FST02_message:	DB  "TECHNOLOGIES PVT.LTD",0
FST03_message:	DB  "ENQ.=>+91-9212811400",0
FST04_message:	DB  "ASM/SM PANEL OF PMMS",0

SEC11_message:	DB  "DD-MM-YY  HH:MM  DAY",0
SEC12_message:	DB  "POINT M/C MONITORING",0
SEC13_message:	DB  "SYSTEM BY AGT P.LTD.",0
SEC14_message:	DB  "USE STATUS/LIST/MENU",0

STATUS_messag:	DB  "    STATUS MODE     ",0
STATUS_CURRE:	DB  "1>CURRENT STATUS    ",0
STATS_ACTIVE:	DB  "2>ACTIVE STATUS     ",0

STAT_CUR_MSG:	DB  "   CUERRENT STATUS  ",0
STAT_ID_MSG:	DB  "ENTER PM ID=>0000X  ",0
STAT_ACT_MSG:	DB  "   ACTIVE STATUS    ",0

STS_CT_ID_MSG:	DB  "CRNT STATUS ID:0000X",0
STS_AT_ID_MSG:	DB  "ACTV STATUS ID:0000X",0
STS_VI_message:	DB  "V=+000.0V  I=+00.00A",0
STA11_message:	DB  "FUSE-OK  DI-OK PM-OK",0
FAULT_MSG:	DB  "FAULT >>>>> ID:0000X",0

LIST_LINE_NO:	DB  " * DATA NOT FOUND * ",0
LIST_MODE_MSG:	DB  "     LIST  MODE     ",0
STAR_ONE_MSG:	DB  " * * * * * * * * *  ",0
STAR_TWO_MSG:	DB  "* * * * * * * * * * ",0
LIST_END_MSG:	DB  "  *  END OF LIST  * ",0
CLR_LINE_MSG:	DB  "                    ",0

ERROR_MODE_MSG:	DB  "     DELETE MODE    ",0
SELE_MODE_MSG:	DB  "  SELECT YES OR NO  ",0
EROR_DEL_MSG:	DB  "DELETE ALL DATA=>YES",0
WAIT_MSG:	DB  " * * PLESE WAIT * * ",0
DATA_DELETED:	DB  "* ALL DATA DELETED *",0
NO_MSG	:	DB  "NO ",0
YES_MSG	:	DB  "YES",0

FUSE_OK_mesg:	DB  "FUSE-OK",0
MAIN_BL_mesg:	DB  "MAIN-BL",0
STBY_BL_mesg:	DB  "STBY-BL",0
BOTH_BL_mesg:	DB  "BOTH-OK",0
RET_OK_mesg:	DB  "DI-OK",0
RET_FL_mesg:	DB  "DI-ER",0
PM_OK_mesg:	DB  "PM-OK",0
PM_FL_mesg:	DB  "OBSTR",0

PASSWD_MSG0:	DB  "TO SEE THIS MENU KEY",0
PASSWD_MSG1:	DB  "   ENTER PASSWORD   ",0
PASSWD_MSG2:	DB  "ENTER PSWD=>XXXX    ",0
USE_FUN_KEY:	DB  "USE OK,UP,DN,CAN KEY",0

PSW_NOT_MCHD:	DB  "PASSWORD NOT MACHED ",0
DATA_NAV:	DB  "DATA NOT RXD BY UNIT",0
USE_STS_KEY:	DB  "USE STATUS/CANCL KEY",0
USE_FLT_KEY:	DB  "FAULT >>>>PRESS LIST",0

MENU_KEY_MSG0:	DB  "      MENU MODE     ",0
MENU_MOD_MSG1:	DB  "1>CHANGE PASSWORD   ",0
MENU_MOD_MSG2:	DB  "2>SET DATE & TIME   ",0
MENU_MOD_MSG3:	DB  "3>DELETE EVENT LIST ",0
MENU_MOD_MSG4:	DB  "4>SET P.M/C SETTING ",0

MENU_KEY_MSG8:	DB  "TO SCROLL,SELECT,EXT",0
MENU_KEY_MSG9:	DB  "USE OK,UP,DN,CAN KEY",0

NEW_PSWD_MSG0:	DB  "      MENU MODE     ",0
NEW_PSWD_MSG1:	DB  "  CHANGE PASSWORD   ",0
NEW_PSWD_MSG2:	DB  "ENTER PSWD=>XXXX    ",0
OLD_CHG_mess:	DB  "    CHANGES DONE    ",0

CURRENT_DATE:	DB  "DATE=>DD-MM-YY      ",0
CURRENT_DAY:	DB  "DAY =>01 FOR SUNDAY ",0
CURRENT_TIME:	DB  "TIME=>HR:MN:SC      ",0

SUN_message:	DB  "SUN",0
MON_message:	DB  "MON",0
TUE_message:	DB  "TUE",0
WED_message:	DB  "WED",0
THU_message:	DB  "THU",0
FRI_message:	DB  "FRI",0
SAT_message:	DB  "SAT",0
;**********************************************************************
;	DISPLAY ALL RECEIVED DATA ON LCD
;**********************************************************************
DISP_DATA_RXD:
		mov     dptr,#STS_VI_message
		mov     R5,#0C0h
		lcall   dis_message
		mov     dptr,#STA11_message
		mov     R5,#94h
		lcall   dis_message
		mov     dptr,#USE_STS_KEY
		mov     R5,#0D4h
		lcall   dis_message
;-----------------------------------------------------
		MOV	A,#8FH
		LCALL	put_lcd_data

		MOV	A,PTID_HI
		LCALL	disp_hex
		MOV	A,PTID_MI
		LCALL	disp_hex
		MOV	A,PTID_LO
		LCALL	HEX_ASCII_1
;-----------------------------------------------------
		MOV	A,#0C2H
		LCALL	put_lcd_data

		MOV	A,V_POLARITY
		LCALL	WR_message
		MOV	A,V4_DIGIT
		LCALL	WR_message
		MOV	A,V3_DIGIT
		LCALL	WR_message
		MOV	A,V2_DIGIT
		LCALL	WR_message
		MOV	A,#'.'
		LCALL	WR_message
		MOV	A,V1_DIGIT
		LCALL	WR_message
;-----------------------------------------------------
		MOV	A,#0CDH
		LCALL	put_lcd_data

		MOV	A,I_POLARITY
		LCALL	WR_message
		MOV	A,I4_DIGIT
		LCALL	WR_message
		MOV	A,I3_DIGIT
		LCALL	WR_message
		MOV	A,#'.'
		LCALL	WR_message
		MOV	A,I2_DIGIT
		LCALL	WR_message
		MOV	A,I1_DIGIT
		LCALL	WR_message
;-----------------------------------------------------
		MOV	A,FUSE_STATUS
		CJNE	A,#00H,F_DISP1

		mov     dptr,#FUSE_OK_mesg
		mov     R5,#94h
		lcall   dis_message
		
		SJMP	DI_STATUS
F_DISP1:
		MOV	A,FUSE_STATUS
		CJNE	A,#01H,F_DISP2

		mov     dptr,#MAIN_BL_mesg
		mov     R5,#94h
		lcall   dis_message
		
		SJMP	DI_STATUS
F_DISP2:
		MOV	A,FUSE_STATUS
		CJNE	A,#10H,F_DISP3

		mov     dptr,#STBY_BL_mesg
		mov     R5,#94h
		lcall   dis_message
		
		SJMP	DI_STATUS
F_DISP3:
		MOV	A,FUSE_STATUS
		CJNE	A,#03H,DI_STATUS

		mov     dptr,#BOTH_BL_mesg
		mov     R5,#94h
		lcall   dis_message
		
		SJMP	DI_STATUS
;-----------------------------------------------------
DI_STATUS:
		MOV	A,REMOT_STATUS
		CJNE	A,#00H,DI_DISP1

		mov     dptr,#RET_OK_mesg
		mov     R5,#9Dh
		lcall   dis_message
		
		SJMP	PM_STATUS
DI_DISP1:
		MOV	A,REMOT_STATUS
		CJNE	A,#01H,PM_STATUS

		mov     dptr,#RET_FL_mesg
		mov     R5,#9Dh
		lcall   dis_message
		
		SJMP	PM_STATUS
;-----------------------------------------------------
PM_STATUS:
		MOV	A,POINT_STATUS
		CJNE	A,#00H,PM_DISP1

		mov     dptr,#PM_OK_mesg
		mov     R5,#0A3h
		lcall   dis_message
		
		RET
PM_DISP1:
		MOV	A,POINT_STATUS
		CJNE	A,#01H,PM_EXT

		mov     dptr,#PM_FL_mesg
		mov     R5,#0A3h
		lcall   dis_message
PM_EXT:		
		RET
;**********************************************************************
;	RECEIVE ALL STATUS PACKET FROM ASKED NODES
;**********************************************************************
RXD_DATA:
		LCALL	WAIT_RXD
		JB	TIMEOUT,EXIT_WAIT
		MOV	A,rx_buff0
		CJNE	A,#'I',RXD_DATA
		LCALL	COPY_ID
RXD_DATA_V:
		LCALL	WAIT_RXD
		JB	TIMEOUT,EXIT_WAIT
		MOV	A,rx_buff0
		CJNE	A,#'V',RXD_DATA_V
		LCALL	COPY_VOLTS
RXD_DATA_I:
		LCALL	WAIT_RXD
		JB	TIMEOUT,EXIT_WAIT
		MOV	A,rx_buff0
		CJNE	A,#'I',RXD_DATA_I
		LCALL	COPY_AMPS
RXD_DATA_F:
		LCALL	WAIT_RXD
		JB	TIMEOUT,EXIT_WAIT
		MOV	A,rx_buff0
		CJNE	A,#'F',RXD_DATA_F
		LCALL	COPY_STATUS
WAIT_DATA_E:
		LCALL	WAIT_RXD
		JB	TIMEOUT,EXIT_WAIT
		MOV	A,rx_buff0
		CJNE	A,#'E',WAIT_DATA_E

		RET

EXIT_WAIT:
		LJMP	EXIT_WAIT_RXD
;**********************************************************************
;	    STORE FAULT (RAM) ID RECEIVED BY NODES
;**********************************************************************
STOR_FLT_ID:
		LCALL	COPY_ID
		RET	
STORE_FLT_VOLT:
		LCALL	COPY_VOLTS
		RET
STORE_FLT_AMP:
		LCALL	COPY_AMPS
		RET
STORE_FLT_STAS:
		LCALL	COPY_STATUS
		SETB	FAULT_FLAG
		RET
;**********************************************************************
;		COPY RXD DATA TO RAM
;**********************************************************************
COPY_ID:
		MOV	PTID_HI,Rx_buff3
		MOV	PTID_MI,Rx_buff4
		MOV	PTID_LO,Rx_buff5
		RET
COPY_VOLTS:
		MOV	V_POLARITY,Rx_buff1
		MOV	V4_DIGIT,Rx_buff2
		MOV	V3_DIGIT,Rx_buff3
		MOV	V2_DIGIT,Rx_buff4
		MOV	V1_DIGIT,Rx_buff6
		RET
COPY_AMPS:
		MOV	I_POLARITY,Rx_buff1
		MOV	I4_DIGIT,Rx_buff2
		MOV	I3_DIGIT,Rx_buff3
		MOV	I2_DIGIT,Rx_buff5
		MOV	I1_DIGIT,Rx_buff6
		RET

COPY_STATUS:
		MOV	FUSE_STATUS,Rx_buff1
		MOV	REMOT_STATUS,Rx_buff3
		MOV	POINT_STATUS,Rx_buff5
		MOV	XTRA_STATUS,Rx_buff7	;NOT USED
		RET
;**********************************************************************
;		SEND OK PACKET TO ALL NODES
;**********************************************************************
SEND_OK:
		mov	Tx_buff0,#'O'
		MOV	Tx_buff1,#'K'
		mov	Tx_buff2,#'O'
		MOV	Tx_buff3,#'K'
		MOV	Tx_buff4,#'O'
		MOV	Tx_buff5,#'K'
		MOV	Tx_buff6,#'O'
		mov	Tx_buff7,#'K'

		MOV	TX_CNT,#08H
		LCALL	TX_FRAME

		RET
;***********************************************************************
;			EXIT RXD
;***********************************************************************
EXIT_WAIT_RXD:	
		mov     dptr,#DATA_NAV
		mov     R5,#0D4h
		lcall   dis_message

		LCALL	DELAY_4S
		LCALL	SEND_OK		

		LJMP	STATUS_MODE
;***********************************************************************
;		WAIT FOR RECEIVE DATA OR TIMEOUT
;***********************************************************************
WAIT_RXD:
		CLR	TIMEOUT
		MOV	TIME_OUT,#200
WAIT_RXD2:
		MOV	A,#255
WAIT_RXD1:
	        mov	r3,#70
JMP_00:        	nop
		nop
		djnz	r3,JMP_00

		JB	FRM_RXD_FLG,EXIT_WAIT_RX0
		DEC	A					
		CJNE	A,#00,WAIT_RXD1

		MOV	A,TIME_OUT
		DEC	A
		MOV	TIME_OUT,A
		CJNE	A,#00H,WAIT_RXD2
		SETB	TIMEOUT
EXIT_WAIT_RX0:	
		CLR	FRM_RXD_FLG	
		RET
;**********************************************************************
;		GET POIND ID NAME BY USING KEYS
;**********************************************************************
GET_ID_NAME:		
		MOV	TIM_ENTERED,#0x00
		MOV	A,#0XA1
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		LCALL	DISP_HEX
WAIT_PT_ID0:
		MOV	A,#0XA1
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		lcall	DISP_HEX

		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_PT_ID0
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_PT_ID0	
		MOV	A,TIM_ENTERED
		mov	PTID_HI,A

		MOV	TIM_ENTERED,#0x00
WAIT_PT_ID1:	
		MOV	A,#0XA3
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		lcall	disp_hex
		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_PT_ID1
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_PT_ID1	
		MOV	A,TIM_ENTERED
		mov	PTID_MI,A

WAIT_PT_ID2:	
		MOV	PTID_LO,#' '
		MOV	A,#0XA5	
		LCALL	put_lcd_data
		MOV	A,PTID_LO
		LCALL	WR_message

		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_PT_ID2
		JB	KEY_UP,PRINT_A
		JB	Key_CANCL,EXIT_ID_TEMP
		LJMP	WAIT_PT_ID2

PRINT_A:	MOV	PTID_LO,#'A'
		MOV	A,#0XA5
		LCALL	put_lcd_data
		MOV	A,PTID_LO
		LCALL	WR_message	

		lcall	get_key
		JNB	KEY_UPDT_EVT,PRINT_A
		JB	KEY_UP,PRINT_B
		JB	KEY_DOWN,PRINT_F_TEM
		JB	KEY_ENTER,ALFA_ID_OK_T
		JB	Key_CANCL,EXIT_ID_TEMP
		LJMP	PRINT_A

PRINT_B:	MOV	PTID_LO,#'B'
		MOV	A,#0XA5
		LCALL	put_lcd_data
		MOV	A,PTID_LO
		LCALL	WR_message	

		lcall	get_key
		JNB	KEY_UPDT_EVT,PRINT_B
		JB	KEY_UP,PRINT_C
		JB	KEY_ENTER,ALFA_ID_OK_T
		JB	Key_CANCL,EXIT_ID_TEMP
		LJMP	PRINT_B
;----------------------------------------
EXIT_ID_TEMP:	LJMP	EXIT_CHNG_ID
PRINT_F_TEM:	LJMP	PRINT_F
ALFA_ID_OK_T:	LJMP	ALFA_ID_OK
PRINT_A_TEM:	LJMP	PRINT_A
;----------------------------------------
PRINT_C:	MOV	PTID_LO,#'C'
		MOV	A,#0XA5
		LCALL	put_lcd_data
		MOV	A,PTID_LO
		LCALL	WR_message	

		lcall	get_key
		JNB	KEY_UPDT_EVT,PRINT_C
		JB	KEY_UP,PRINT_D
		JB	KEY_ENTER,ALFA_ID_OK
		JB	Key_CANCL,EXIT_CHNG_ID
		LJMP	PRINT_C

PRINT_D:	MOV	PTID_LO,#'D'
		MOV	A,#0XA5
		LCALL	put_lcd_data
		MOV	A,PTID_LO
		LCALL	WR_message	

		lcall	get_key
		JNB	KEY_UPDT_EVT,PRINT_D
		JB	KEY_UP,PRINT_E
		JB	KEY_ENTER,ALFA_ID_OK
		JB	Key_CANCL,EXIT_CHNG_ID
		LJMP	PRINT_D

PRINT_E:	MOV	PTID_LO,#'E'
		MOV	A,#0XA5
		LCALL	put_lcd_data
		MOV	A,PTID_LO
		LCALL	WR_message

		lcall	get_key
		JNB	KEY_UPDT_EVT,PRINT_E
		JB	KEY_UP,PRINT_F
		JB	KEY_ENTER,ALFA_ID_OK
		JB	Key_CANCL,EXIT_CHNG_ID
		LJMP	PRINT_E

PRINT_F:	MOV	PTID_LO,#'F'
		MOV	A,#0XA5
		LCALL	put_lcd_data
		MOV	A,PTID_LO
		LCALL	WR_message	

		lcall	get_key
		JNB	KEY_UPDT_EVT,PRINT_F
		JB	KEY_UP,PRINT_A_TEM
		JB	KEY_ENTER,ALFA_ID_OK
		JB	Key_CANCL,EXIT_CHNG_ID
		LJMP	PRINT_F

ALFA_ID_OK:	NOP	;CONTINUE.
		RET		

EXIT_CHNG_ID:
		LJMP	MAIN
;**********************************************************************
;		GET DATE TIME I/P FROM KEY AND DISP ON LCD
;**********************************************************************
GET_DATE_TIME:	
		MOV	TIM_ENTERED,#0x00
WAIT_DATA0:	MOV	A,#0X86
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		LCALL	DISP_HEX

		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_DATA0
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_DATA0	
		MOV	A,TIM_ENTERED
		LCALL	ASSCI_BCD
		mov	rx_buff7,a		

		MOV	TIM_ENTERED,#0x00
WAIT_DATA1:	
		MOV	A,#0X89
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		lcall	disp_hex
		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_DATA1
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_DATA1	
		MOV	A,TIM_ENTERED
		LCALL	ASSCI_BCD
		mov	rx_buff8,a

		MOV	TIM_ENTERED,#0x00
WAIT_DATA2:	
		MOV	A,#0X8C
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		lcall	disp_hex
		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_DATA2
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_DATA2	
		MOV	A,TIM_ENTERED
		LCALL	ASSCI_BCD
		mov	rx_buff9,a

		RET
;**********************************************************************
GET_DATE1_TIME:	
		MOV	TIM_ENTERED,#0x00
WAIT_DATA10:	MOV	A,#9AH
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		LCALL	DISP_HEX

		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_DATA10
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_DATA10	
		MOV	A,TIM_ENTERED
		LCALL	ASSCI_BCD
		mov	rx_buff7,a		

		MOV	TIM_ENTERED,#0x00
WAIT_DATA11:	
		MOV	A,#9DH
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		lcall	disp_hex
		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_DATA11
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_DATA11	
		MOV	A,TIM_ENTERED
		LCALL	ASSCI_BCD
		mov	rx_buff8,a

		MOV	TIM_ENTERED,#0x00
WAIT_DATA12:	
		MOV	A,#0A0H
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		lcall	disp_hex
		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_DATA12
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_DATA12	
		MOV	A,TIM_ENTERED
		LCALL	ASSCI_BCD
		mov	rx_buff9,a

		RET
;**********************************************************************
ASSCI_BCD:	MOV	A,ASCII_HI
		ANL	A,#0FH
		MOV	ASCII_HI,A
		MOV	A,ASCII_LO
		ANL	A,#0FH
		MOV	ASCII_LO,A
		MOV	A,ASCII_HI
		SWAP	A
		ORL	A,ASCII_LO
		RET
;**********************************************************************
STORE_DATE_TIME:		
		SETB   	RST           ;setb  reset_1380
                mov    	a,#0BEH       ;Write Protect Byte 
                lcall  	Proc_1380
                
		MOV    	a,RX_BUFF9    ;Write SECOND
                lcall  	Proc_1380
                mov    	a,RX_BUFF8    ;Write MINUIT
                lcall  	Proc_1380
                mov    	a,RX_BUFF7    ;Write HOUR
                lcall  	Proc_1380
	        
		MOV    	a,RX_BUFF1    ;Write date
                lcall  	Proc_1380
                mov    	a,RX_BUFF2    ;Write month
                lcall  	Proc_1380

                mov    	a,RX_BUFF6   ;Write day    
                lcall  	Proc_1380

		mov    	a,RX_BUFF3    ;Write year
                lcall  	Proc_1380

        	mov    	a,#01h        ;Write CONTROL    
                lcall  	Proc_1380
		
		CLR    	RST          ;clr reset
                ret
;***********************************************************************
;		GET & CHECK PASWORD
;***********************************************************************
ASK_PSWD:
		lcall	get_password 
		LCALL	Check_Password
		JNB	Not_Matched_Flag,PSWRD_MCHD

		LJMP	PSWRD_NOT_MCHD

PSWRD_MCHD:	RET
;***********************************************************************
;	Routine Gets Password from KEYPAD and stores in eeprom
;***********************************************************************
GET_PASSWORD:
		SETB	IE.7
		clr   	ie.4
	
		mov     dptr,#PASSWD_MSG0
		mov     R5,#80h
		lcall   dis_message
		mov     dptr,#PASSWD_MSG1
		mov     R5,#0C0h
		lcall   dis_message
		mov     dptr,#PASSWD_MSG2
		mov     R5,#94h
		lcall   dis_message
		mov     dptr,#USE_FUN_KEY
		mov     R5,#0D4h
		lcall   dis_message

GET_NEW_PSWD:
		lcall	Rd_String
		cjne	A,#0x55,old_e2prom
		lcall	Wr_String

		mov	Rx_buff8,#0x01
		mov	Rx_buff9,#0x01
		lcall	store_password

		LCALL	DEFULT_ERR
		LCALL	TIME_ERR
old_e2prom:
		MOV	TIM_ENTERED,#0x00
		MOV	A,#0XA2
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		LCALL	DISP_HEX
WAIT_pswrd:
		MOV	A,#0XA0
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		lcall	disp_hex

		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_pswrd
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_pswrd	
		MOV	A,TIM_ENTERED
		mov	rx_buff8,a		

		MOV	TIM_ENTERED,#0x00
WAIT_pswrd1:	
		MOV	A,#0XA2
		LCALL	put_lcd_data
		MOV	A,TIM_ENTERED
		lcall	disp_hex
		lcall	get_key
		JNB	KEY_UPDT_EVT,WAIT_pswrd1
		lcall	GET_TIME
		JNB	TIM_GET_FLG,WAIT_pswrd1	
		MOV	A,TIM_ENTERED
		mov	rx_buff9,a					
		ret
;***********************************************************************
;		Routine Compares Entered Password 
;***********************************************************************
Check_Password:
		mov	R0,#Rx_buff8
		Mov	R1,#0x02
		MOV	Byte_AddrLo,#PASSWRD_EEPROM
		MOV	Byte_AddrHi,#00H
Check_Password0:
		lcall	Rd_E2Prom
		mov	r4,#0xF0
		lcall	ms_delay				
		MOV	A,DATA_E2PROM
		clr	c
		subb	a,@R0
		jnz	Not_Matched
		
		mov	R0,#Rx_buff9
		inc	Byte_AddrLo
		djnz	R1,Check_Password0
		clr	Not_Matched_Flag
		ret
Not_Matched:
		SetB	Not_Matched_Flag
		ret
;***********************PASSWORD NOT MATCHED*****************************
PSWRD_NOT_MCHD:	
		mov     dptr,#PSW_NOT_MCHD
		mov     R5,#0D4h
		lcall   dis_message

		LCALL	DELAY_2S

		SETB   	ie.7
		SETB   	ie.4
		
		LJMP	MAIN
;***********************************************************************
;		Routine Stores Entered Password In EEPROM
;***********************************************************************
STORE_PASSWORD:
		mov	R0,#Rx_buff8
		Mov	R1,#0x02
		mov	a,#PASSWRD_EEPROM
		MOV	Byte_AddrLo,A
		MOV	Byte_AddrHi,#00H
STORE_PASSWORD0:
		MOV	DATA_E2PROM,@R0
		lcall	WR_E2Prom
		mov	R0,#Rx_buff9		
		inc	Byte_AddrLo
		djnz	R1,STORE_PASSWORD0
		ret
;***********************************************************************
;	Routine Stores Defult ERROR LIST ADDRESS IN EPROM (03)
;***********************************************************************
DEFULT_ERR:
		MOV 	ERROR_EPROM,#03

STORE_ERR_ADD:
		MOV	A,#PT_ERR_EEPROM

		mov	Byte_AddrLo,A
		MOV	Byte_AddrHi,#00H
		mov	Data_E2prom,ERROR_EPROM
		lcall	Wr_E2Prom

		RET
;***********************************************************************
;	Routine Stores Defult ERROR TIME ADDRESS IN EPROM (04)
;***********************************************************************
TIME_ERR:
		MOV 	TIME_EPROM,#04

STORE_TIM_ADD:
		MOV	A,#PT_TIM_EEPROM

		mov	Byte_AddrLo,A
		MOV	Byte_AddrHi,#00H
		mov	Data_E2prom,TIME_EPROM
		lcall	Wr_E2Prom

		RET
;***********************************************************************
;     STORE ERROR FROM 03 ADDRES IN EEPROM 1 ERROR CONTAIN 14 BYTE
;***********************************************************************
STORE_ERROR:
		MOV	A,ERROR_EPROM
		CJNE	A,#0FDH,STORE_EROR_CON	;FOR MAX.124 ERROR
		MOV 	ERROR_EPROM,#03

STORE_EROR_CON:
		mov	A,ERROR_EPROM	     ;; XY
		ANL     A,#0FH               ;; 0Y
		SWAP	A		     ;; Y0
		ADD     A,#00H               ;; Y0
		MOV	Byte_AddrLo,A

		mov	A,ERROR_EPROM	     ;; XY
		ANL     A,#0F0H              ;; X0
		SWAP    A                    ;; 0X
		MOV	Byte_AddrHi,A

		mov	Data_E2prom,V_POLARITY
		lcall	Wr_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,V4_DIGIT	;FOR VOLTAGE MSB
		lcall	WR_E2Prom
		
		inc	Byte_AddrLo
		mov	DATA_E2PROM,V3_DIGIT
		lcall	WR_E2Prom
		
		inc	Byte_AddrLo
		mov	DATA_E2PROM,V2_DIGIT
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,V1_DIGIT
		lcall	WR_E2Prom
;*************************************************************************
		inc	Byte_AddrLo
		mov	DATA_E2PROM,I_POLARITY	
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,I4_DIGIT	
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,I3_DIGIT	
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,I2_DIGIT	
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,I1_DIGIT	
		lcall	Wr_E2Prom
;************************************************************************
		inc	Byte_AddrLo
		mov	Data_E2prom,FUSE_STATUS
		lcall	Wr_E2Prom
;************************************************************************
		INC	Byte_AddrLo
		mov	Data_E2prom,REMOT_STATUS
		lcall	Wr_E2Prom
;************************************************************************
		INC	Byte_AddrLo
		mov	Data_E2prom,POINT_STATUS
		lcall	Wr_E2Prom
;************************************************************************
		INC	Byte_AddrLo
		mov	Data_E2prom,XTRA_STATUS
		lcall	Wr_E2Prom
;************************************************************************
		MOV	A,ERROR_EPROM		;FOR INC OF EROR ADDRSS	
		ADD	A,#2
		MOV	ERROR_EPROM,A

		LCALL	STORE_ERR_ADD
 		RET
;***********************************************************************
;     STORE ERROR TIME FROM 04 ADDRES IN EEPROM 1 ERROR CONTAIN 10 BYTE
;***********************************************************************
STOR_TIM_ERROR: 	
		MOV	A,TIME_EPROM
		CJNE	A,#0FEH,STORE_TIM_CON	;FOR MAX.124 ERROR
		MOV 	TIME_EPROM,#04

STORE_TIM_CON:
		mov	A,TIME_EPROM	     ;; XY
		ANL     A,#0FH               ;; 0Y
		SWAP	A		     ;; Y0
		ADD     A,#00H               ;; Y0
		MOV	Byte_AddrLo,A

		mov	A,TIME_EPROM	     ;; XY
		ANL     A,#0F0H              ;; X0
		SWAP    A                    ;; 0X
		MOV	Byte_AddrHi,A
;*****************FOR TIME STORE IN E2PROM*******************************
		mov	DATA_E2PROM,TX_BUFF1	;FOR DATE BCD
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,TX_BUFF2	;FOR MONTH BCD
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,TX_BUFF3	;FOR YEAR BCD
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,TX_BUFF4	;FOR HOUR BCD
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,TX_BUFF5	;FOR MINT BCD
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,TX_BUFF6	;FOR SEC BCD
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,TX_BUFF7	;FOR DAY BCD
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,PTID_HI	;FOR ID HIGHER
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,PTID_MI	;FOR ID MIDIUM
		lcall	WR_E2Prom

		inc	Byte_AddrLo
		mov	DATA_E2PROM,PTID_LO	;FOR ID LOWER
		lcall	WR_E2Prom

		MOV	A,TIME_EPROM		;FOR INC OF EROR ADDRSS	
		ADD	A,#2
		MOV	TIME_EPROM,A

		LCALL	STORE_TIM_ADD
 		RET
;***********************************************************************
;	Routine GET Defult ERROR LIST ADDRESS FROM EPROM
;***********************************************************************
GET_ERR_ADD:
		MOV	Byte_AddrLo,#PT_ERR_EEPROM
		MOV	Byte_AddrHi,#00H
		lcall	Rd_E2Prom
		MOV	ERROR_EPROM,DATA_E2PROM

		MOV 	A,ERROR_EPROM
		CJNE	A,#03,GET_ERR_FLG
		RET

GET_ERR_FLG:
		SETB	ERROR_FLG			
		RET
;***********************************************************************
;	Routine GET Defult ERROR TIME ADDRESS FROM EPROM
;***********************************************************************
GET_TIM_ADD:
		MOV	Byte_AddrLo,#PT_TIM_EEPROM
		MOV	Byte_AddrHi,#00H
		lcall	Rd_E2Prom
		MOV	TIME_EPROM,DATA_E2PROM

		RET
;***********************************************************************
;		DISPLAY INITIAL MASSAGE
;***********************************************************************
DISP_INI_MSG:
		mov     dptr,#FST01_message
		mov     R5,#80h
		lcall   dis_message
		mov     dptr,#FST02_message
		mov     R5,#0C0h
		lcall   dis_message
		mov     dptr,#FST03_message
		mov     R5,#94h
		lcall   dis_message 
		mov     dptr,#FST04_message
		mov     R5,#0D4h
		lcall   dis_message

		lcall	DELAY_4S

		RET
;***********************************************************************
DISP_SEC_MSG:
		mov     dptr,#SEC11_message
		mov     R5,#80h
		lcall   dis_message
		mov     dptr,#SEC12_message
		mov     R5,#0C0h
		lcall   dis_message
		mov     dptr,#SEC13_message
		mov     R5,#94h
		lcall   dis_message 
		mov     dptr,#SEC14_message
		mov     R5,#0D4h
		lcall   dis_message

		RET
;***********************************************************************
;             ROUTINE FOR SEND TIME TO ALL NODES 
;***********************************************************************
SEND_TIME:
		mov	Tx_buff0,#'Y'	;FOR INITIAL MARK
;		MOV	Tx_buff1	;FOR DATE IN BCD FORMAT
;		mov	Tx_buff2	;FOR MONTH IN BCD FORMAT
;		MOV	Tx_buff3	;FOR YEAY IN BCD FORMAT
;		MOV	Tx_buff4	;FOR HOUR IN BCD FORMAT
;		MOV	Tx_buff5	;FOR MINT IN BCD FORMAT
;		mov	Tx_buff6	;FOR SEC IN BCD FORMAT
;		MOV	Tx_buff7	;FOR DAY IN BCD FORMAT

		MOV	TX_CNT,#08H
		LCALL	TX_FRAME

		RET
;***********************************************************************
;			HEX TO ASCII DISPLAY
;***********************************************************************
DISP_HEX:
		MOV	HEX,A
		LCALL	HEX_ASCII
		MOV	A,ASCII_HI
		LCALL	WR_message
		MOV	A,ASCII_LO
		LCALL	WR_message
		RET
;***********************************************************************
;		HEX TO ASCII CONVERSION
;***********************************************************************
HEX_ASCII:
		MOV	A,HEX
		MOV	DPTR,#HEC_DEC_TABLE
		movc	A,@A+DPTR
		MOV	DECIMAL,A
		ANL	A,#0X0F
		ORL	A,#0X30
		MOV	ASCII_LO,A
		MOV	A,DECIMAL
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30
		MOV	ASCII_HI,A
		RET
;***********************************************************************
;             To read the keys from a 8*1 Matrix
;***********************************************************************
Get_Key:
		clr	key_updt_evt

		lcall	read_Keypad_port
		cjne	a,#0xFF,Get_Key0
		jnb	key_prsd_evt,Get_Key1
		clr	key_prsd_evt
		setb	key_updt_evt
		RET
Get_Key1:
		mov	Key_Temp_Evt0,#0x00		
		mov	Key_Finl_Evt0,#0x00
		ret
	
Get_Key0:
		lcall	read_Keypad_port		
		cjne	A,#0xFF,Get_Key00
		MOV	Key_Temp_Evt0,#0XFF
		ret
Get_Key00:
		cjne	A,Key_Temp_Evt0,Get_Key01
		jb	key_dbnc_flag,Get_Key02
		RET
Get_Key01:
		mov	Key_Temp_Evt0,A
		setb	key_dbnc_flag
		call	CHK_DEBOUNCE
		ret
Get_Key02:
		mov	a,Key_Temp_Evt0
		cpl	a
		mov	Key_Finl_Evt0,a
		clr	key_dbnc_flag
		setb	key_prsd_evt
		ret
		
read_Keypad_port:
		mov	keypad_col_port,#0xff
		nop
		nop
		nop
		clr	Key_En_Bit
		nop
		nop
		mov	A,keypad_col_port
		nop
		nop
		setb	Key_En_Bit
		mov	keypad_col_port,#0xff
		ret

CHK_DEBOUNCE:	SETB	LED_CPU

		SETB	BUZZER	
		MOV	R4,#30
		LCALL	MS_DELAY
		CLR 	BUZZER

		CLR	LED_CPU	
		RET
;***********************************************************************
; 		Calculate entered time
;***********************************************************************
GET_TIME:
		CLR	TIM_GET_FLG
		JNB	KEY_UP,GET_TIME0
		MOV	A,TIM_ENTERED
		ADD	A,#0X05
		MOV	TIM_ENTERED,A
		SUBB	A,#0X64
		JNC	ROL_OVR_TIME	
		LJMP	EXIT_GET_TIME
ROL_OVR_TIME:		
		MOV	TIM_ENTERED,#0X00
		LJMP	EXIT_GET_TIME
GET_TIME0:		
		JNB	KEY_DOWN,GET_TIME1
		MOV	A,TIM_ENTERED
		cjne	a,#0x00,DEC_TIME
		MOV	A,#0X64
DEC_TIME:
		Dec	A
		MOV	TIM_ENTERED,A
		LJMP	EXIT_GET_TIME
GET_TIME1:		
		JNB	KEY_ENTER,GET_TIME2
		SETB	TIM_GET_FLG
		ljmp	EXIT_GET_TIME	
GET_TIME2:		
		JNB	Key_CANCL,GET_TIME3
		SETB	TIM_GET_FLG
		LJMP	MAIN	
GET_TIME3:
;		JNB	Key_CANCL,EXIT_GET_TIME
;		MOV	TIM_ENTERED,#0X00

EXIT_GET_TIME:
		RET
;***********************************************************************
;			FOR RTC TIME CALL
;***********************************************************************
TIMER_RTC: 	mov    	r7,#0ffh    
                setb   	rst
                mov    	a,#0bfh     ;WP For Read Operation
                lcall  	proc_1380
;-----------------------------------------------------------------------	
		;DO NOT DISPLAY
		
		lcall  	read_1380    ;read_1380  Second   
                anl    	A,#7fh
                mov    	B,A

		MOV	TX_BUFF6,A	;FOR STORE SECOND IN E2PROM BCD

;		MOV	A,#99h		
;		LCALL	PUT_LCD_DATA 	
		MOV	A,B
		swap	a
		ANL	A,#0X0F
		ORL	A,#0X30

;		LCALL	WR_message
		MOV	A,B
		ANL	A,#0X0F
		ORL	A,#0X30

;		LCALL	WR_message
;;----------------------------------------------------------------------	
;		MOV	A,#98h		
;		LCALL	PUT_LCD_DATA
;		mov     a,#':'
;               LCALL	WR_message
;;----------------------------------------------------------------------	
		lcall  	read_1380    ;read_1380 ;; Minute
                anl    	A,#7fh
                mov    	B,A

		MOV	TX_BUFF5,A	;FOR STORE MINUTE IN E2PROM BCD

		MOV	A,#8Dh		
		LCALL	PUT_LCD_DATA

		MOV	A,B
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30

		LCALL	WR_message
		MOV	A,B
		ANL	A,#0X0F
		ORL	A,#0X30

		LCALL	WR_message
;;----------------------------------------------------------------------	
                MOV	A,#8CH		
		LCALL	PUT_LCD_DATA
		mov     a,#':'
                LCALL	WR_message
;;----------------------------------------------------------------------	
		lcall  	read_1380      ;read_1380 Hour     
                anl    	A,#3fh
                mov    	B,A

		MOV	TX_BUFF4,A	;FOR STORE HOUR IN E2PROM BCD

		MOV	A,#8Ah		
		LCALL	PUT_LCD_DATA

		MOV	A,B
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30

		LCALL	WR_message
		MOV	A,B
		ANL	A,#0X0F
		ORL	A,#0X30

		LCALL	WR_message
;;----------------------------------------------------------------------	
		lcall  	read_1380    ;read_1380 ;; Date     
                anl    	A,#3fh
                mov    	B,A

		MOV	TX_BUFF1,A	;FOR STORE Date IN E2PROM BCD

		MOV	A,#80h		
		LCALL	PUT_LCD_DATA

		MOV	A,B
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30

		LCALL	WR_message
		MOV	A,B

		ANL	A,#0X0F
		ORL	A,#0X30

		LCALL	WR_message
;;----------------------------------------------------------------------	
                MOV	A,#82H	    ; "-"   after Date
		LCALL	PUT_LCD_DATA
		mov     a,#'-'
                LCALL	WR_message
;;----------------------------------------------------------------------	
		lcall  	read_1380   ;read_1380 ;; Month    
                anl    	A,#1fh
                mov    	B,A

		MOV	TX_BUFF2,A	;FOR STORE MONTH IN E2PROM BCD

		MOV	A,#83h		
		LCALL	PUT_LCD_DATA

		MOV	A,B
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30

		LCALL	WR_message
		MOV	A,B
		ANL	A,#0X0F
		ORL	A,#0X30

		LCALL	WR_message
;-----------------------------------------------------------------------		
		lcall  	read_1380    ;read_1380 DAY     
                anl    	A,#07h

		MOV	TX_BUFF7,A	;FOR STORE DAY IN E2PROM BCD

		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	DAY_DISP
;-----------------------------------------------------------------------	
                MOV	A,#85h	    ; "-"   after Month
		LCALL	PUT_LCD_DATA
		mov     a,#'-'
	        LCALL	WR_message
;------------------------------------------------------------------------
		lcall  	read_1380    ;read_1380 ;; Year     
                anl    	A,#9Fh
                mov    	B,A

		MOV	TX_BUFF3,A	;FOR STORE YEAR IN E2PROM BCD

		MOV	A,#86h		
		LCALL	PUT_LCD_DATA

		MOV	A,B
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30

		LCALL	WR_message
		MOV	A,B
		ANL	A,#0X0F
		ORL	A,#0X30

		LCALL	WR_message
                clr    	rst 

                ret
;***********************************************************************
DAY_DISP:
		CJNE    A,#'1',MON
		mov     dptr,#SUN_message
		mov     R5,#91H
		LCALL   DIS_message
		RET
MON:
		CJNE    A,#'2',TUE
		mov     dptr,#MON_message
		mov     R5,#91H
		LCALL   DIS_message
		RET
TUE:
		CJNE    A,#'3',WED
		mov     dptr,#TUE_message
		mov     R5,#91H
		LCALL   DIS_message
		RET
WED:
		CJNE    A,#'4',THU
		mov     dptr,#WED_message
		mov     R5,#91H
		LCALL   DIS_message
		RET
THU:
		CJNE    A,#'5',FRI
		mov     dptr,#THU_message
		mov     R5,#91H
		LCALL   DIS_message
		RET
FRI:
		CJNE    A,#'6',SAT
		mov     dptr,#FRI_message
		mov     R5,#91H
		LCALL   DIS_message
		RET
SAT:
		CJNE    A,#'7',RET_DAY
		mov     dptr,#SAT_message
		mov     R5,#91H
		LCALL   DIS_message
		RET
RET_DAY:
		RET
;***********************************************************************
;	DISPLAY READED TIME FROM EPROM FOR LIST FUNCTION
;***********************************************************************
DISP_TIME:
		MOV	A,TX_BUFF5	; Minute
                anl    	A,#7fh
                mov    	B,A

		MOV	A,#8Dh		
		LCALL	PUT_LCD_DATA

		MOV	A,B
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	WR_message

		MOV	A,B
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	WR_message
;;----------------------------------------------------------------------	
                MOV	A,#8CH		
		LCALL	PUT_LCD_DATA
		mov     a,#':'
                LCALL	WR_message
;;----------------------------------------------------------------------	
		MOV	A,TX_BUFF4      ;Hour     
                anl    	A,#3fh
                mov    	B,A

		MOV	A,#8Ah		
		LCALL	PUT_LCD_DATA

		MOV	A,B
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	WR_message

		MOV	A,B
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	WR_message
;;----------------------------------------------------------------------	
		MOV	A,TX_BUFF1	; Date     
                anl    	A,#3fh
                mov    	B,A

		MOV	A,#80h		
		LCALL	PUT_LCD_DATA

		MOV	A,B
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	WR_message

		MOV	A,B
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	WR_message
;;----------------------------------------------------------------------	
                MOV	A,#82H	    	; "-"   after Date
		LCALL	PUT_LCD_DATA
		mov     a,#'-'
                LCALL	WR_message
;;----------------------------------------------------------------------	
		MOV	A,TX_BUFF2	; Month    
                anl    	A,#1fh
                mov    	B,A

		MOV	A,#83h		
		LCALL	PUT_LCD_DATA

		MOV	A,B
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	WR_message

		MOV	A,B
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	WR_message
;-----------------------------------------------------------------------		
		MOV	A,TX_BUFF7	;DAY     
                anl    	A,#07h
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	DAY_DISP
;-----------------------------------------------------------------------	
                MOV	A,#85h	    ; "-"   after Month
		LCALL	PUT_LCD_DATA
		mov     a,#'-'
	        LCALL	WR_message
;------------------------------------------------------------------------
		MOV	A,TX_BUFF3	; Year     
                anl    	A,#9Fh
                mov    	B,A

		MOV	A,#86h		
		LCALL	PUT_LCD_DATA

		MOV	A,B
		SWAP	A
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	WR_message

		MOV	A,B
		ANL	A,#0X0F
		ORL	A,#0X30
		LCALL	WR_message 

                ret
;***********************************************************************
;			INIT OF RTC
;***********************************************************************
init_1380:
		setb  	rst           ;reset_1380
                mov    	a,#8eh        ;WP Command #8eh
                lcall  	proc_1380     ;proc_1380
	        clr    	a             ;disable WP(resis 7 = 0)
		lcall  	proc_1380     ;proc_1380
	        clr    	rst           ;clr reset
                nop
                nop
                setb   	rst           ;setb reset
                mov    	a,#81h        ;Read Command Byte
                lcall  	proc_1380     ;proc_1380

                lcall  	Read_1380
                mov    	b,a           ;read value in A
                clr    	rst           
                nop
                nop
                setb   	rst 

                mov    	a,#80h        ;Write Command Byte
                lcall  	proc_1380     ;proc_1380
                mov    	a,b           ;
                clr    	acc.7         ;resistor 7 = 0
                lcall  	proc_1380     ;proc_1380
                clr    	rst           ;clr Reset

                ret
;-----------------------------------------------------------------------
Proc_1380:	mov    r4,#08h                    
pqrs:           CLR    sclk 
                rrc    a                           
                mov    inout,c       
                SETB   sclk                
                djnz   r4,pqrs                     
                clr    sclk
                ret
;-----------------------------------------------------------------------
read_1380:	SETB	LED_CPU 

		mov    r4,#08h
                setb   Inout
xyz:            nop
                mov    c,Inout
                rrc    a
                setb   Sclk
                nop
                clr    Sclk
                djnz   r4,xyz

		CLR	LED_CPU
                ret
;***********************************************************************
;		SERIAL EEROM INIT
;***********************************************************************
startbit:      	clr 	scl
		nop 
		nop
		setb 	sda
		nop
		nop
		setb 	scl
		nop
		nop
		clr 	sda
		nop
		nop
		clr 	scl
		nop
		setb 	sda ;to bring sda to high z state
		nop
		ret
;***********************************************************************
byte_write:
 	        mov    	r7,#08h
	        clr 	scl
nextb:          rlc 	a
		nop
		nop
		mov 	sda,c
		nop
		nop
		nop
		setb	scl
		nop
		nop
		nop
		nop
		clr 	scl
		nop
		nop
		nop
		djnz 	r7,nextb
		setb    sda
		lcall	get_ack
		ret            
;**********************************************************************
stopbit:    	clr 	scl
       	   	nop 
	   	nop
	   	clr 	sda
	    	nop
	    	nop
	    	setb 	scl                         
	    	nop
	    	nop
	    	nop
	    	setb 	sda
	    	nop
	    	nop
	    	nop
		clr 	scl
	    	nop
	    	nop
	    	nop
	    	ret
;***********************************************************************
byte_read:
		mov 	r7,#08h;
next_bit:       setb 	scl;
		nop
		nop
		nop
		nop
		nop
		mov 	c,sda;
		rlc 	a;
		clr 	scl;
		nop
		nop
		nop
		nop
		nop
		djnz 	r7,next_bit;
		nop
		ret

give_ack:       clr 	scl;
		nop;
		nop
		clr 	sda
		nop;
		nop
		setb 	scl;
		nop
		nop;
		nop
		nop
		clr 	scl;
		nop;
		setb 	sda
		nop
		ret
;**********************************************************************
get_ack:        nop
		clr 	scl
		nop
		setb 	sda
		nop
		nop
		setb 	scl
wait11:         nop
		jb  	sda, wait11
		nop
		clr 	scl
		nop
		ret 
;***********************************************************************
;Wr One Byte At Data_E2prom To E2prom At Addre Byte_AddrHi:Byte_AddrLo
;***********************************************************************
Wr_E2Prom:
		LCALL	STARTBIT

		MOV	A,#0XA0
		lcall	byte_write
		MOV	A,Byte_AddrHi
		lcall	byte_write

		MOV	A,Byte_AddrLo   
		lcall	byte_write
		MOV	A,Data_E2prom
		lcall	byte_write

		LCALL	STOPBIT

		mov    R4,#2
		lcall  ms_delay

		ret 
;***********************************************************************
;Read One Byte From E2prom From Address Byte_AddrHi:Byte_AddrLo
;***********************************************************************
Rd_E2Prom:
		LCALL	STARTBIT

		MOV	A,#0XA0
		lcall	byte_write
		Mov    A,Byte_AddrHi	
		lcall	byte_write
		MOV	A,Byte_AddrLo
		lcall	byte_write

		LCALL	STARTBIT
		MOV	A,#0XA1
		lcall	byte_write
		lcall	byte_READ
		mov	Data_E2prom,a
		LCALL	STOPBIT

		mov    R4,#2
		lcall  ms_delay

		ret
;***********************************************************************
Wr_String:
		mov	Byte_AddrLo,#0x05
		MOV	Byte_AddrHi,#00H
		mov	Data_E2prom,#'H'
		lcall	Wr_E2Prom		

		mov	Byte_AddrLo,#0x06
		MOV	Byte_AddrHi,#00H
		mov	Data_E2prom,#'I'
		lcall	Wr_E2Prom		

		mov	Byte_AddrLo,#0x07
		MOV	Byte_AddrHi,#00H
		mov	Data_E2prom,#'M'
		lcall	Wr_E2Prom		

		ret
;***********************************************************************
Rd_String:
		mov	Data_E2prom,#0x00
		mov	Byte_AddrLo,#0x05
		MOV	Byte_AddrHi,#00H

		lcall	Rd_E2Prom		
		mov	a,Data_E2prom
		cjne	a,#'H',Not_Matched_String

		mov	Byte_AddrLo,#0x06
		MOV	Byte_AddrHi,#00H
		mov	Data_E2prom,#0x00
		lcall	Rd_E2Prom		
		mov	a,Data_E2prom 
		cjne	a,#'I',Not_Matched_String

		mov	Byte_AddrLo,#0x07
		MOV	Byte_AddrHi,#00H
		mov	Data_E2prom,#0x00
		lcall	Rd_E2Prom		
		mov	a,Data_E2prom
		cjne	a,#'M',Not_Matched_String

		mov	a,#0xAA
		ret
Not_Matched_String:
		mov	a,#0x55
		ret
;***********************************************************************
;			INIT. OF LCD
;***********************************************************************
INIT_LCD:
		mov     R4,#100    
		lcall   ms_delay

		mov 	a,#38h
		lcall 	put_lcd_data
		mov   	R4,#25    
		lcall 	ms_delay

		mov 	a,#38h
		lcall 	put_lcd_data
		mov   	R4,#25   
		lcall 	ms_delay

		mov 	a,#38h
		lcall 	put_lcd_data
		mov   	R4,#25    
		lcall 	ms_delay

		mov   	a,#38h
		lcall 	put_lcd_data
		mov   	R4,#25    
		lcall 	ms_delay

		mov 	a,#08h              	;display off
		lcall 	put_lcd_data 
		mov   	R4,#25
		lcall 	ms_delay

		mov 	a,#01h              	;clear display
		lcall 	put_lcd_data 
		mov   	R4,#25
		lcall 	ms_delay


		mov 	a,#06h              	;entry mode set
		lcall 	put_lcd_data
		mov   	R4,#25
		lcall 	ms_delay

		mov   	a,#0Ch			;display on
		lcall 	put_lcd_data
		mov   	R4,#25
		lcall 	ms_delay

		ret
;***********************************************************************
put_lcd_data:	
		LCALL	READY

		mov 	P0,A
		clr 	LCD_RS
		clr 	LCD_RW
		nop
		nop
		setb 	LCD_ENB
		nop
		nop
		clr 	LCD_ENB
		ret
;***********************************************************************
dis_message:	
		mov     a,R5  
		lcall   READY
		lcall   put_lcd_data
		lcall   READY

next_dis:	CLR A
		MOVC 	A,@A+DPTR
		CJNE    A,#00h,notendline

		RET

notendline:	lcall   READY
		lCALL 	WR_message
		INC 	DPTR
		lcall  	READY
		SJMP 	next_dis
;***********************************************************************
WR_message:
		lcall  	READY
		mov     P0,A
		NOP
		SETB 	LCD_RS
		clr 	LCD_RW
		NOP
		NOP
		setb 	LCD_ENB
		NOP
		NOP
		clr 	LCD_ENB
		ret
;***********************************************************************
READY:		SETB	LED_CPU

		SETB	P0_7         ;FOR BUSSY FLAG
		CLR 	LCD_RS
		SETB 	LCD_RW
		NOP

HOLD:		CLR 	LCD_ENB
		NOP
		SETB 	LCD_ENB
		JB 	P0_7,HOLD

		CLR	LED_CPU
		RET
;***********************************************************************
;             		COMMON DELAY
;***********************************************************************
ms_delay:
loop_2:        
		 mov	r3,250
loop_1:         
		nop
		nop
		djnz	r3,loop_1
		djnz	r4,loop_2

		RET

DELAY_1S:
		lcall	init_timer0
		mov	tmr_cnt2,#1
		JNB	MIN_FLAG,$
		CLR	TR0
		RET

DELAY_2S:
		lcall	init_timer0
		mov	tmr_cnt2,#2
		JNB	MIN_FLAG,$
		CLR	TR0
		RET

DELAY_4S:
		lcall	init_timer0
		mov	tmr_cnt2,#4
		JNB	MIN_FLAG,$
		CLR	TR0
		RET
;***********************************************************************
INIT_CPU:
		MOV	A,#0X00
		MOV	TCON,A
		MOV	TMOD,A	
		MOV	IE,A
		MOV	PSW,#0X00
		LCALL	INIT_PORTS
		LCALL	EN_RXD	
		SETB	IE.7
		RET	
;***********************************************************************
INIT_PORTS:
		MOV	P0,#0FFH
		MOV	P1,#0FFH	
		MOV	P2,#0FFH
		MOV	P3,#0FFH

		CLR     LCD_RS	
		CLR     LCD_RW

		CLR     BUZZER
		CLR	LED_FLT
		CLR     LED_CPU
		CLR	RS_RW

		CLR	PFC_RLY1
		CLR	PFC_RLY2

		RET	
;***********************************************************************
;             SERIAL INTERRUPT SERVICE ROUTINE
;***********************************************************************
INT_RXD:
		PUSH	0X0E0	;SAVE ACCUMULATOR
		PUSH	PSW	;SAVE PROGRAM STATUS
		MOV	PSW,#08H ;select bank 1
	
		MOV	A,SBUF
		CLR	RI
		CJNE	A,#'$',GET_FRAME

		MOV	R1, #00H	;receive count
		MOV	R0,#RX_BUFF0	;receive buffer
		SETB	VLD_FRM_FLG
		CLR	FRM_RXD_FLG
		lJMP	EXIT_INT_RXD	
GET_FRAME:
		JNB	VLD_FRM_FLG, EXIT_INT_RXD
		CJNE	R1, #08H, FRM_NOT_OVR
		LJMP	CHK_END_FRM
FRM_NOT_OVR:
		MOV	@R0,A
		INC	R1
		INC	R0
		lJMP	EXIT_INT_RXD
CHK_END_FRM:			
		CLR	VLD_FRM_FLG
		SETB	FRM_RXD_FLG
		MOV	A,rx_buff0

		cjne	a,#'0',CHK_FOR_VOLT
		lcall	STOR_FLT_ID		
		LJMP	EXIT_INT_RXD
CHK_FOR_VOLT:		
		CJNE	a,#'1',CHK_FOR_AMP
		lcall	STORE_FLT_VOLT
		LJMP	EXIT_INT_RXD

CHK_FOR_AMP:		
		CJNE	a,#'2',CHK_FOR_FUSE
		lcall	STORE_FLT_AMP
		LJMP	EXIT_INT_RXD

CHK_FOR_FUSE:		
		CJNE	a,#'3',NOT_VLD_FRM
		lcall	STORE_FLT_STAS
		LJMP	EXIT_INT_RXD

NOT_VLD_FRM:
		CLR	VLD_FRM_FLG
		CLR	A
		MOV	R1, #00H
		LJMP	EXIT_INT_RXD

EXIT_INT_RXD:
		POP	PSW
		POP	0X0E0

		RETI
;***********************************************************************
;	       Routine Transmits Information
;***********************************************************************
TX_Frame:	
		SETB	LED_CPU
		CLR	IE.4
		SETB	RS_RW

		mov	R0,#Tx_buff0
		MOV	R1,TX_CNT
		clr 	ti

		mov	sbuf,#'$'
		JNB	ti,$
		CLR 	TI
REP_TX:
		mov	a,@R0
		mov	sbuf,a
		JNB	ti,$
		CLR 	TI
		INC	R0
		DJNZ	R1,REP_TX

		mov	sbuf,#'#'
		JNB	ti,$
		CLR 	TI

		CLR	RS_RW
		SETB	IE.4
		CLR	LED_CPU
		RET
;***********************************************************************
;		 ENABLE SERIAL INTERRUPT
;***********************************************************************
EN_RXD:
		ORL	TMOD,#0X20	;AUTO RELOAD MODE
		MOV	TH1,#0XFD	;9600 BAUD RATE
		MOV	SCON,#0X50	;8-BIT, 1 STOP, REN ENABLE
		SETB	TR1		;TIMER1 ON 				
		SETB	IE.4     	;ENABLE SERIAL INTERUPT
		RET
;***********************************************************************
; 				interrupt enable for timer0
;***********************************************************************
init_timer0:	
		ORL	tmod,#0x01	;mode1 16 bit timer
		mov	TH0,#0x4C	;for 50 ms count
		mov	TL0,#0x14
		ORL	ie,#0x82	;inerrupt enable for timer0
		setb	tr0		;start timer0
		mov	tmr_cnt1,#20	; 50ms * 20 = 1Sec
		mov	tmr_cnt2,#60	;no of seconds
		clr	min_flag
		clr	sec_flag
		ret
;***********************************************************************
; 		interrupt service routine for timer0
;***********************************************************************
timer0:		
		PUSH	PSW
		PUSH	0x0E0	
		MOV	PSW,#0X10  	 
		CLR	TIME_OVR_FLG
		clr	TF0
		clr	TR0
		mov	R1,tmr_cnt1
		djnz	R1,sec_not_ovr
		setb	sec_flag
		mov	tmr_cnt1,#20
		mov	R2,tmr_cnt2
		djnz	R2,min_not_ovr
		setb	min_flag
		MOV	R3,TIME_REMAINED
		DJNZ	R3,TMR_NOT_ZERO
		SETB	TIME_OVR_FLG
TMR_NOT_ZERO:
		MOV	TIME_REMAINED,R3
		mov	tmr_cnt2,#60
		ljmp	exit_timer
min_not_ovr:
		mov	tmr_cnt2,R2
		JMP	EXIT_TIMER
sec_not_ovr:		
		mov	tmr_cnt1,R1
		mov	TH0,#0x4C	;for 50 ms count
		mov	TL0,#0x14
EXIT_TIMER:
		setb	TR0
		POP	0x0E0
		POP	PSW
		reti
;***********************************************************************
HEC_DEC_TABLE:	DB  0X00,0X01,0X02,0X03,0X04,0X05,0X06,0X07,0X08,0X09
		DB  0X10,0X11,0X12,0X13,0X14,0X15,0X16,0X17,0X18,0X19
		DB  0X20,0X21,0X22,0X23,0X24,0X25,0X26,0X27,0X28,0X29
		DB  0X30,0X31,0X32,0X33,0X34,0X35,0X36,0X37,0X38,0X39
		DB  0X40,0X41,0X42,0X43,0X44,0X45,0X46,0X47,0X48,0X49
		DB  0X50,0X51,0X52,0X53,0X54,0X55,0X56,0X57,0X58,0X59
		DB  0X60,0X61,0X62,0X63,0X64,0X65,0X66,0X67,0X68,0X69
		DB  0X70,0X71,0X72,0X73,0X74,0X75,0X76,0X77,0X78,0X79
		DB  0X80,0X81,0X82,0X83,0X84,0X85,0X86,0X87,0X88,0X89
		DB  0X90,0X91,0X92,0X93,0X94,0X95,0X96,0X97,0X98,0X99
		DB  0X10,0X11,0X12,0X13,0X14,0X15,0X16,0X17,0X18,0X19
		DB  0X10,0X11,0X12,0X13,0X14,0X15,0X16,0X17,0X18,0X19
;**************************************************************************
HEX_ASCII_1:	
		CJNE	A,#' ',A_MSG
		LCALL	WR_message
		RET
		
A_MSG:		CJNE	A,#'A',B_MSG
		LCALL	WR_MESSAGE
		RET

B_MSG:		CJNE	A,#'B',C_MSG
		LCALL	WR_MESSAGE
		RET

C_MSG:		CJNE	A,#'C',D_MSG
		LCALL	WR_MESSAGE
		RET

D_MSG:		CJNE	A,#'D',E_MSG
		LCALL	WR_MESSAGE
		RET

E_MSG:		CJNE	A,#'E',F_MSG
		LCALL	WR_MESSAGE
		RET

F_MSG:		CJNE	A,#'F',N_MSG
		LCALL	WR_MESSAGE
		RET

N_MSG:		CJNE	A,#'X',EXT_1
		LCALL	WR_message
EXT_1:
		RET
;**********************************************************************
;		FOR CLEAR MAIN FLAG'S AND REGISTOR'S
;***********************************************************************
MAIN_FLAG:
		mov	tmr_cnt2,#00H
		mov	tmr_cnt1,#00H	
		CLR	sec_flag
		CLR	min_flag
		CLR	TIME_OVR_FLG
		SETB	IE.4
		RET
;***********************************************************************
		END  
;***********************************************************************
















































































