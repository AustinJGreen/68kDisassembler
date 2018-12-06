*-----------------------------------------------------------
* Title      :  SUB Handler Function
* Description:	Handles the SUB opcode, outputs the full
*				disassembled instruction
*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
SUB_OUT			DC.B	'SUB',0


*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------
SUB_EA_REG      DS.B    1
SUB_EA_MODE     DS.B    1
SUB_SIZE        DS.B    1
SUB_OPMODE      DS.B    1
SUB_REG         DS.B    1
*-----------------------------------------------------------
*	Load ADD OpCode into Tree
*-----------------------------------------------------------

LOAD_SUB		MOVE.L	#%1001,D0
				MOVE.L	#4,D1
				LEA		HANDLE_SUB,A0
				JSR		TREE_ADD_NODE
				RTS
				
*----------------------------------------------------------
*	Handle OpCode
*----------------------------------------------------------

HANDLE_SUB	MOVEM.L	D0-D7,-(SP)

				MOVE.L	D0,D7
				
				*Read ea Register
				ANDI.B	#%111,D0
				MOVE.B	D0,SUB_EA_REG
				LSR.L	#3,D7
				
				*Read ea mode
				MOVE.L	D7,D0
				ANDI.B	#%111,D0
				MOVE.B	D0,SUB_EA_MODE
				LSR.L	#3,D7
				
				*Read size
				MOVE.L	D7,D0
				ANDI.B	#%11,D0
				MOVE.B	D0,SUB_SIZE
				LSR.L	#2,D7
				
				*Read opmode
				MOVE.L	D7,D0
				ANDI.B	#%1,D0
				MOVE.B	D0,SUB_OPMODE
				LSR.L	#1,D7
				
				*read register
				MOVE.L	D7,D0
				ANDI.B	#%111,D0
				MOVE.B	D0,SUB_REG
				
				*Print OPCode
				LEA		SUB_OUT,A0
				JSR		PRINT_STR
				
				*Print size field
				MOVE.B	SUB_SIZE,D0
				MOVE.L	#%100100,D1
				JSR		PRINT_SIZE
				
				*Print Tab
				JSR		PRINT_OPCODE_TAB
				
				*check opmode
				CMPI.B	#1,SUB_OPMODE
				BEQ		.SRC_DN
				BRA		.SRC_EA
				
.SRC_EA:        MOVE.B  SUB_EA_REG,D0
                MOVE.B  SUB_EA_MODE,D1
                MOVE.B  SUB_SIZE,D2
                MOVE.L  #%100100,D3
                JSR     PRINT_PARAM
                BRA     .DEST
                
.SRC_DN:        MOVE.B  SUB_REG,D0
                JSR     PRINT_D_REG
                BRA     .DEST
                
.DEST:          JSR     PRINT_DIVIDER
                CMPI.B  #1,SUB_OPMODE
                BEQ     .DEST_EA
                BRA     .DEST_DN
                
.DEST_EA:       MOVE.B  SUB_EA_REG,D0
                MOVE.B  SUB_EA_MODE,D1
                MOVE.B  SUB_SIZE,D2
                MOVE.L  #%100100,D3
                JSR     PRINT_PARAM
                BRA     .END
                
.DEST_DN:       MOVE.B  SUB_REG,D0
                JSR     PRINT_D_REG
                BRA     .END
                
.END:           MOVEM.L  (SP)+,D0-D7
                RTS
				
				
				
				
				
				





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
