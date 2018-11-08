*-----------------------------------------------------------
* Title      :  AND Handler Function
* Description:	Handles the AND opcode, outputs the full
*				disassembled instruction
*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
AND_OUT			DC.B	'AND.',0
B_OUT			DC.B	'B',0
W_OUT			DC.B	'W',0
L_OUT			DC.B	'L',0
*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------
ENTIRE_OP		DC.L	1
AND_SIZE		DC.L	1
AND_DN_REG		DC.L	1
AND_EA_MODE		DC.L	1
AND_EA_REG		DC.L	1
*-----------------------------------------------------------
*	Load AND OpCode into Tree
*-----------------------------------------------------------
	
				*<ea>,Dn - > Dn
				*Byte size
LOAD_AND		MOVE.L	#%1100000000,D0				*AND.B for D0
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100001000,D0				*AND.B for D1
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100010000,D0				*AND.B for D2
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100011000,D0				*AND.B for D3
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100100000,D0				*AND.B for D4
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100101000,D0				*AND.B for D5
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100110000,D0				*AND.B for D6
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100111000,D0				*AND.B for D7
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				*Word size
				MOVE.L	#%1100000001,D0				*AND.W for D0
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100001001,D0				*AND.W for D1
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100010001,D0				*AND.W for D2
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100011001,D0				*AND.W for D3
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100100001,D0				*AND.W for D4
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100101001,D0				*AND.W for D5
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100110001,D0				*AND.W for D6
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100111001,D0				*AND.W for D7
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				*Long size
				MOVE.L	#%1100000010,D0				*AND.L for D0
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100001010,D0				*AND.L for D1
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100010010,D0				*AND.L for D2
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100011010,D0				*AND.L for D3
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100100010,D0				*AND.L for D4
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100101010,D0				*AND.L for D5
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100110010,D0				*AND.L for D6
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100111010,D0				*AND.L for D7
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				*Dn,<ea> -> <ea>
				*Byte Size
				MOVE.L	#%1100000100,D0				*AND.B for D0
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100001100,D0				*AND.B for D1
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100010100,D0				*AND.B for D2
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100011100,D0				*AND.B for D3
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100100100,D0				*AND.B for D4
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100101100,D0				*AND.B for D5
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
			
				MOVE.L	#%1100110100,D0				*AND.B for D6
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100111100,D0				*AND.B for D7
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				*Word Size
				MOVE.L	#%1100000101,D0				*AND.W for D0
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100001101,D0				*AND.W for D1
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100010101,D0				*AND.W for D2
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100011101,D0				*AND.W for D3
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100100101,D0				*AND.W for D4
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100101101,D0				*AND.W for D5
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
			
				MOVE.L	#%1100110101,D0				*AND.W for D6
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100111101,D0				*AND.W for D7
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE

				*Long Size
				MOVE.L	#%1100000110,D0				*AND.L for D0
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100001110,D0				*AND.L for D1
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100010110,D0				*AND.L for D2
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100011110,D0				*AND.L for D3
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100100110,D0				*AND.L for D4
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100101110,D0				*AND.L for D5
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
			
				MOVE.L	#%1100110110,D0				*AND.L for D6
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE
				
				MOVE.L	#%1100111110,D0				*AND.L for D7
				MOVE.L	#10,D1
				LEA		HANDLE_AND,A0
				JSR		TREE_ADD_NODE

				RTS
			
*----------------------------------------------------------
*	Handle OpCode
*----------------------------------------------------------
HANDLE_AND MOVEM.L	D0-D7,-(SP)
				MOVE.L	D0,ENTIRE_OP              *Stores the entire entry for reuse
				
				* display OpCode
				LEA		AND_OUT,A1
				MOVE.B	#14,D0
				TRAP	#15
								
				MOVE.L	ENTIRE_OP,D0				
				*shifts out 6bits to determine size
				LSR.L	#6,D0					 
				MOVE.B	D0,AND_SIZE
				ANDI.B	#%0111,AND_SIZE
				
				*Read/Print Size
				CMPI.B	#%000,AND_SIZE
				BEQ		.P_B
				CMPI.B	#%100,AND_SIZE
				BEQ		.P_B
				CMPI.B	#%001,AND_SIZE
				BEQ		.P_W
				CMPI.B	#%101,AND_SIZE
				BEQ		.P_W
				CMPI.B	#%010,AND_SIZE
				BEQ		.P_L
				CMPI.B	#%110,AND_SIZE
				BEQ		.P_L
		
				*Seperates and saves the key fields into constants		
