; Julia Abdel-Monem
; July 5, 2023
; written for an Adafruit metro with a atmega328P running at 16Mhz


#ifndef DELAY_ASM
#define DELAY_ASM

#include "Registers.asm"


.org 0x001C ; OCR0A
clz ; clear zero flag
reti

.org 0x300

; r20 = multiplier
_500ns: 
    ldi r16, 0x00
    sts _TCCR0A, r16

    ldi r16, 0x032  ; set to clk/8, which results in a relative clk rate of 2^21 hz 
                    ; roughly 500 ns per cycle
    sts _TCCR0B, r16 

    ldi r16, 0x02   ; sets timer/counter output compare match A interrupt to true.
    sts _TIMSK0, r16 

    sts _OCR0A, r20

    ldi r16, 0x00   
    sts _TCNT0, r16 ; clear the timer.

    sez; set zero flag 
    sei; start interrupt

    waitLoop_500ns:
        nop
        breq waitLoop_500ns; branch if the zero flag is still set

    cli; disable interupts

    ret

; r20 = multiplier
_3814ns: 
    ldi r16, 0x00
    sts _TCCR0A, r16

    ldi r16, 0x033  ; set to clk/64, which results in a relative clk rate of 2^21 hz 
                    ; roughly 500 ns per cycle
    sts _TCCR0B, r16 

    ldi r16, 0x02   ; sets timer/counter output compare match A interrupt to true.
    sts _TIMSK0, r16 

    sts _OCR0A, r20

    ldi r16, 0x00   
    sts _TCNT0, r16 ; clear the timer.

    sez; set zero flag 
    sei; start interrupt

    waitLoop_3814ns:
        nop
        breq waitLoop_3814ns; branch if the zero flag is still set

    cli; disable interupts

    ret

; r20 = multiplier
_15us: 
    ldi r16, 0x00
    sts _TCCR0A, r16

    ldi r16, 0x034  ; set to clk/256, which results in a relative clk rate of 2^16 hz 
                    ; roughly 500 ns per cycle
    sts _TCCR0B, r16 

    ldi r16, 0x02   ; sets timer/counter output compare match A interrupt to true.
    sts _TIMSK0, r16 

    sts _OCR0A, r20

    ldi r16, 0x00   
    sts _TCNT0, r16 ; clear the timer.

    sez; set zero flag 
    sei; start interrupt

    waitLoop_15us:
        nop
        breq waitLoop_15us; branch if the zero flag is still set

    cli; disable interupts

    ret

; r20 = multiplier
_61us:  
    ldi r16, 0x00
    sts _TCCR0A, r16

    ldi r16, 0x035  ; set to clk/1024, which results in a relative clk rate of 2^14 hz 
                    ; roughly 500 ns per cycle
    sts _TCCR0B, r16 

    ldi r16, 0x02   ; sets timer/counter output compare match A interrupt to true.
    sts _TIMSK0, r16 

    sts _OCR0A, r20

    ldi r16, 0x00   
    sts _TCNT0, r16 ; clear the timer.

    sez; set zero flag 
    sei; start interrupt

    waitLoop_61us:
        nop
        breq waitLoop_61us; branch if the zero flag is still set

    cli; disable interupts

    ret

#endif