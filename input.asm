#include "Registers.asm"
#include "delay.asm"

; #define _PORTC 0x08 ; pins [A0:A5]
; #define _DDRC  0x07

; pin 0 - pin 7 on the button pad (l-r)
; 4:7, columns 0:3
; 0:3, rows 0:3                                                                                                                                                                                                                                                                                                                                                                                 
; ex: if pin 0 and 4 had activity, thats '1' 

; row pins will be +3.3V
; column pins will be sunk

; port B

    #define _col0 4 
    #define _col1 5

; port C

    #define _col2 4
    #define _col3 5

    #define _row0 0
    #define _row1 1
    #define _row2 2
    #define _row3 3

.org 0x400

flush_io:
    cbi _PORTC, _row0
    cbi _PORTC, _row1
    cbi _PORTC, _row2
    cbi _PORTC, _row3

    cbi _PORTB, _col0
    cbi _PORTB, _col1
    cbi _PORTC, _col2
    cbi _PORTC, _col3

    ret

init_input:     ; set corresponding column pins as outputs or inputs
    
    ; rows = output
    sbi _DDRC, _row0
    sbi _DDRC, _row1
    sbi _DDRC, _row2
    sbi _DDRC, _row3

    ; column = input
    cbi _DDRB, _col0
    cbi _DDRB, _col1
    cbi _DDRC, _col2
    cbi _DDRC, _col3

    rcall flush_io

    ret 

; r24 = output
read_input:     ; returns 0x00 through 0x44 (first = row, second = column)
    
    ; r17 = current row

    ldi r20, 0xFF

    ldi r17, 1
    sbi _PORTC, _row0

    call _61us
        rcall read_row
        cbi _PORTC, _row0
        cpi r24, 0x00
        brne read_input_return

    ldi r17, 2
    sbi _PORTC, _row1

    call _61us
        rcall read_row
        cbi _PORTC, _row1
        cpi r24, 0x00
        brne read_input_return

    ldi r17, 3
    sbi _PORTC, _row2

    call _61us
        rcall read_row
        cbi _PORTC, _row2
        cpi r24, 0x00
        brne read_input_return

    ldi r17, 4
        sbi _PORTC, _row3
        call _61us

        rcall read_row
        cbi _PORTC, _row3

        cpi r24, 0x00
        brne read_input_return
    
    ldi r17, 0

    read_input_return:
        ; move current row to ms nibble
        
        lsl r17
        lsl r17
        lsl r17
        lsl r17

        add r24, r17


        rcall flush_io
    ret 

; set _PORTC with the row beforehand
; r24 = column returned true, 0 if no button;
read_row:  
    
    ; r24 = pin found
    eor r24, r24

    lds  r16, _PORTB

    ldi r24, 1
        cpi r16, 0x10 ; bit 4 col0
        breq read_row_return

        ldi r24, 2
            cpi r16, 0x20 ; bit 5 col1
            breq read_row_return


    lds r16, _PORTC  

        ldi r24, 3
            cpi r16, 0x10 ; bit 4 col2
            breq read_row_return

        ldi r24, 4
            cpi r16, 0x20 ; bit 5 col3
            breq read_row_return

    ldi r24, 2 ; no input

    read_row_return:

    ret
