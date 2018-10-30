*--------------------------------------------------------------------------------------
* Title         : MOVEQ Handler function
* Description   : Handles the MOVEQ opcode, outputs the full disassembled instruction
* Manual Page # : 238
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*-------------------------------------------------------------------------------------- 
MOVEQ_OUT           DC.B        'MOVEQ',0

HANDLE_MOVEQ:       LEA         MOVEQ_OUT,A1
                    MOVE.B      #14,D0
                    TRAP        #15
                    RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
