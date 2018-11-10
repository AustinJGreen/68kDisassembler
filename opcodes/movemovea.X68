*-----------------------------------------------------------
* Title		 :	MOVE and MOVEA Longword Handler function
* Date		 :	10/29/2018
* Description:	Handles the MOVE and MOVEA OpCode for
*				longword length.
* D6 - Destination register
* D5 - Destination address mode
* D4 - Source address mode
* D3 - Soruce register
*-----------------------------------------------------------
*	Constants
*-----------------------------------------------------------
MOVE_OUT				DC.B	'MOVE',0
MOVEA_OUT				DC.B	'MOVEA',0

MOVE_SIZE_CODE			DS.L	1
MOVE_SRC_REG			DS.L	1
MOVE_SRC_MODE			DS.L	1
MOVE_DST_REG			DS.L	1
MOVE_DST_MODE			DS.L	1

*-----------------------------------------------------------
*	Load MOVE/MOVEA OpCode into Tree
*-----------------------------------------------------------
LOAD_MOVE_MOVEA:		MOVEQ	#4,D1							; All nodes below have 4-bits

						MOVE.L	#%0001,D0						; Add MOVE.B
						LEA		HANDLE_MOVE_MOVEA,A0
						JSR		TREE_ADD_NODE
					
						MOVE.L	#%0011,D0						; Add MOVE.W
						LEA		HANDLE_MOVE_MOVEA,A0
						JSR		TREE_ADD_NODE
					
						MOVE.L	#%0010,D0						; Add MOVE.L
						LEA		HANDLE_MOVE_MOVEA,A0
						JSR		TREE_ADD_NODE
					
						RTS
*-----------------------------------------------------------
*	Handle OpCode
*-----------------------------------------------------------

HANDLE_MOVE_MOVEA:		MOVEM.L	D0-D7,-(SP)	
						
						* copy opcode in D7
						MOVE.L 	D0,D7
						
						* read size
						ANDI.L	#$3000,D0
						ROL.W	#4,D0
						MOVE.L	D0,MOVE_SIZE_CODE
						
						* read source register
						MOVE.L	D7,D0
   						ANDI.L	#%111,D0
   						MOVE.L	D0,MOVE_SRC_REG
   						
   						* shift opcode right
						LSR.L	#3,D7
   						
   						* read source address mode
   						MOVE.L	D7,D0
   						ANDI.L	#%111,D0
						MOVE.L	D0,MOVE_SRC_MODE
						
						* shift opcode right
						LSR.L	#3,D7
						
						* read destination address mode
						MOVE.L	D7,D0
   						ANDI.L	#%111,D0
   						MOVE.L	D0,MOVE_DST_MODE
   						
						* shift opcode right
						LSR.L	#3,D7
												
						* read destination register
						MOVE.L	D7,D0
						ANDI.L	#%111,D0
						MOVE.L	D0,MOVE_DST_REG			

*-----------------------------------------------------------
*	DISPLAY OpCode
*-----------------------------------------------------------
						* if destination is An then this is MOVEA
						MOVE.L		MOVE_DST_MODE,D0
						CMPI.W		#%001,D0	
						BEQ			.DISP_MOVEA

						LEA			MOVE_OUT,A0	* display move
						BRA			.PRINT

.DISP_MOVEA:			LEA			MOVEA_OUT,A0 * load MOVEA string

.PRINT:					JSR			PRINT_STR
						
						; Output the size code					
						MOVE.L		MOVE_SIZE_CODE,D0				; Put size value in D0
						MOVE.L		#%101101,D1						; Put size mask for MOVE in D1
						JSR			PRINT_SIZE
						
						JSR			PRINT_OPCODE_TAB	   				* Print a tab
						
*-----------------------------------------------------------
*	DISPLAY Source
*-----------------------------------------------------------
						MOVE.L	MOVE_SRC_REG,D0
						MOVE.L	MOVE_SRC_MODE,D1
						MOVE.L	MOVE_SIZE_CODE,D2
						MOVE.L	#%101101,D3
						
						JSR		PRINT_PARAM
						
*-----------------------------------------------------------
*	DISPLAY Divider
*-----------------------------------------------------------
						
						JSR		PRINT_DIVIDER

*-----------------------------------------------------------
*	DISPLAY Destination
*-----------------------------------------------------------

						MOVE.L	MOVE_DST_REG,D0
						MOVE.L	MOVE_DST_MODE,D1
						
						JSR		PRINT_PARAM
						
						; Return
						
						MOVEM.L	(SP)+,D0-D7
						RTS











































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
