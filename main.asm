; Julia Abdel-Monem
; July 5, 2023
; written for an Adafruit metro with a atmega328P running at 16Mhz

.DEVICE atmega328P
#include "display.asm"
#include "delay.asm"
#include "input.asm"
#include "Registers.asm"

rjmp main

.org 0x100
main:
    rcall init_display
    
    rcall display_set

    ldi r20, 0x03
    rcall display_on
    rcall clear_display
    rcall return_home

    ldi r16, 0x00
    push r16

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


    call print_word_from_stack

    ldi r20, 0xFF
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us

    rcall clear_display
    rcall return_home

    eor r1, r1
    eor r0, r0
    ldi r16, 0x01
    eor r1, r16

    ldi r20, 0x00
    rcall display_on

    loop:
        ldi r20, 0xFF
        call _61us
        call _61us
        call _61us
        call _61us
        call _61us
        call _61us
        call _61us
        call _61us

        rcall clear_display
        rcall return_home

        eor r20, r20
        eor r20, r0
        call print_hex_value

        add r0, r1
        brbc 0, loop


sink:
    sbi _PORTB, 5 
    rjmp sink


