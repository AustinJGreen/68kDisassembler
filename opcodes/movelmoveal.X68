*-----------------------------------------------------------
* Title      :	MOVE and MOVEA Longword Handler function
* Written by :	Damian
* Date       :  10/29/2018
* Description:  Handles the MOVE and MOVEA OpCode for
*				longword length.
* D6 - Destination register
* D5 - Destination address mode
* D4 - Source address mode
* D3 - Soruce register
*-----------------------------------------------------------
*	Constants
*-----------------------------------------------------------
MOVE_L_OUT			DC.B	'MOVE.L',0
MOVEA_L_OUT			DC.B	'MOVEA.L',0
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

HANDLE_MOVE_MOVEA_L:		MOVEM.L	D0-D7,-(SP)	
						MOVE.L D0,D7
						
						MOVE.L	D7,D1
						
						* read source register
   						MOVE.L	D1,D3
   						AND.L	#%111,D3
   						LSR.L	#3,D1
   						
   						* read source address mode
   						MOVE.L	D1,D4
   						AND.L	#%111,D4
						LSR.L	#3,D1
						
						* read destination address mode
   						MOVE.L	D1,D5
   						AND.L	#%111,D5
						LSR.L	#3,D1
												
						* read destination register
						MOVE.L	D1,D6	
						AND.L	#%111,D6			

*-----------------------------------------------------------
*	DISPLAY OpCode
*-----------------------------------------------------------
						* if destination is An then this is MOVEA
						CMP.W	#%001,D5	
						BEQ		.DISP_MOVEA

						LEA		MOVE_L_OUT,A1	* display move
						BRA		.PRINT

.DISP_MOVEA:			LEA		MOVEA_L_OUT,A1	* load MOVEA.L string

.PRINT:					MOVE.B	#14,D0
						TRAP		#15
						
						JSR         PRINT_TAB    * Print a tab
						
*-----------------------------------------------------------
*	DISPLAY Source
*-----------------------------------------------------------
						MOVE.L	D4,D2	* source address mode
						MOVE.L	D3,D0	* source reg
						
						CMP.W	#%000,D4			* Dn
						BEQ		.S_D_ADDR
						
						CMP.W	#%001,D4			* An
						BEQ		.S_A_ADDR
						
						CMP.W	#%010,D4			* (An)
						BEQ		.S_A_DIR_ADDR
						
						CMP.W	#%011,D4			* (An)+
						BEQ		.S_A_INC_ADDR

						CMP.W	#%100,D4			* -(An)
						BEQ		.S_A_DEC_ADDR
						
						CMP.W	#%111,D4			* (XXX).W/(XXX).L/#<data>
						BEQ		.S_DATA_ADDR

.END_SOURCE				JSR		PRINT_DIVIDER
*-----------------------------------------------------------
*	DISPLAY Destination
*-----------------------------------------------------------
						* display destination
						MOVE.L	D5,D2	* destination address move
						MOVE.L	D6,D0	* destination reg
						
						CMP.W	#%000,D5			* Dn
						BEQ		.D_D_ADDR
						
						CMP.W	#%001,D5			* An
						BEQ		.D_A_ADDR
						
						CMP.W	#%010,D5			* (An)
						BEQ		.D_A_DIR_ADDR
						
						CMP.W	#%011,D5			* (An)+
						BEQ		.D_A_INC_ADDR

						CMP.W	#%100,D5			* -(An)
						BEQ		.D_A_DEC_ADDR
						
						CMP.W	#%111,D5			* (XXX).W/(XXX).L/#<data>
						BEQ		.D_DATA_ADDR							
*-----------------------------------------------------------	
					
.END_DEST				MOVEM.L     (SP)+,D0-D7
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
* TO_DO
.D_DATA_ADDR:		BRA		.END_DEST			* (XXX).W/(XXX).L/#<data>	
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
* TO_DO
.S_DATA_ADDR:		BRA		.END_SOURCE			* (XXX).W/(XXX).L/#<data>	
*-----------------------------------------------------------
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
