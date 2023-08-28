.ifndef INPUT_ASM
.define INPUT_ASM

.include "delay.asm"

; port B
.define _col0 4 
.define _col1 5

; port C
.define _col2 4
.define _col3 5

.define _row0 0
.define _row1 1
.define _row2 2
.define _row3 3

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

.endif