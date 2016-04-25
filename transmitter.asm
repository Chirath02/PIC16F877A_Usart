List P= 16F877A
#include P16F877A.inc

MAIN:
	CALL KEYBOARD_CONFIG
	CALL KEYBOARD
	CALL TRANSMISSION_CONFIG
	
	BANKSEL TXSTA 
	BSF TXSTA, 5 ; Set TXEN, enable transmission
	
	BANKSEL TXREG 
	MOVF 0X20, 0 
	MOVWF TXREG ;load keyboard value into TXREG for transmission

	; Trasmission starts....
	
	BANKSEL TXSTA
	
	LOOP:
		BTFSS TXSTA, 1 ; poll TMRT, TMRT becomes 0 after transmission.
		GOTO LOOP
	
	GOTO TERMINATE ; Goto END

TRANSMISSION_CONFIG:
	MOVLW 0XC0
	MOVWF TRISC
	
	;---CONFIGURE SPBRG FOR DESIRED BAUD RATE
	MOVLW .25 ; 9600bps
	MOVWF SPBRG ; BAUD AT 4MHZ
	
		
	;---CONFIGURE TXSTA
	MOVLW B'00100100' ;CONFIGURE TXSTA AS :
	MOVWF TXSTA ;
	;8 BIT TRANSMISSION - 6.BIT
	;TRANSMIT ENABLED - 5.BIT
	;ASYNCHRONOUS MODE - 4.BIT
	;ENABLE HIGH SPEED BAUD RATE - 2.BIT

	MOVLW	0x90
	MOVWF	RCSTA

	RETURN

KEYBOARD_CONFIG:
	; Keyboard input output config
	BANKSEL TRISB
	MOVLW 0X78 
	MOVWF TRISB
	
	; RB6, RB5, RB4, RB3 is input for rows.
	; RB2, RB1, RB0 is output for columns
	; RB7 unimplimented]

	RETURN

KEYBOARD: ; Keyboard module starts
	BANKSEL PORTB ; Keyboard connected to portb
	CLRF PORTB ; clear portb for input and output
	
	MOVLW 0XFF  ; make all bits 1 for chevking keypress
	MOVWF 0X20  ; data memory adress for storing keyboard value
	
	; sent high to col 3

	MOVLW 0X01 
	MOVWF PORTB
	CALL SWITCH ; check for row and return row number
	MOVWF 0X20
	BTFSS 0X20, 7
	ADDLW 0X03

	; sent high to col 2
	
	MOVLW 0X02
	MOVWF PORTB
	CALL SWITCH ; check for row and return row number
	MOVWF 0X20
	BTFSS 0X20, 7
	ADDLW 0X02

	; sent high to col 1	

	MOVLW 0X04
	MOVWF PORTB
	CALL SWITCH ; check for row and return row number
	MOVWF 0X20
	BTFSS 0X20, 7
	ADDLW 0X01
	
	MOVWF 0X20 ;final value of key stored at 0x20, 0xff if no key is pressed.
	
	BTFSS 0X20, 7 ; check if key is pressed
	RETURN ; Key pressed if 7th bit is 0
	GOTO KEYBOARD ; recheck if key is pressed
	
	SWITCH:
		BTFSC PORTB, 6 ; check row 1
		RETLW 0X00 ; 0x00 returned if row = 1
		BTFSC PORTB, 5 ; check row 2
		RETLW 0X03 ; 0x00 returned if row = 2
		BTFSC PORTB, 4 ; check row 3
		RETLW 0X06 ; 0x00 returned if row = 3
		BTFSC PORTB, 3 ; check row 4
		RETLW 0X09 ; 0x00 returned if row = 4
		RETLW 0XFF ; 0xFF returned if no key is pressed

TERMINATE:
END