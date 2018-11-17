*-----------------------------------------------------------
* Title      :  AND Handler Function
* Description:	Handles the AND opcode, outputs the full
*				disassembled instruction
*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
ADDQ_OUT			DC.B	'ANDQ',0

*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------
ADDQ_EA_REG      DS.B    1
ADDQ_EA_MODE     DS.B    1
ADDQ_SIZE        DS.B    1
ADDQ_DATA		 DS.B	 1
POUND_SIGN		 DC.B	 '#',0
DEBUG_CALL		 DC.B	'CHANGEDATACALLED',0
*-----------------------------------------------------------
*	Load AND OpCode into Tree
*-----------------------------------------------------------

LOAD_ADDQ:		MOVE.L		#%0101,D0
				MOVE.L		#4,D1					 
				LEA			HANDLE_ADDQ,A0								
				JSR			TREE_ADD_NODE
				RTS

HANDLE_ADDQ:	MOVEM.L	D0-D7,-(SP)

				*Save D0 in D7
                MOVE.L  D0,D7
                
                *Read ea Register
                ANDI.B  #%111,D0
                MOVE.B  D0,ADDQ_EA_REG
                LSR.L   #3,D7
                
                *Read ea mode
                MOVE.L  D7,D0
                ANDI.B  #%111,D0
                MOVE.B  D0,ADDQ_EA_MODE
                LSR.L   #3,D7
                
                
                *Read size
                MOVE.L  D7,D0
                ANDI.B  #%11,D0
                MOVE.B  D0,ADDQ_SIZE
                LSR.L   #3,D7
                
                *Read data
                MOVE.L	D7,D0
                ANDI.B	#%111,D0
                MOVE.B	D0,ADDQ_DATA
                CMPI.B  #0,ADDQ_DATA
                BEQ		.CHANGE_DATA

                
                *print opcode
.ADDQ_CONT       LEA     ADDQ_OUT,A0
                JSR     PRINT_STR
                
                *print size field
                MOVE.B  ADDQ_SIZE,D0
                MOVE.L  #%100100,D1
                JSR     PRINT_SIZE
                
                *print tab
                JSR     PRINT_OPCODE_TAB
                
                *print data
                LEA		POUND_SIGN,A0
                JSR		PRINT_STR
                MOVE.B	ADDQ_DATA,D1
                MOVE.L	#3,D0
                TRAP	#15
                JSR		PRINT_DIVIDER
                
                *print ea dest
                MOVE.B  ADDQ_EA_REG,D0
                MOVE.B  ADDQ_EA_MODE,D1
                MOVE.B  ADDQ_SIZE,D2
                MOVE.L  #%100100,D3
                JSR     PRINT_PARAM
                BRA		.END		

.CHANGE_DATA	MOVE.B #8,ADDQ_DATA
				BRA		.ADDQ_CONT
				
.END:			MOVEM.L	(SP)+,D0-D7
				RTS















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
