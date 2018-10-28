*-----------------------------------------------------------
* Title      : RTS Handler file
* Description: Handles the RTS opcode
*-----------------------------------------------------------
RTS_OUT         DC.B        'RTS',0
HANDLE_RTS:
                LEA         RTS_OUT,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
