*-----------------------------------------------------------
* Title      :	DIVU Handler function
* Description:	Handles the DIVU opcode, outputs the full 
*				disassembled instruction
*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
DIVU_W_OUT		DC.B	'DIVU.W',0
DIVU_L_OUT		DC.B	'DIVU.L',0
*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------
DIVU_DST_REG	DC.L	1
DIVU_SRC_MODE	DC.L	1
DIVU_SRC_REG	DC.L	1
*-----------------------------------------------------------
*	Load MOVE/MOVEA OpCode into Tree
*-----------------------------------------------------------
LOAD_DIVU		MOVE.L		#%0100110001,D0		* DIVU.L
				MOVE.L		#10,D1
				LEA			HANDLE_DIVU_L,A0
				JSR			TREE_ADD_NODE
				
				MOVE.L		#%1000,D0			* DIVU.W
				MOVE.L		#4,D1
				LEA			HANDLE_DIVU_W,A0
				JSR			TREE_ADD_NODE
				
				RTS
*-----------------------------------------------------------
*	Handle OpCode
*-----------------------------------------------------------				
HANDLE_DIVU_L	MOVEM.L		D0-D7,-(SP)
				MOVE.L		D0,D7
				
				* display OpCode and size
				LEA		DIVU_L_OUT,A1
				MOVE.B	#14,D0
				TRAP	#15
				
				
.FIN:			MOVEM.L		(SP)+,D0-D7
				RTS

HANDLE_DIVU_W	MOVEM.L		D0-D7,-(SP)
				MOVE.L		D0,D7	
		
				* display OpCode and size
				LEA		DIVU_W_OUT,A1	
				MOVE.B	#14,D0
				TRAP	#15
				
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
				
*-----------------------------------------------------------
*	DISPLAY Source
*-----------------------------------------------------------
				MOVE.B	DIVU_SRC_MODE,D1
				MOVE.B	DIVU_SRC_REG,D0
					
				CMPI.B	#%000,D1			* Dn
				BEQ		.S_D_ADDR
										
				CMPI.B	#%010,D1			* (An)
				BEQ		.S_A_DIR_ADDR
						
				CMPI.B	#%011,D1			* (An)+
				BEQ		.S_A_INC_ADDR

				CMPI.B	#%100,D1			* -(An)
				BEQ		.S_A_DEC_ADDR
					
				CMPI.B	#%111,D1			* (XXX).W/(XXX).L/#<data>
				BEQ		.S_DATA_ADDR

.END_SOURCE		JSR		PRINT_DIVIDER
*-----------------------------------------------------------
*	DISPLAY Destination
*-----------------------------------------------------------
						* display destination
				MOVE.B	DIVU_DST_REG,D0
						
				JSR		PRINT_D_REG	
*-----------------------------------------------------------	
.FIN:			MOVEM.L		(SP)+,D0-D7
				RTS				
*-----------------------------------------------------------
*	Source Address Mode Subroutines
*-----------------------------------------------------------
.S_D_ADDR:			JSR		PRINT_D_REG		* Dn
					BRA		.END_SOURCE
*-----------------------------------------------------------				
.S_A_DIR_ADDR:		JSR		PRINT_A_DIR		* (An)
					BRA		.END_SOURCE
*-----------------------------------------------------------
.S_A_INC_ADDR:		JSR		PRINT_A_POST	* (An)+		
					BRA		.END_SOURCE
*-----------------------------------------------------------
.S_A_DEC_ADDR:		JSR		PRINT_A_PRE		* -(An)			
					BRA		.END_SOURCE
*-----------------------------------------------------------
.S_DATA_ADDR:		MOVE.W	(A4)+,A0
					CMPI.B	#%000,D0
					BEQ		.S_ADDR_WORD
					CMPI.B	#$001,D0
					BEQ		.S_ADDR_LONG
					BRA		.S_DATA
					
.S_ADDR_WORD:		MOVE.L	#4,D0		* (XXX).W
					JSR		PRINT_ADDRESS
					BRA		.END_SOURCE		
					
.S_ADDR_LONG:		MOVE.L	#8,D0		* (XXX).W
					JSR		PRINT_ADDRESS					
					BRA		.END_SOURCE		* (XXX).W/(XXX).L/#<data>	

.S_DATA				MOVE.L	#4,D0
					JSR		PRINT_DATA
					BRA		.END_SOURCE
*-----------------------------------------------------------

*-----------------------------------------------------------








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
