START:			OR.L		#57,D0
				MOVE.L		#57,A5
				MOVE.L		#9,D2
				MOVEA.L		A0,A3
				MOVE.B		D0,D1
				MOVE.W		(A3)+,D7
				MOVEA.W		A2,A3
				MOVE.B		$55FF,D4
				MOVE.B		D4,$8000
				MOVE.L		D0,D1	
				LSL.W		D5,D3
				LSL.B		D0,D1
				LSL.B		D0,D2
				LSL.B		#1,D1
				LSL.B		#2,D1
				LSR.B		#2,D1
				LSL.L		#8,D7
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
				LSL			(A3)+
				LSR			-(A6)
				LSL			(A4)
				LSL			$7FFF
				LSR			$A000
				DIVU.W		#$5A23,D0
				DIVU.W		$55FF,D1
				DIVU.W		D2,D3
				DIVU.W		(A1),D5
				DIVU.W		(A0)+,D6
				DIVU.W		-(A0),D7
				MULS.W		D4,D1
				MULS.W		#$BEEF,D0
				MULS.W		(A1),D5
				MULS.W		(A0)+,D6
				MULS.W		-(A0),D7
				MULS.W		$546A,D1
				OR.B		D0,D1
				OR.W		#$FFFF,D6
				OR.L		D6,(A4)+
				OR.L		-(A3),D7
				








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
