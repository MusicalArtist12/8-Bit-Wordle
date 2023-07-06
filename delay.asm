.equ _TCCR0A = 0x44 ; timer/counter control register A
.equ _TCCR0B = 0x45 ; timer/counter control register B 
.equ _TCNT0 = 0x46 ; timer/counter register
.equ _OCR0A = 0x47 ; output compare register A
.equ _TIMSK0 = 0x6E ; timer/counter interrupt mask register

.org 0x001C ; OCR0A
clz ; clear zero flag
reti

.org 0x300
_500ns_r25:
    ldi r24, 0x00
    sts _TCCR0A, r24

    ldi r24, 0x032  ; set to clk/8, which results in a relative clk rate of 2^21 hz 
                    ; roughly 500 ns per cycle
    sts _TCCR0B, r24 

    ldi r24, 0x02   ; sets timer/counter output compare match A interrupt to true.
    sts _TIMSK0, r24 

    sts _OCR0A, r25

    ldi r24, 0x00   
    sts _TCNT0, r24 ; clear the timer.

    sez; set zero flag 
    sei; start interrupt

    waitLoop_500ns:
        nop
        breq waitLoop_500ns; branch if the zero flag is still set

    cli; disable interupts

    ret

_3814ns_r25:
    ldi r24, 0x00
    sts _TCCR0A, r24

    ldi r24, 0x033  ; set to clk/64, which results in a relative clk rate of 2^21 hz 
                    ; roughly 500 ns per cycle
    sts _TCCR0B, r24 

    ldi r24, 0x02   ; sets timer/counter output compare match A interrupt to true.
    sts _TIMSK0, r24 

    sts _OCR0A, r25

    ldi r24, 0x00   
    sts _TCNT0, r24 ; clear the timer.

    sez; set zero flag 
    sei; start interrupt

    waitLoop_3814ns:
        nop
        breq waitLoop_3814ns; branch if the zero flag is still set

    cli; disable interupts

    ret

_15us_r25:
    ldi r24, 0x00
    sts _TCCR0A, r24

    ldi r24, 0x034  ; set to clk/256, which results in a relative clk rate of 2^16 hz 
                    ; roughly 500 ns per cycle
    sts _TCCR0B, r24 

    ldi r24, 0x02   ; sets timer/counter output compare match A interrupt to true.
    sts _TIMSK0, r24 

    sts _OCR0A, r25

    ldi r24, 0x00   
    sts _TCNT0, r24 ; clear the timer.

    sez; set zero flag 
    sei; start interrupt

    waitLoop_15us:
        nop
        breq waitLoop_15us; branch if the zero flag is still set

    cli; disable interupts

    ret

_61us_r25:
    ldi r24, 0x00
    sts _TCCR0A, r24

    ldi r24, 0x034  ; set to clk/256, which results in a relative clk rate of 2^16 hz 
                    ; roughly 500 ns per cycle
    sts _TCCR0B, r24 

    ldi r24, 0x02   ; sets timer/counter output compare match A interrupt to true.
    sts _TIMSK0, r24 

    sts _OCR0A, r25

    ldi r24, 0x00   
    sts _TCNT0, r24 ; clear the timer.

    sez; set zero flag 
    sei; start interrupt

    waitLoop_61us:
        nop
        breq waitLoop_61us; branch if the zero flag is still set

    cli; disable interupts

    ret
