LIST P=16F877A
#INCLUDE P16F877A.INC

ORG 0X00
GOTO START

ORG 0X04
GOTO INTERRUPT

START:
ORG 0X40
GOTO MAIN

BANK0 MACRO
BCF STATUS,RP0
BCF STATUS,RP1
ENDM

BANK1 MACRO
BSF STATUS,RP0
BCF STATUS,RP1
ENDM

BANK2 MACRO
BCF STATUS,RP0
BSF STATUS,RP1
ENDM

BANK3 MACRO
BSF STATUS,RP0
BSF STATUS,RP1
ENDM

MAIN:
BANK0
MOVLW 0XC0
MOVWF INTCON

BANK1
BSF PIE1,RCIE
CLRF TRISB
;MOVLW 0XFF
CLRF TRISD
MOVLW 0X80
MOVWF TRISC
CLRF TXSTA
BSF TXSTA,BRGH
MOVLW D'25'
MOVWF SPBRG

BANK0
CLRF PORTB
CLRF PORTD
CLRF RCSTA
BSF RCSTA,SPEN
BSF RCSTA,CREN

LOOP:
GOTO LOOP

	


INTERRUPT:
BANK0
BTFSS PIR1,RCIF
GOTO LOOP
ISR:
BANK0
BCF INTCON,GIE
BCF INTCON,PEIE
BCF PIR1,RCIF
BANK1
BCF PIE1,RCIE
BANK0
MOVF RCREG,0
MOVWF 0X23
MOVWF PORTD
CALL DELAY
;BSF PORTC,7
BSF INTCON,PEIE
BANK1
BSF PIE1,RCIE
RETFIE

DELAY:
MOVLW 0X05
MOVWF 0X30
L1:
MOVLW 0XFF
MOVWF 0X31
L2:
MOVLW 0XFF
MOVWF 0X32
L3:
DECFSZ 0X32,1
GOTO L3
DECFSZ 0X31,1
GOTO L2
DECFSZ 0X30,1
GOTO L1
RETURN

END
 