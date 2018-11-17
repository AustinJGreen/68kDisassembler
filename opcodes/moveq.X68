*--------------------------------------------------------------------------------------
* Title			: MOVEQ Handler function
* Description	: Handles the MOVEQ opcode, outputs the full disassembled instruction
* Manual Page # : 238
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*-------------------------------------------------------------------------------------- 
* Variables
*-------------------------------------------------------------------------------------- 
MOVEQ_OUT			DC.B	'MOVEQ',0

MOVEQ_DST_REG		DS.W	1
MOVEQ_DATA			DS.W	1

*-------------------------------------------------------------------------------------- 
*	Load MOVEQ OpCode into Tree
*-------------------------------------------------------------------------------------- 

LOAD_MOVEQ:			MOVE.L		#%0111,D0
					MOVE.L		#4,D1					 
					LEA			HANDLE_MOVEQ,A0								 
					JSR			TREE_ADD_NODE
					RTS
*-------------------------------------------------------------------------------------- 
*	Handle OpCode
*-------------------------------------------------------------------------------------- 
HANDLE_MOVEQ:		MOVEM.L		D0-D7,-(SP)
					MOVE.L		D0,D7
					
					* print MOVEQ 
					LEA			MOVEQ_OUT,A0
					JSR			PRINT_STR
					
					JSR			PRINT_OPCODE_TAB
					
					* read dest register
					ASL.W		#4,D0	* shift out opcode
					ROL.W		#3,D0 	*rotate register to front
					
					MOVE.W		D0,D2
					ANDI.W		#%111,D2
					MOVE.W		D2,MOVEQ_DST_REG
					
					* read eight bit data
					ASR.W	 	#7,D0
					ANDI.L		#$FF,D0
					MOVE.W		D0,MOVEQ_DATA
*-------------------------------------------------------------------------------------- 
*	Print Operands
*--------------------------------------------------------------------------------------					
					MOVEA.L		A0,A1						; Save A0 in A1
					LEA			DECDATA_STR,A0				' Write '#$'
					JSR			PRINT_STR
					

					MOVEA.W		MOVEQ_DATA,A0
					MOVE.W		#2,D0
					JSR			PRINT_ADDRESS
					
					JSR			PRINT_DIVIDER
					
					MOVE.W		MOVEQ_DST_REG,D0
					JSR			PRINT_D_REG
*--------------------------------------------------------------------------------------					
.END_DEST			MOVEM.L	 	(SP)+,D0-D7
.FIN:				RTS

































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
