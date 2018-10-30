*--------------------------------------------------------------------------------------
* Title         : NOP Handler function
* Description   : Handles the NOP opcode, outputs the full disassembled instruction
* Manual Page # : 251
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*--------------------------------------------------------------------------------------  
NOP_OUT             DC.B        'NOP',0

HANDLE_NOP:         LEA         NOP_OUT,A1
                    MOVE.B      #14,D0
                    TRAP        #15
                    RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
