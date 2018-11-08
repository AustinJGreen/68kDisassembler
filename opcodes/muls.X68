*-----------------------------------------------------------
* Title      :  MULS Handler Function
* Description:	Handles the MULS opcode, outputs the full
*				disassembled instruction
*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
MULS_OUT		DC.B	'MULS.W',0
*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------
MULS_DST_REG	DC.L	1
MULS_SRC_MODE	DC.L	1
MULS_SRC_REG	DC.L	1
*-----------------------------------------------------------
*	Load MULS.W OpCode into Tree
*-----------------------------------------------------------
LOAD_MULS		MOVE.L	#%1100000111,D0				*MULS.W for D0
				MOVE.L	#10,D1
				LEA		HANDLE_MULS,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100001111,D0				*MULS.W for D1
				MOVE.L	#10,D1
				LEA		HANDLE_MULS,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100010111,D0				*MULS.W for D2
				MOVE.L	#10,D1
				LEA		HANDLE_MULS,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100011111,D0				*MULS.W for D3
				MOVE.L	#10,D1
				LEA		HANDLE_MULS,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100100111,D0				*MULS.W for D4
				MOVE.L	#10,D1
				LEA		HANDLE_MULS,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100101111,D0				*MULS.W for D5
				MOVE.L	#10,D1
				LEA		HANDLE_MULS,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100110111,D0				*MULS.W for D6
				MOVE.L	#10,D1
				LEA		HANDLE_MULS,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100111111,D0				*MULS.W for D7
				MOVE.L	#10,D1
				LEA		HANDLE_MULS,A0
				JSR		TREE_ADD_NODE
				
				RTS
*----------------------------------------------------------
*	Handle OpCode
*----------------------------------------------------------
HANDLE_MULS MOVEM.L		D0-D7,-(SP)
				MOVE.L		D0,D7
				
				* diplay OpCode and size
				LEA		MULS_OUT,A1
				MOVE.B	#14,D0
				TRAP	#15
				
				JSR		PRINT_OPCODE_TAB			*Print a tab
				
				MOVE.L	D7,D0
				
				* Read source Register
				MOVE.B	D0,MULS_SRC_REG
				ANDI.B	#%0111,MULS_SRC_REG
				
				* Shift out of source reg
				LSR.L	#3,D0
				
				*Read source address mode
				MOVE.B	D0,MULS_SRC_MODE
				ANDI.B	#%0111,MULS_SRC_MODE
				
				* shift out source address mode and destination 
				* size code(always word)
				LSR.L	#6,D0
				
				* Read destination register
				MOVE.B	D0,MULS_DST_REG
				ANDI.B	#%0111,MULS_DST_REG
				
				*Display Source
				MOVE.B	MULS_SRC_MODE,D1
				MOVE.B	MULS_SRC_REG,D0
				
				CMPI.B	#%000,D1			*Dn
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

				*Display Destination
				MOVE.B	MULS_DST_REG,D0
				JSR		PRINT_D_REG
				
.FIN:			MOVEM.L	(SP)+,D0-D7
				RTS

*-----------------------------------------------------------
*	Source Address Mode Subroutines
*-----------------------------------------------------------
.S_D_ADDR:		JSR		PRINT_D_REG			*Dn
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
.S_DATA_ADDR:		MOVE.L	(A4)+,A0
					CMPI.B	#%000,D0
					BEQ		.S_ADDR_WORD
					CMPI.B	#$001,D0
					BEQ		.S_ADDR_LONG
					BRA		.S_DATA
					
.S_ADDR_WORD:		MOVE.L	#4,D0			* (XXX).W
					JSR		PRINT_ADDRESS
					BRA		.END_SOURCE		
					
.S_ADDR_LONG:		MOVE.L	#8,D0			* (XXX).L
					JSR		PRINT_ADDRESS					
					BRA		.END_SOURCE		* #<data>	

.S_DATA				MOVE.L	#4,D0
					JSR		PRINT_DATA
					BRA		.END_SOURCE
*-----------------------------------------------------------









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
