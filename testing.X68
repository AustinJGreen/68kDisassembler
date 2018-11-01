START:			MOVEA.L		A0,A3
				MOVE.B		D0,D1
				MOVE.W		(A3)+,D7
				MOVEA.W		A2,A3
				MOVE.B		$55FF,D4
				MOVE.B		D4,$8000
				MOVE.L		D0,D1	
				NOP
				RTS
				JSR			START
				JSR			(A0)
				JSR			.TEST
				JSR			$5670FFAA	   
				NOT.L		(A3)+
				NOT.B		-(A0)
.TEST			NOT.B		(A6)
				NOT.W		D5
				OR.B		D0,D1		 
				MOVE.B		D0,D1
				MOVEA.L		A0,A3
				MOVE.L		D0,D1
				ASL.W		D5,D3
				ASL.B		D0,D1
				ASL.B		D0,D2
				ASL.B		#1,D1
				ASL.B		#2,D1
				ASR.B		#2,D1
				ASL.L		#8,D7
				ASL			(A3)+
				ASR			-(A6)
				ASL			(A4)
				ASL			$7FFF
				ASR			$A000
				LSL.W		D5,D3
				LSL.B		D0,D1
				LSL.B		D0,D2
				LSL.B		#1,D1
				LSL.B		#2,D1
				LSR.B		#2,D1
				LSL.L		#8,D7
				LSL			(A3)+
				LSR			-(A6)
				LSL			(A4)
				LSL			$7FFF
				LSR			$A000

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
