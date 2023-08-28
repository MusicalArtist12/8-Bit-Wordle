.ifndef REGISTERS_ASM
.define REGISTERS_ASM

.define _TCCR0A 0x44 ; timer/counter control register A
.define _TCCR0B 0x45 ; timer/counter control register B 
.define _TCNT0 0x46 ; timer/counter register
.define _OCR0A 0x47 ; output compare register A
.define _TIMSK0 0x6E ; timer/counter interrupt mask register

.define _MCUCR  0x35; MCU control register
.define _EICRA  0x69; External interrupt Control Register A
.define _EIMSK  0x3D; External interrupt mask register
.define _EIFR   0x3C; External interrupt Flag Register
.define _PCICR  0x68; Pin Change interrupt control register
.define _PCIFR  0x3B; Pin Change interrupt flag register
.define _PCMSK2 0x6D ; Pin Change Mask Register 2
.define _PCMSK1 0x6C
.define _PCMSK0 0x6B

.define _DDRD  0x0A ; pins [0:7]
.define _PORTD 0x0B
.define _PIND 0x0B

.define _DDRC  0x07
.define _PORTC 0x08 ; pins [A0:A5]
.define _PINC  0x09

.define _DDRB  0x04 ; pins [8:13]
.define _PORTB 0x05 
.define _PINB  0x06


.endif