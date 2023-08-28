.ifndef STREAM_ASM
.define STREAM_ASM

.ifndef DISPLAY_ASM
.error "display driver not loaded"
.endif

print_word_from_stack:  ;-------------------------------------------------------------------
    rcall wait_BF
    
    pop r31
    pop r30

    sbi _PORTB, _pinRS; set to word mode

    print_loop:
        pop r20
        cpi r20, 0x00

        breq print_loop_end

        rcall send_instruction

        rjmp print_loop

    print_loop_end:

    cbi _PORTB, _pinRS
    push r30
    push r31 

    ret

; r20 - input
push_hex_value:         ;-------------------------------------------------------------------

    eor r16, r16
    eor r16, r20

    andi r16, 0x0F; 0b1111 1111 -> 0b0000 1111
    
    eor r17, r17
    eor r17, r20

    lsr r17 ; 0b1111 0000 -> 0b0000 1111
    lsr r17
    lsr r17
    lsr r17

    eor r20, r20
    eor r20, r16
    rcall get_nibble_hex
    eor r16, r16
    eor r16, r20

    eor r20, r20
    eor r20, r17
    rcall get_nibble_hex
    eor r17, r17
    eor r17, r20

    pop r31
    pop r30

    push r16
    push r17

    push r30
    push r31 

    ret

; r20 - nibble (returns on r20)
get_nibble_hex:       

    push r16
    push r17

    cpi r20, 0x0A
    brbc 0, alphanumeric ; A through F; if 0x09 < r20

    ldi r16, 0x30 ; 0
    rjmp push_value

    alphanumeric:
        ldi r17, 0xF6 
        add r20, r17

        ldi r16, 0x41 ; A

    push_value:
        add r20, r16
    
    pop r17
    pop r16

    ret

; r20 - input
push_binary_value:      ;-------------------------------------------------------------------
    pop r31
    pop r30

    eor r2, r2
    eor r3, r3

    ldi r16, 1
    eor r2, r16

    push_binary_value_loop:
        ldi r16, 0x30

        lsr r20
        brbc 0, push_zero

            add r16, r2; 0x31

        push_zero:

        push r16

        ldi r16, 0x08
        add r3, r2
        cp r3, r16
        brbs 0, push_binary_value_loop

    push r30
    push r31 

    ret

.endif