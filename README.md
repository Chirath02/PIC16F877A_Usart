# PIC16F877A_Usart

Usart project in assembly code to transmit data from one pic to another using USART peripheral.

When a key is pressed in the keyboard connected to the master PIC controller, a byte of data is transmitted serially.
This data is recieved by Slave PIC controller and displayed using 7 segment LED display.

# Components

* PIC 16F877A (Master)
* Keboard(0-9)

* PIC 16F877A (slave)
* 7 segment LED

# Connection

* RC6/TX of master connected to RC7/RX of slave.
* PORTB(0-6) of slave for keyboard.
* POrtB(0-7) of master for 7 segment LED display.


