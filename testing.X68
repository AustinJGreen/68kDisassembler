START:				NOP

					RTS
					
					JSR			START
					JSR			(A0)
					JSR			.TEST
					JSR			$5670FFAA
					
					NOT.L		(A3)+
					NOT.B		-(A0)
					NOT.B		(A6)
					NOT.W		D5
					
					MOVEA.L		A0,A3
					MOVEA.W		A2,A3
					
					MOVE.B		D0,D1
.TEST				MOVE.W		(A3)+,D7
					MOVE.B		$55FF,D4
					MOVE.B		D4,$8000
					MOVE.L		D0,D1




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
