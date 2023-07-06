;.DEVICE atmega328P

; TL,DR: PORTB has the control pins, PORTD has the data pins

;    VSS - gnd
;    VDD - +5.0V
;    V0 - 5.0V/contrast
;    A - +5.0V
;    K - gnd
;    RS - pin 8 
;    RW - pin 9
;    E - pin 10
;    D0-D7 - pin 0-7 

; (i/o addresses, use in/out, sbi/cbi)
.equ _DDRB = 0x04 ; pins [8:13]
.equ _PORTB = 0x05 

    .equ _pinRS = 0x00
    .equ _pinRW = 0x01
    .equ _pinE  = 0x02

.equ _PIND = 0x09
.equ _DDRD = 0x0A ; pins [0:7]
.equ _PORTD = 0x0B

.org 0x200 ; should be able to rjmp from init
init_display:           ;-------------------------------------------------------------------
    ; wait 50ms, (61us * 255 * 4)
    ldi r25, 0xFF
    rcall _61us_r25
    rcall _61us_r25
    rcall _61us_r25
    rcall _61us_r25

    ldi r16, 0xFF
    out _DDRB, r16 

    ldi r16, 0x00
    out _PORTB, r16

    rcall wait_BF
    
    ret

send_instruction:       ;-------------------------------------------------------------------
    ldi r16, 0xFF
    out _DDRD, r16
    
    ; assumes instruction is loaded into PORTD
    cbi _PORTB, _pinRW
    sbi _PORTB, _pinE 

    ;wait 1200 ns/ 1.20 us 

    eor r16, r16
    ldi r18, 1
    
    send_instruction_loop_5a5c:
        add r16, r18 
        nop
        cpi r16, 0xFF

        brbc 1, send_instruction_loop_5a5c  
    
    cbi _PORTB, _pinE

    ret

r16_recieve_data:         ;-------------------------------------------------------------------
    ; assumes everything is set

    ldi r16, 0x00 ; set PORTD to input
    out _PORTD, r16
    out _DDRD, r16
    
    eor r16, r16

    sbi _PORTB, _pinRW
    sbi _PORTB, _pinE 

    ; 59ns * 2
    nop
    nop
    nop

    cbi _PORTB, _pinE
    cbi _PORTB, _pinRW

    in r16, _PORTD

    nop
    nop
    nop


    ret

wait_BF:                ;-------------------------------------------------------------------
    cbi _PORTB, _PINRS

    wait_BF_loop_f13b:
        sbi _PORTB, 3
        rcall r16_recieve_data
        
        lsl r16 ; send BF to carry flag

        brcs wait_BF_loop_f13b

    cbi _PORTB, 3

    ret

display_on:             ;-------------------------------------------------------------------
    rcall wait_BF
    ldi r16, 0x0F ; 0000 1111 ~ display on, cursor on, cursor position on
    out _PORTD, r16
    
    rcall send_instruction   
    ret

display_off:            ;-------------------------------------------------------------------
    rcall wait_BF
    ldi r16, 0x0F ; 0000 1000 
    out _PORTD, r16
    
    rcall send_instruction   
    ret

display_set:            ;-------------------------------------------------------------------
    rcall wait_BF

    ldi r16, 0x3C ; 0011 1100 ~ 8 bit mode, 2 lines, 5x8 font size 
    out _PORTD, r16

    rcall send_instruction    
    ret

clear_display:          ;-------------------------------------------------------------------
    rcall wait_BF

    ldi r16, 0x01; PORTD D0:D7 
    out _PORTD, r16

    rcall send_instruction
    ldi r25, 0xFF
    call _15us_r25

    ret

return_home:            ;-------------------------------------------------------------------
    rcall wait_BF

    ldi r16, 0x02
    out _PORTD, r16

    rcall send_instruction
    
    ldi r25, 0xFF
    call _15us_r25

    ret

print_word_from_stack:  ;-------------------------------------------------------------------
    rcall wait_BF
    
    pop r31
    pop r30

    pop r19
    ldi r20, 0xFF

    sbi _PORTB, _pinRS; set to word mode


    print_loop:
        pop r16
        out _PORTD, r16
        rcall send_instruction

        ADD r19, r20; r19--

        brbc 1, print_loop


    cbi _PORTB, _pinRS
    push r30
    push r31 

    ret

;   64 6C 72 6F 57 20 6F 6C 6C 65 48     

