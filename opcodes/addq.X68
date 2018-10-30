*--------------------------------------------------------------------------------------
* Title         : ADDQ Handler function
* Description   : Handles the ADDQ opcode, outputs the full disassembled instruction
* Manual Page # : 115
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*--------------------------------------------------------------------------------------
ADDQ_OUT        DC.B        'ADDQ',0

LOAD_ADDQ:      MOVE.L      #%0101,D0
                MOVE.L      #4,D1                    
                LEA         HANDLE_ADDQ,A0                              
                JSR         TREE_ADD_NODE
                RTS

HANDLE_ADDQ:    LEA         ADDQ_OUT,A0
                JSR         PRINT_STR
                RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
