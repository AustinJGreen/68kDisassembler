*-----------------------------------------------------------
* Title      :	MOVE and MOVEA Longword Handler function
* Written by :	Damian
* Date       :  10/29/2018
* Description:  Handles the MOVE and MOVEA OpCode for
*				longword length.
*-----------------------------------------------------------
*	Constants
*-----------------------------------------------------------
ADDRESS_REGISTER	DC.B	'A',0
MOVE_L_OUT			DC.B	'MOVE.L',0
MOVEA_L_OUT		DC.B	'MOVEA.L A',0
*-----------------------------------------------------------
*	Load MOVE.L/MOVEA.L OpCode into Tree
*-----------------------------------------------------------
LOAD_MOVE_MOVEA_L:	MOVE.L	#%0010,D0
					MOVE.L	#4,D1
					LEA		HANDLE_MOVE_MOVEA_L,A0
					JSR		TREE_ADD_NODE
					RTS
*-----------------------------------------------------------
*	Handle OpCode
*-----------------------------------------------------------

HANDLE_MOVE_MOVEA_L:	MOVEM.L	D0-D7,-(SP)	
						
						* read destination address mode
						MOVE.L 	D0,D1
						AND.L	#%000111000000,D1
						LSR.L	#6,D1
						
						* if destination is An then this is MOVEA
						CMP.W	#%001,D1		
						BEQ		.HANDLE_MOVEA
						
						LEA		MOVE_L_OUT,A1	* print MOVE.L
						MOVE.B	#14,D0
						TRAP	#15
						BRA 	.END


.HANDLE_MOVEA			LEA		MOVEA_L_OUT,A1	
						MOVE.B	#14,D0
						TRAP	#15
						
						* read An register
						CLR.L	D1
						MOVE.L	D7,D1
						LSR.L	#8,D1
						LSR.L	#1,D1
   

						MOVEM.L     (SP)+,D0-D7
.END					RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
