*--------------------------------------------------------------------------------------
* Title			: OR Handler function
* Description	: Handles the OR opcode, outputs the full disassembled instruction
* Manual Page # : 254
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*-------------------------------------------------------------------------------------- 
OR_OUT				DC.B		'OR',0

OR_EA_REG			DS.B		1
OR_EA_MODE			DS.B		1
OR_SIZE				DS.B		1
OR_OPMODE			DS.B		1
OR_REG				DS.B		1

LOAD_OR:			MOVE.L		#%1000,D0
					MOVE.L		#4,D1					 
					LEA			HANDLE_OR,A0							  
					JSR			TREE_ADD_NODE
					RTS

HANDLE_OR:			MOVEM.L		D0-D7,-(SP)		
		
					; Save D0 in D7
					MOVE.L		D0,D7
		
					; Read ea register					
					ANDI.B		#%111,D0
					MOVE.B		D0,OR_EA_REG					
					LSR.L		#3,D7
					
					; Read ea mode
					MOVE.L		D7,D0
					ANDI.B		#%111,D0
					MOVE.B		D0,OR_EA_MODE
					LSR.L		#3,D7
					
					; Read size
					MOVE.L		D7,D0
					ANDI.B		#%11,D0
					MOVE.B		D0,OR_SIZE
					LSR.L		#2,D7
					
					; Read opmode
					MOVE.L		D7,D0
					ANDI.B		#%1,D0
					MOVE.B		D0,OR_OPMODE
					LSR.L		#1,D7
					
					; Read register
					MOVE.L		D7,D0
					ANDI.B		#%111,D0
					MOVE.B		D0,OR_REG
					
					; Print opcode
					LEA			OR_OUT,A0
					JSR			PRINT_STR

					; Print size field	
					MOVE.B		OR_SIZE,D0
					MOVE.L		#%100100,D1
					JSR			PRINT_SIZE			
				
					; Print tab
					JSR			PRINT_OPCODE_TAB	
			
					; Check opmode
					CMPI.B		#0,OR_OPMODE
					BEQ			.SRC_EA
					BRA			.SRC_DN

.SRC_EA:			MOVE.B		OR_EA_REG,D0
					MOVE.B		OR_EA_MODE,D1
					MOVE.B		OR_SIZE,D2
					MOVE.L		#%100100,D3	
					JSR			PRINT_PARAM
					BRA			.DEST
					
.SRC_DN:			MOVE.B		OR_REG,D0
					JSR			PRINT_D_REG
					BRA			.DEST
					
					; Check opmode
.DEST:				JSR			PRINT_DIVIDER
					CMPI.B		#0,OR_OPMODE
					BEQ			.DEST_DN
					BRA			.DEST_EA

.DEST_EA:			MOVE.B		OR_EA_REG,D0
					MOVE.B		OR_EA_MODE,D1
					MOVE.B		OR_SIZE,D2
					MOVE.L		#%100100,D3	
					JSR			PRINT_PARAM
					BRA			.END				

.DEST_DN:			MOVE.B		OR_REG,D0
					JSR			PRINT_D_REG
					BRA			.END

.INVALID:			SIMHALT		; TODO

.END:				MOVEM.L		(SP)+,D0-D7
					RTS























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
