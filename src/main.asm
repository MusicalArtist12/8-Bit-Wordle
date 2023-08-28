; Julia Abdel-Monem
; July 5, 2023
; written for an Adafruit metro with a atmega328P running at 16Mhz

.DEVICE atmega328P
.include "delay_interrupt.asm"
.include "registers.asm"

.org 0x000
rjmp main

.org 0x100
main:
    call init_display
    
    call display_set

    ldi r20, 0x03
    call display_on
    call clear_display
    call return_home

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


    ldi r20, _line1
    call set_DDRAM_ADDR

    eor r1, r1
    eor r0, r0
    ldi r16, 0x01
    eor r0, r16

    ldi r20, 0x00
    call display_on

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

        ldi r20, _line1
        rcall set_DDRAM_ADDR

        ldi r16, 0x00
        push r16

        eor r20, r20
        eor r20, r1
        call push_binary_value

        ldi r16, 0x20
        push r16

        eor r20, r20
        eor r20, r1
        call push_hex_value

        call print_word_from_stack

        add r1, r0
        brbc 0, loop

sink:
    sbi _PORTB, 5 
    rjmp sink

.include "display.asm"
.include "stream.asm"
.include "delay.asm"

