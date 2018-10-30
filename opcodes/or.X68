*--------------------------------------------------------------------------------------
* Title         : OR Handler function
* Description   : Handles the OR opcode, outputs the full disassembled instruction
* Manual Page # : 254
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*-------------------------------------------------------------------------------------- 
OR_OUT              DC.B        'OR',0

HANDLE_OR:          LEA         OR_OUT,A1
                    MOVE.B      #14,D0
                    TRAP        #15
                    RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