.HANDLE_AND_CONT JSR	PRINT_OPCODE_TAB
				
				MOVE.L	ENTIRE_OP,D0	
				*Read source Register
				MOVE.B	D0,AND_EA_REG
				ANDI.B	#%0111,AND_EA_REG
				LSR.L	#3,D0						*shift 3 bits out
				*Read source address mode
				MOVE.B	D0,AND_EA_MODE
				ANDI.B	#%0111,AND_EA_MODE
				LSR.L	#6,D0                       *shift 6 bits out, size already determined
				*Read destination register
				MOVE.B	D0,AND_DN_REG
				ANDI.B	#%0111,AND_DN_REG
				
				*Load Key codes
				CLR		D0
				CLR     D1
				CLR		D2
				CLR		D3
				MOVE.B	AND_EA_REG,D0				
				MOVE.B	AND_EA_MODE,D1
				MOVE.B	AND_DN_REG,D2
				MOVE.B	AND_SIZE,D3
				
				*Use OpMode(size) to determine print
				CMPI.B #%000,D3						*<ea>,Dn - > Dn Mode (Byte)
				BEQ		.DN_PRINT
				CMPI.B #%001,D3						*<ea>,Dn - > Dn Mode (Word)
				BEQ		.DN_PRINT
				CMPI.B #%010,D3						*<ea>,Dn - > Dn Mode (Long)	
				BEQ		.DN_PRINT
				CMPI.B #%100,D3						*Dn,<ea> - > <ea> Mode (Byte)
				BEQ		.EA_PRINT
				CMPI.B #%101,D3						*Dn,<ea> - > <ea> Mode (Word)
				BEQ		.EA_PRINT
				CMPI.B #%110,D3						*Dn,<ea> - > <ea> Mode (Long)
				BEQ		.EA_PRINT
					
					

.FIN:			MOVEM.L	(SP)+,D0-D7
				RTS		
*----------------------------------------------------------
*	Print size Subroutines
*----------------------------------------------------------
.P_B LEA	B_OUT,A1
				MOVE.L	#14,D0
				TRAP	#15
				BRA		.HANDLE_AND_CONT
*----------------------------------------------------------
.P_W LEA	W_OUT,A1

				MOVE.L	#14,D0
				TRAP	#15
				BRA		.HANDLE_AND_CONT
*----------------------------------------------------------
.P_L LEA	L_OUT,A1
				MOVE.L	#14,D0
				TRAP	#15
				BRA		.HANDLE_AND_CONT				
*----------------------------------------------------------
*	<ea>,DN - > DN  Print subroutine
*----------------------------------------------------------
.DN_PRINT CMPI.B	#$000,D1						* Dn   (Dn - > Dn)
				BEQ		.DN_D_ADDR
				
				CMPI.B	#%010,D1					* (An)
				BEQ		.DN_A_DIR_ADDR
				
				CMPI.B	#%011,D1
				BEQ		.DN_A_INC_ADDR				* (An)+
				
				CMPI.B	#%100,D1
				BEQ		.DN_A_DEC_ADDR				* -(An)
				
				CMPI.B	#%111,D1
				BEQ		.DN_DATA_ADDR				* (XXX).W / (XXX.L)
				
.DN_END_SOURCE	JSR		PRINT_DIVIDER

				*Display destination
				MOVE.B	AND_DN_REG,D0
				JSR		PRINT_D_REG
				BRA		.FIN
				

