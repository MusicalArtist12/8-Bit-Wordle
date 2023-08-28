.ifndef DISPLAY_ASM
.define DISPLAY_ASM

; Julia Abdel-Monem
; July 5, 2023
; written for an Adafruit metro with a atmega328P running at 16Mhz, connected as stated below to a 1602A LCD screen

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

.define _line0 0x00 
.define _line0_end 0x27

.define _line1 0x40 
.define _line1_end 0x67

; PORT B 
.define _pinRS 0x00
.define _pinRW 0x01
.define _pinE  0x02

init_display:           ;-------------------------------------------------------------------
    ; wait 50ms, (61us * 255 * 4)
    ldi r20, 0xFF
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    call _61us
    
    sbi _DDRB, _pinE
    sbi _DDRB, _pinRS
    sbi _DDRB, _pinRW

    cbi _PORTB, _pinE
    cbi _PORTB, _pinRS
    cbi _PORTB, _pinRW

    rcall wait_BF
    
    ret

;     returns r24 = input
recieve_data:         
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
    nop
    nop

    cbi _PORTB, _pinE
    cbi _PORTB, _pinRW
    in r24, _PORTD

    ret

wait_BF:
    cbi _PORTB, _PINRS

    wait_BF_loop_f13b:
        rcall recieve_data
        lsl r24 ; send BF to carry flag

        brcs wait_BF_loop_f13b

    ret 

; r20 = instruction
send_instruction:     
    ; set portD to output
    ldi r16, 0xFF
    out _DDRD, r16
    out _PORTD, r20
    
    ; send instruction
    
    cbi _PORTB, _pinRW
    sbi _PORTB, _pinE 

    ldi r20, 0xFF
    call _500ns 
    
    cbi _PORTB, _pinE

    ret

clear_display:          ;-------------------------------------------------------------------
    rcall wait_BF

    ldi r20, 0x01; PORTD D0:D7 
    rcall send_instruction

    ldi r20, 0xFF
    call _15us

    ret

return_home:            ;-------------------------------------------------------------------
    rcall wait_BF

    ldi r20, 0x02
    rcall send_instruction
    
    ldi r20, 0xFF
    call _15us

    ret

; r20 - bit 0 = cursor position, bit 1 = cursor
display_on:             ;-------------------------------------------------------------------
    rcall wait_BF

    ldi r16, 0x0C ; 0000 1100
    or r20, r16

    rcall send_instruction   

    ret

display_off:            ;-------------------------------------------------------------------
    rcall wait_BF

    ldi r20, 0x0F ; 0000 1000 
    rcall send_instruction   

    ret


; r20 - bit 0 = l/r
cursor_shift:           ;-------------------------------------------------------------------
    rcall wait_BF   

    lsl r20
    lsl r20
    ori r20, 0x10 ; 0001 0n00

    rcall send_instruction 
    ret
    
; r20 - bit 0 = l/r
display_shift:          ;-------------------------------------------------------------------
    rcall wait_BF

    lsl r20
    lsl r20
    ori r20, 0x18 ; 0001 1n00

    rcall send_instruction 
    ret

display_set:            ;-------------------------------------------------------------------
    rcall wait_BF

    ldi r20, 0x3C ; 0011 1100 ~ 8 bit mode, 2 lines, 5x8 font size 
    rcall send_instruction    

    ret

; r20 = ddram addr
set_DDRAM_ADDR:            ;-------------------------------------------------------------------
    rcall wait_BF

    ori r20, 0x80
    rcall send_instruction    

    ret

; r20 = ddram addr
set_CGRAM_ADDR:            ;-------------------------------------------------------------------
    rcall wait_BF

    ori r20, 0x40
    rcall send_instruction    

    ret

.endif