*-----------------------------------------------------------
* Title      :  AND Handler Function
* Description:	Handles the AND opcode, outputs the full
*				disassembled instruction
*-----------------------------------------------------------
* Constants
*-----------------------------------------------------------
AND_OUT			DC.B	'AND',0

*-----------------------------------------------------------
* Variables
*-----------------------------------------------------------
AND_EA_REG      DS.B    1
AND_EA_MODE     DS.B    1
AND_SIZE        DS.B    1
AND_OPMODE      DS.B    1
AND_REG         DS.B    1
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
						
                *Save D0 in D7
                MOVE.L  D0,D7
                
                *Read ea Register
                ANDI.B  #%111,D0
                MOVE.B  D0,AND_EA_REG
                LSR.L   #3,D7
                
                *Read ea mode
                MOVE.L  D7,D0
                ANDI.B  #%111,D0
                MOVE.B  D0,AND_EA_MODE
                LSR.L   #3,D7
                
                *Read size
                MOVE.L  D7,D0
                ANDI.B  #%11,D0
                MOVE.B  D0,AND_SIZE
                LSR.L   #2,D7
                
                *Read opmode
                MOVE.L  D7,D0
                ANDI.B  #%1,D0
                MOVE.B  D0,AND_OPMODE
                LSR.L   #1,D7
                
                *read register
                MOVE.L  D7,D0
                ANDI.B  #%111,D0
                MOVE.B  D0,AND_REG
                
                *print opcode
                LEA     AND_OUT,A0
                JSR     PRINT_STR
                
                *print size field
                MOVE.B  AND_SIZE,D0
                MOVE.L  #%100100,D1
                JSR     PRINT_SIZE
                
                *print tab
                JSR     PRINT_OPCODE_TAB
                
                *check opmode
                CMPI.B  #0,AND_OPMODE
                BEQ     .SRC_EA
                BRA     .SRC_DN
                
.SRC_EA:        MOVE.B  AND_EA_REG,D0
                MOVE.B  AND_EA_MODE,D1
                MOVE.B  AND_SIZE,D2
                MOVE.L  #%100100,D3
                JSR     PRINT_PARAM
                BRA     .DEST
                
.SRC_DN:        MOVE.B  AND_REG,D0
                JSR     PRINT_D_REG
                BRA     .DEST
                
                *check opmode
.DEST:          JSR     PRINT_DIVIDER
                CMPI.B  #0,AND_OPMODE
                BEQ     .DEST_DN
                BRA     .DEST_EA
                
.DEST_EA:       MOVE.B  AND_EA_REG,D0
                MOVE.B  AND_EA_MODE,D1
                MOVE.B  AND_SIZE,D2
                MOVE.L  #%100100,D3
                JSR     PRINT_PARAM
                BRA     .END
                
.DEST_DN:       MOVE.B  AND_REG,D0
                JSR     PRINT_D_REG
                BRA     .END
                
.END:           MOVEM.L  (SP)+,D0-D7
                RTS
                







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
