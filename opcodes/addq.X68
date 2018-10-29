*-----------------------------------------------------------
* Title      : ADDQ Handler file
* Description: Handles the ADDQ opcode
*-----------------------------------------------------------
ADDQ_OUT         DC.B        'ADDQ',0

HANDLE_ADDQ:    LEA         ADDQ_OUT,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
