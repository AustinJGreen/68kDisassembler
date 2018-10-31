START:	
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
				ASL			(A3)+
				ASR			-(A6)
				ASL			(A4)
				ASL			$7FFF
				ASR			$A000










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
