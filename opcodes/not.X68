*-----------------------------------------------------------
* Title      : NOT Handler file
* Description: Handles the NOT opcode
*-----------------------------------------------------------
NOT_OUT             DC.B        'NOT',0

HANDLE_NOT:         LEA         NOT_OUT,A1
                    MOVE.B      #14,D0
                    TRAP        #15
                    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
