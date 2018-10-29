*-----------------------------------------------------------
* Title      : MOVEQ Handler file
* Description: Handles the MOVEQ opcode
*-----------------------------------------------------------
MOVEQ_OUT         DC.B        'MOVEQ',CR,LF,0
HANDLE_MOVEQ:
                LEA         MOVEQ_OUT,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
