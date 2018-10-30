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

LOAD_MOVE_B:        MOVE.L      #%0001,D0
                    MOVE.L      #4,D1                    
                    LEA         HANDLE_MOVE_B,A0                              
                    JSR         TREE_ADD_NODE
                    RTS

HANDLE_MOVE_B:      LEA         MOVE_B_OUT,A0
                    JSR         PRINT_STR
                    RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
