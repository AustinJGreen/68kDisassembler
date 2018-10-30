*--------------------------------------------------------------------------------------
* Title         : MOVE.B Handler function
* Description   : Handles the MOVE.B opcode, outputs the full disassembled instruction
* Manual Page # : 220
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*-------------------------------------------------------------------------------------- 
MOVE_B_OUT          DC.B        'MOVE.B',0

HANDLE_MOVE_B:      LEA         MOVE_B_OUT,A1
                    MOVE.B      #14,D0
                    TRAP        #15
                    RTS







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
