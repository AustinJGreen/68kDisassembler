*-----------------------------------------------------------
* Title      : SUB Handler file
* Description: Handles the SUB opcode
*-----------------------------------------------------------
SUB_OUT         DC.B        'SUB',CR,LF,0
HANDLE_SUB:
                LEA         SUB_OUT,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
