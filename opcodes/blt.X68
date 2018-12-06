*--------------------------------------------------------------------------------------
* Title			: BLT Handler function
* Description	: Handles the BLT opcode, outputs the full disassembled instruction
* Manual Page # : 129
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*
* REGISTER USE
* D6 - Holds register value
* D7 - Register used to hold Opcode data
*--------------------------------------------------------------------------------------  
BLT_OUT				DC.B		'BLT',0

LOAD_BLT:			MOVE.L		#%01101101,D0
					MOVE.L		#8,D1
					LEA			HANDLE_BLT,A0
					JSR			TREE_ADD_NODE
					RTS

HANDLE_BLT:			MOVEM.L		D0-D7/A0,-(SP)				; Save registers
					LEA			BLT_OUT,A0
					JSR			PRINT_STR

					JSR			PRINT_OPCODE_TAB

					; Read 8-bit displacement into D0
					AND.B		#%11111111,D0	

					; Check for 00, which means WORD displacement
					CMPI.B		#$00,D0
					BEQ			.WORD_ADDR
					
					; Check for FF which means LONG displacement
					CMPI.B		#$FF,D0
					BEQ			.LONG_ADDR
						
					; No extra data, display data and continue to end					
					MOVE.W		D0,A0
					MOVE.L		#2,D0
					JSR			PRINT_ADDRESS	
					
					BRA			.END	
						
					; Read word of displacement
.WORD_ADDR:			MOVEA.W		(A4)+,A0
					
					MOVE.L		#4,D0
					JSR			PRINT_ADDRESS	
					BRA			.END
					
					; Read long of displacement
.LONG_ADDR:			MOVEA.L		(A4)+,A0

					MOVE.L		#8,D0
					JSR			PRINT_ADDRESS	
					BRA			.END
				
.END:				MOVEM.L		(SP)+,D0-D7/A0				; Restore registers
					RTS






























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
