START:  
                NOP
                RTS      
                NOT.L       (A3)+
                NOT.B       -(A0)
                NOT.B       (A6)
                NOT.W       D5          ; For now just test with registers so its only 16-bit opcodes
                OR.B	    D0,D1       
                MOVE.B      D0,D1
                MOVEA.L		A0,A1
                MOVE.L		D0,D1




















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
