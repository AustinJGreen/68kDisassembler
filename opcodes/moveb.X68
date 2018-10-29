*-----------------------------------------------------------
* Title      : MOVE.B Handler file
* Description: Handles the MOVE opcode for Byte length
*-----------------------------------------------------------
MOVE_B_OUT          DC.B        'MOVE.B',0

HANDLE_MOVE_B:      LEA         MOVE_B_OUT,A1
                    MOVE.B      #14,D0
                    TRAP        #15
                    RTS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
