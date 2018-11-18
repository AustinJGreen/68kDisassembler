*-----------------------------------------------------------
* Title		 :	MOVEM Longword Handler function
* Date		 :	11/17/2018
* Description:	Handles the MOVEM OpCode
*-----------------------------------------------------------
*	Constants
*-----------------------------------------------------------
MOVEM_OUT				DC.B	'MOVEM',0

MOVEM_DIR				DS.B	1
MOVEM_SIZE_CODE			DS.L	1
MOVEM_ADDR_REG			DS.L	1
MOVEM_ADDR_MODE			DS.L	1
MOVEM_REG_LIST			DS.L	1

*-----------------------------------------------------------
*	Load MOVEM OpCode into Tree
*-----------------------------------------------------------
LOAD_MOVEM:		MOVEQ	#9,D1				* 9 bits for W and L

				MOVE.L	#%010010001,D0		* Add MOVEM register to memory
				LEA		MOVEM_REG_TO_MEM
				JSR		TREE_ADD_NODE
					
				MOVE.L	#%010011001,D0		* Add MOVEM memory to register
				LEA		MOVEM_MEM_TO_REG
				JSR		TREE_ADD_NODE
					
				RTS
*-----------------------------------------------------------
*	Handle OpCode
*-----------------------------------------------------------

MOVEM_REG_TO_MEM:		MOVEM.L	D0-D7,-(SP)
						MOVE.B	#%00,MOVEM_DIR	
						BRA		.CONTINUE

MOVEM_MEM_TO_REG:		MOVEM.L	D0-D7,-(SP)
						MOVE.B	#%01, MOVEM_DIR
						
						* copy opcode to D7
.CONTINUE				MOVE.L 	D0,D7
						
						* read size code
						ROL.B	#2,D0
						ANDI.L	#%01,D0
						MOVE.L	D0,MOVEM_SIZE_CODE
						
						* read address register
						MOVE.L	D7,D0
   						ANDI.L	#%111,D0
   						MOVE.L	D0,MOVEM_ADDR_REG
   						
   						* shift opcode right
						LSR.L	#3,D7
   						
   						* read address address mode
   						MOVE.L	D7,D0
   						ANDI.L	#%111,D0
						MOVE.L	D0,MOVEM_ADDR_MODE
						
						* read register list
						MOVE.W	(A4)+,MOVEM_REG_LIST						

*-----------------------------------------------------------
*	DISPLAY OpCode
*-----------------------------------------------------------
						LEA			MOVEM_OUT,A0
						JSR			PRINT_STR
												
						* Output the size code					
						MOVE.L		MOVEM_SIZE_CODE,D0				
						MOVE.L		#%010010,D1					
						JSR			PRINT_SIZE
						
						JSR			PRINT_OPCODE_TAB	  
						
*-----------------------------------------------------------
*	DISPLAY Source and Destination
*-----------------------------------------------------------
						CMP.B	#%01,MOVEM_DIR
						BEQ		.MEM_TO_REG
						
.REG_TO_MEM				JSR		MOVEM_AN
						JSR		PRINT_DIVIDER
						JSR		MOVEM_REG_LIST
						BRA			.FIN
						
.MEM_TO_REG				JSR		MOVEM_REG_LIST
						JSR		PRINT_DIVIDER
						JSR		MOVEM_AN
						
.FIN					MOVEM.L	(SP)+,D0-D7
						RTS
						
*-----------------------------------------------------------
*	PRINT_REG_LIST: Prints list of registers
*-----------------------------------------------------------
MOVEM_REG_LIST:		CMP.B	

				RTS
*-----------------------------------------------------------
*	PRINT_REG_LIST: Prints list of registers
*-----------------------------------------------------------				
MOVEM_AN:		MOVE.W	MOVEM_ADDR_REG,D0
				MOVE.W	MOVEM_ADDR_MODE,D1
				
				JSR		PRINT_PARAM

				RTS
*-----------------------------------------------------------





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
