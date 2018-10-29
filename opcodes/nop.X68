*-----------------------------------------------------------
* Title      : NOP Handler file
* Description: Handles the NOP opcode
*-----------------------------------------------------------  
NOP_OUT         DC.B        'NOP',CR,LF,0
HANDLE_NOP:
                LEA         NOP_OUT,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
