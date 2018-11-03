*-----------------------------------------------------------
* Title      :	DIVU Handler function
* Description:	Handles the DIVU opcode, outputs the full 
*				disassembled instruction
*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
DIVU_OUT		DC.B	'DIVU',0
*-----------------------------------------------------------
*	Load MOVE/MOVEA OpCode into Tree
*-----------------------------------------------------------
LOAD_DIVU		MOVE.L		#%0100110000,D0		* DIVU.L
				MOVE.L		#10,D1
				LEA			HANDLE_DIVU,A0
				JSR			TREE_ADD_NODE
				
				MOVE.L		#%1000,D0			* DIVU.W
				MOVE.L		#4,D1
				LEA			HANDLE_DIVU,A0
				JSR			HANDLE_DIVU
				
				RTS
*-----------------------------------------------------------
*	Handle OpCode
*-----------------------------------------------------------				
HANDLE_DIVU_W	MOVEM.L		D0-D7,-(SP)
				MOVEM.L		(SP)+,D0-D7

				RTS
HANDLE_DIVU_L

HAND
				MOVEM.L		(SP)+,D0-D7
.END			RTS
*-----------------------------------------------------------

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
