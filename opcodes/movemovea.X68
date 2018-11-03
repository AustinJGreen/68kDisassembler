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
MOVE_OUT			DC.B	'MOVE',0
MOVEA_OUT			DC.B	'MOVEA',0

MOVE_SIZE_CODE		DS.L	1
MOVE_SRC_REG		DS.L	1
MOVE_SRC_MODE		DS.L	1
MOVE_DST_REG		DS.L	1
MOVE_DST_MODE		DS.L	1

*-----------------------------------------------------------
*	Load MOVE/MOVEA OpCode into Tree
*-----------------------------------------------------------
LOAD_MOVE_MOVEA:	MOVEQ	#4,D1							; All nodes below have 4-bits

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

HANDLE_MOVE_MOVEA:	MOVEM.L	D0-D7,-(SP)	
						
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
						MOVE.L	MOVE_DST_MODE,D0
						CMPI.W	#%001,D0	
						BEQ		.DISP_MOVEA

						LEA		MOVE_OUT,A1	* display move
						BRA		.PRINT

.DISP_MOVEA:			LEA		MOVEA_OUT,A1 * load MOVEA string

.PRINT:					MOVE.B	#14,D0
						TRAP	#15
						
						; Output the size code					
						MOVE.L		MOVE_SIZE_CODE,D0				; Put size value in D0
						MOVE.L		#%010011001,D1				; Put size mask for MOVE in D1
						JSR			PRINT_SIZE
						
						JSR		PRINT_OPCODE_TAB	   * Print a tab
						
*-----------------------------------------------------------
*	DISPLAY Source
*-----------------------------------------------------------
						MOVE.L	MOVE_SRC_MODE,D1
						MOVE.L	MOVE_SRC_REG,D0
						
						CMPI.W	#%000,D1			* Dn
						BEQ		.S_D_ADDR
						
						CMPI.W	#%001,D1			* An
						BEQ		.S_A_ADDR
						
						CMPI.W	#%010,D1			* (An)
						BEQ		.S_A_DIR_ADDR
						
						CMPI.W	#%011,D1			* (An)+
						BEQ		.S_A_INC_ADDR

						CMPI.W	#%100,D1			* -(An)
						BEQ		.S_A_DEC_ADDR
						
						CMPI.W	#%111,D1			* (XXX).W/(XXX).L/#<data>
						BEQ		.S_DATA_ADDR

.END_SOURCE				JSR		PRINT_DIVIDER
*-----------------------------------------------------------
*	DISPLAY Destination
*-----------------------------------------------------------
						* display destination
						MOVE.L	MOVE_DST_MODE,D1
						MOVE.L	MOVE_DST_REG,D0
						
						CMPI.W	#%000,D1			* Dn
						BEQ		.D_D_ADDR
						
						CMPI.W	#%001,D1			* An
						BEQ		.D_A_ADDR
						
						CMPI.W	#%010,D1			* (An)
						BEQ		.D_A_DIR_ADDR
						
						CMPI.W	#%011,D1			* (An)+
						BEQ		.D_A_INC_ADDR

						CMPI.W	#%100,D1			* -(An)
						BEQ		.D_A_DEC_ADDR
						
						CMPI.W	#%111,D1			* (XXX).W/(XXX).L/#<data>
						BEQ		.D_DATA_ADDR							
*-----------------------------------------------------------	
					
.END_DEST				MOVEM.L	 (SP)+,D0-D7
.FIN:					RTS

*-----------------------------------------------------------
*	Destination Address Mode methods
*-----------------------------------------------------------
.D_D_ADDR:			JSR		PRINT_D_REG		* Dn
					BRA		.END_DEST
*-----------------------------------------------------------						
.D_A_ADDR:			JSR		PRINT_A_REG		* An	
					BRA		.END_DEST
*-----------------------------------------------------------				
.D_A_DIR_ADDR:		JSR		PRINT_A_DIR		* (An)
					BRA		.END_DEST
*-----------------------------------------------------------
.D_A_INC_ADDR:		JSR		PRINT_A_POST	* (An)+		
					BRA		.END_DEST
*-----------------------------------------------------------
.D_A_DEC_ADDR:		JSR		PRINT_A_PRE		* -(An)			
					BRA		.END_DEST
*-----------------------------------------------------------
.D_DATA_ADDR:		CMPI.B	#%000,D0
					BEQ		.D_DATA_WORD
					BRA		.D_DATA_LONG
.D_DATA_WORD:		MOVE.W	(A4)+,A0
					MOVE.L	#4,D0
					JSR		PRINT_ADDRESS
					BRA		.END_DEST			* (XXX).W/(XXX).L/#<data>
.D_DATA_LONG:		MOVE.L	(A4)+,A0
					MOVE.L	#8,D0
					JSR		PRINT_ADDRESS					
					BRA		.END_DEST			* (XXX).W/(XXX).L/#<data>	
*-----------------------------------------------------------	
*-----------------------------------------------------------
*	Source Address Mode Subroutines
*-----------------------------------------------------------
.S_D_ADDR:			JSR		PRINT_D_REG		* Dn
					BRA		.END_SOURCE
*-----------------------------------------------------------						
.S_A_ADDR:			JSR		PRINT_A_REG		* An	
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
.S_DATA_ADDR:		CMPI.B	#%000,D0
					BEQ		.S_DATA_WORD
					BRA		.S_DATA_LONG
.S_DATA_WORD:		MOVE.W	(A4)+,A0
					MOVE.L	#4,D0
					JSR		PRINT_ADDRESS
					BRA		.END_SOURCE			* (XXX).W/(XXX).L/#<data>
.S_DATA_LONG:		MOVE.L	(A4)+,A0
					MOVE.L	#8,D0
					JSR		PRINT_ADDRESS					
					BRA		.END_SOURCE			* (XXX).W/(XXX).L/#<data>	
*-----------------------------------------------------------








































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
