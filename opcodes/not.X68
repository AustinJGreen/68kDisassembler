*--------------------------------------------------------------------------------------
* Title         : NOT Handler function
* Description   : Handles the NOT opcode, outputs the full disassembled instruction
* Manual Page # : 252
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*--------------------------------------------------------------------------------------  
NOT_OUT             DC.B        'NOT',0

HANDLE_NOT:         LEA         NOT_OUT,A1
                    MOVE.B      #14,D0
                    TRAP        #15
                    RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
