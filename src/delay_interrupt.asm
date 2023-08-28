.ifndef DELAY_INTERRUPT_ASM
.define DELAY_INTERRUPT_ASM

.org 0x001C ; OCR0A
clz ; clear zero flag
reti

.endif