*----------------------------------------------------------
*	DN,<ea> - > <ea>  Print subroutine
*----------------------------------------------------------
.EA_PRINT	MOVE.B		D2,D0
				JSR		PRINT_D_REG
				JSR		PRINT_DIVIDER
				MOVE	AND_EA_REG,D0
			
				CMPI.B	#%010,D1					* (An)
				BEQ		.EA_A_DIR_ADDR
			
				CMPI.B	#%011,D1					* (An)+
				BEQ		.EA_A_INC_ADDR
				
				CMPI.B	#%100,D1
				BEQ		.EA_A_DEC_ADDR				* -(An)
				
				CMPI.B	#%111,D1					* (XXX).W / (XXX.L) / #<data>
				BEQ		.EA_DATA_ADDR
				
.EA_END_SOURCE	BRA		.FIN

*----------------------------------------------------------

*-----------------------------------------------------------
*	<ea>,DN-> DN Address Mode Subroutines
*-----------------------------------------------------------
.DN_D_ADDR:	JSR		PRINT_D_REG			*Dn
				BRA		.DN_END_SOURCE
*-----------------------------------------------------------				
.DN_A_DIR_ADDR:	JSR		PRINT_A_DIR		* (An)
					BRA		.DN_END_SOURCE
*-----------------------------------------------------------
.DN_A_INC_ADDR:	JSR		PRINT_A_POST	* (An)+		
					BRA		.DN_END_SOURCE
*-----------------------------------------------------------
.DN_A_DEC_ADDR:	JSR		PRINT_A_PRE		* -(An)			
					BRA		.DN_END_SOURCE
*-----------------------------------------------------------
.DN_DATA_ADDR:	MOVE.L	(A4)+,A0
					CMPI.B	#%000,D0
					BEQ		.DN_ADDR_WORD
					CMPI.B	#$001,D0
					BEQ		.DN_ADDR_LONG
					BRA		.DN_DATA         * SHOULD NEVER TRIGGER
					
.DN_ADDR_WORD:		MOVE.L	#4,D0			* (XXX).W
					JSR		PRINT_ADDRESS
					BRA		.DN_END_SOURCE		
					
.DN_ADDR_LONG:		MOVE.L	#8,D0			* (XXX).L
					JSR		PRINT_ADDRESS					
					BRA		.DN_END_SOURCE		* #<data>	

.DN_DATA				MOVE.L	#4,D0
					JSR		PRINT_DATA
					BRA		.DN_END_SOURCE
*-----------------------------------------------------------

*-----------------------------------------------------------
*	DN,<ea>-> <ea> Address Mode Subroutines
*-----------------------------------------------------------
.EA_D_ADDR:	JSR		PRINT_D_REG			*Dn
				BRA		.EA_END_SOURCE
*-----------------------------------------------------------				
.EA_A_DIR_ADDR:	JSR		PRINT_A_DIR		* (An)
					BRA		.EA_END_SOURCE
*-----------------------------------------------------------
.EA_A_INC_ADDR:	JSR		PRINT_A_POST	* (An)+		
					BRA		.EA_END_SOURCE
*-----------------------------------------------------------
.EA_A_DEC_ADDR:	JSR		PRINT_A_PRE		* -(An)			
					BRA		.EA_END_SOURCE
*-----------------------------------------------------------
.EA_DATA_ADDR:	MOVE.L	(A4)+,A0
					CMPI.B	#%000,D0
					BEQ		.EA_ADDR_WORD
					CMPI.B	#$001,D0
					BEQ		.EA_ADDR_LONG
					BRA		.EA_DATA
					
.EA_ADDR_WORD:		MOVE.L	#4,D0			* (XXX).W
					JSR		PRINT_ADDRESS
					BRA		.EA_END_SOURCE		
					
.EA_ADDR_LONG:		MOVE.L	#8,D0			* (XXX).L
					JSR		PRINT_ADDRESS					
					BRA		.EA_END_SOURCE		* #<data>	

.EA_DATA				MOVE.L	#4,D0
					JSR		PRINT_DATA
					BRA		.EA_END_SOURCE
*-----------------------------------------------------------








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
