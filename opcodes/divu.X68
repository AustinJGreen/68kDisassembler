*-----------------------------------------------------------
* Title      :	DIVU Handler function
* Description:	Handles the DIVU opcode, outputs the full 
*				disassembled instruction
*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
DIVU_OUT		DC.B	'DIVU.W',0
*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------
DIVU_DST_REG	DC.L	1
DIVU_SRC_MODE	DC.L	1
DIVU_SRC_REG	DC.L	1
*-----------------------------------------------------------
*	Load MOVE/MOVEA OpCode into Tree
*-----------------------------------------------------------
LOAD_DIVU		MOVE.L		#%1000000011,D0			* DIVU.W, for D0
				MOVE.L		#10,D1
				LEA			HANDLE_DIVU,A0
				JSR			TREE_ADD_NODE
				
				MOVE.L		#%1000001011,D0			* DIVU.W, for D1
				MOVE.L		#10,D1
				LEA			HANDLE_DIVU,A0
				JSR			TREE_ADD_NODE
				
				MOVE.L		#%1000010011,D0			* DIVU.W, for D2
				MOVE.L		#10,D1
				LEA			HANDLE_DIVU,A0
				JSR			TREE_ADD_NODE
				
				MOVE.L		#%1000011011,D0			* DIVU.W, for D3
				MOVE.L		#10,D1
				LEA			HANDLE_DIVU,A0
				JSR			TREE_ADD_NODE
				
				MOVE.L		#%1000100011,D0			* DIVU.W, for D4
				MOVE.L		#10,D1
				LEA			HANDLE_DIVU,A0
				JSR			TREE_ADD_NODE
				
				MOVE.L		#%1000101011,D0			* DIVU.W, for D5
				MOVE.L		#10,D1
				LEA			HANDLE_DIVU,A0
				JSR			TREE_ADD_NODE
				
				MOVE.L		#%1000110011,D0			* DIVU.W, for D6
				MOVE.L		#10,D1
				LEA			HANDLE_DIVU,A0
				JSR			TREE_ADD_NODE
				
				MOVE.L		#%1000111011,D0			* DIVU.W, for D7
				MOVE.L		#10,D1
				LEA			HANDLE_DIVU,A0
				JSR			TREE_ADD_NODE
				
				RTS
*-----------------------------------------------------------
*	Handle OpCode
*-----------------------------------------------------------				
HANDLE_DIVU:	MOVEM.L		D0-D7,-(SP)
				MOVE.L		D0,D7	
		
				* display OpCode and size
				LEA		DIVU_OUT,A0
				JSR		PRINT_STR
				
				JSR		PRINT_OPCODE_TAB	   * Print a tab
				
				MOVE.L	D7,D0
				
				* Read source register
				MOVE.B	D0,DIVU_SRC_REG
				ANDI.B	#%0111,DIVU_SRC_REG
				
				* shift out source reg
				LSR.L	#3,D0
				
				* Read source address mode
				MOVE.B	D0,DIVU_SRC_MODE
				ANDI.B	#%0111,DIVU_SRC_MODE
				
				* shift out source address mode and destination 
				* size code(always word)
				LSR.L	#6,D0

				* Read destination regsiter
				MOVE.B	D0,DIVU_DST_REG
				ANDI.B	#%0111,DIVU_DST_REG
				
				* DISPLAY Source
				MOVE.B	DIVU_SRC_REG,D0
				MOVE.B	DIVU_SRC_MODE,D1
				MOVE.B	#%11,D2
				MOVE.B	#%001100,D3				
				JSR		PRINT_PARAM
				
				* DISPLAY Divider
				JSR		PRINT_DIVIDER		

				* DISPLAY Destination
				MOVE.B	DIVU_DST_REG,D0
				JSR		PRINT_D_REG	
	
				MOVEM.L		(SP)+,D0-D7
				RTS				













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
