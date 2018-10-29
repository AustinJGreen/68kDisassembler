*-----------------------------------------------------------
* Title      : OR Handler file
* Description: Handles the OR opcode
*-----------------------------------------------------------
OR_OUT         DC.B        'OR',CR,LF,0
HANDLE_OR:
                LEA         OR_OUT,A1
                MOVE.B      #14,D0
                TRAP        #15
                RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
