*-----------------------------------------------------------
* Title      :  AND Handler Function
* Description:	Handles the AND opcode, outputs the full
*				disassembled instruction
*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
ADD_OUT			DC.B	'ADD',0
ADDA_OUT		DC.B	'ADDA',0

*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------
ADD_EA_REG      DS.B    1
ADD_EA_MODE     DS.B    1
ADD_SIZE        DS.B    1
ADD_OPMODE      DS.B    1
ADD_REG         DS.B    1
*-----------------------------------------------------------
*	Load ADD OpCode into Tree
*-----------------------------------------------------------

LOAD_ADD_ADDA	MOVE.L	#%1101,D0
				MOVE.L	#4,D1
				LEA		HANDLE_ADD,A0
				JSR		TREE_ADD_NODE
				RTS
				
*----------------------------------------------------------
*	Handle OpCode
*----------------------------------------------------------

HANDLE_ADD	MOVEM.L	D0-D7,-(SP)
				
				MOVE.L	D0,D7
				
				*Read ea Register
				ANDI.B	#%111,D0
				MOVE.B	D0,ADD_EA_REG
				LSR.L	#3,D7
				
				*Read ea mode
				MOVE.L	D7,D0
				ANDI.B	#%111,D0
				MOVE.B	D0,ADD_EA_MODE
				LSR.L	#3,D7

				*Read size
				MOVE.L	D7,D0
				ANDI.B	#%11,D0
				MOVE.B	D0,ADD_SIZE
				LSR.L	#2,D7
				
				*Read opmode
				MOVE.L	D7,D0
				ANDI.B	#%1,D0
				MOVE.B	D0,ADD_OPMODE
				LSR.L	#1,D7
				
				*read register
				MOVE.L	D7,D0
				ANDI.B	#%111,D0
				MOVE.B	D0,ADD_REG
				
				*determine opcode
				CMPI.B	#3, ADD_SIZE          //Determines ADD/ADDA by looking at size
				BEQ		.PRINT_ADDA
				BRA		.PRINT_ADD
 				
.PRINT_ADD:		LEA		ADD_OUT,A0
				JSR		PRINT_STR
				
				*print size field for ADD
				MOVE.B	ADD_SIZE,D0
				MOVE.L	#%100100,D1				//Byte(00),word(01),long(10)
				JSR		PRINT_SIZE
				
				*Print tab
				JSR		PRINT_OPCODE_TAB
				
				*check opmode
				CMPI.B	#0,ADD_OPMODE
				BEQ		.SRC_EA
				BRA		.SRC_DN
				

.PRINT_ADDA:	LEA		ADDA_OUT,A0
				JSR		PRINT_STR
				
				*print size field for ADDA
				MOVE.B	ADD_OPMODE,D0			//Size is determined by opmode for adda
				MOVE.L	#%010011,D1				//Byte N/a(11) word(00) Long(01)
				JSR		PRINT_SIZE
				
				*Print tab
				JSR		PRINT_OPCODE_TAB
				
				*print source <ea> and Dest An
				MOVE.B	ADD_EA_REG,D0
				MOVE.B	ADD_EA_MODE,D1
				MOVE.B	ADD_OPMODE,D2
				MOVE.L	#%010011,D3
				JSR		PRINT_PARAM
				JSR		PRINT_DIVIDER
				MOVE.B	ADD_REG,D0
				JSR		PRINT_A_REG
				BRA		.END

												
.SRC_EA:		MOVE.B	ADD_EA_REG,D0
				MOVE.B	ADD_EA_MODE,D1
				MOVE.B	ADD_SIZE,D2
				MOVE.L	#%100100,D3
				JSR		PRINT_PARAM
				BRA		.DEST
				
.SRC_DN:		MOVE.B	ADD_REG,D0
				JSR		PRINT_D_REG
				BRA		.DEST
				
.DEST:			JSR		PRINT_DIVIDER
				CMPI.B	#0,ADD_OPMODE
				BEQ		.DEST_DN
				BRA		.DEST_EA
				
.DEST_EA:		MOVE.B	ADD_EA_REG,D0
				MOVE.B	ADD_EA_MODE,D1
				MOVE.B	ADD_SIZE,D2
				MOVE.L	#%100100,D3
				JSR		PRINT_PARAM
				BRA		.END
				
.DEST_DN:		MOVE.B	ADD_REG,D0
				JSR		PRINT_D_REG
				BRA		.END
				
.END:			MOVEM.L	(SP)+,D0-D7
				RTS
				
				
		
				
				
				
				








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
