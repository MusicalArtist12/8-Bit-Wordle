.DEVICE atmega328P
#include "display.asm"
#include "delay.asm"

rjmp main

.org 0x100
main:
    rcall init_display
    
    rcall display_set
    rcall display_on
    rcall clear_display
    rcall return_home

    ldi r16, 0x64; char = d
    push r16

    ldi r16, 0x6C; char = l
    push r16

    ldi r16, 0x72; char = r
    push r16

    ldi r16, 0x6F; char = o
    push r16

    ldi r16, 0x57; char = W
    push r16

    ldi r16, 0x20; char =  
    push r16

    ldi r16, 0x6F; char = o
    push r16

    ldi r16, 0x6C; char = l
    push r16

    ldi r16, 0x6C; char = l
    push r16

    ldi r16, 0x65; char = e
    push r16

    ldi r16, 0x48; char = H
    push r16

    ldi r16, 11
    push r16


    call print_word_from_stack


sink:
    sbi _PORTB, 5 
    rjmp sink