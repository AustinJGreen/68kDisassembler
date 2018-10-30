*--------------------------------------------------------------------------------------
* Title         : JSR Handler function
* Description   : Handles the JSR opcode, outputs the full disassembled instruction
* Manual Page # : 213
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*
* REGISTER USE
* D6 - Holds register value
* D7 - Register used to hold Opcode data
*--------------------------------------------------------------------------------------  
JSR_OUT             DC.B        'JSR',0

LOAD_JSR:           MOVE.L      #%0100111010,D0
                    MOVE.L      #10,D1
                    LEA         HANDLE_JSR,A0
                    JSR         TREE_ADD_NODE
                    RTS

HANDLE_JSR:         LEA         JSR_OUT,A0                  ; Load "JSR"
                    JSR         PRINT_STR
                    RTS














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
