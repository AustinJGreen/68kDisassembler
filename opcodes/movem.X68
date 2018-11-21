*-----------------------------------------------------------
* Title		 :	MOVEM Handler function
* Date		 :	11/17/2018
* Description:	Handles the MOVEM OpCode
*-----------------------------------------------------------
*	Constants
*-----------------------------------------------------------
MOVEM_OUT				DC.B	'MOVEM',0
MOVEM_DN_MODE			DC.W	%000
MOVEM_AN_MODE			DC.W	%001

MOVEM_DIR				DS.B	1
MOVEM_SIZE_CODE			DS.B	1
MOVEM_ADDR_REG			DS.B	1
MOVEM_ADDR_MODE			DS.B	1
MOVEM_REG_LIST			DS.W	0

*-----------------------------------------------------------
*	Load MOVEM OpCode into Tree
*-----------------------------------------------------------
LOAD_MOVEM:		MOVEQ	#9,D1				* 9 bits for W and L

				MOVE.L	#%010010001,D0		* Add MOVEM register to memory
				LEA		MOVEM_REG_TO_MEM,A0
				JSR		TREE_ADD_NODE
					
				MOVE.L	#%010011001,D0		* Add MOVEM memory to register
				LEA		MOVEM_MEM_TO_REG,A0
				JSR		TREE_ADD_NODE
					
				RTS
*-----------------------------------------------------------
*	Handle OpCode
*-----------------------------------------------------------

MOVEM_REG_TO_MEM:	MOVEM.L	D0-D7,-(SP)
					MOVE.B	#%00,MOVEM_DIR	
					BRA		MOVEM_CONTINUE

MOVEM_MEM_TO_REG	MOVEM.L	D0-D7,-(SP)
					MOVE.B	#%01,MOVEM_DIR
						
					* copy opcode to D7
MOVEM_CONTINUE:		MOVE.W 	D0,D7
					
					* read An register
					ANDI.B	#%111,D0
   					MOVE.B	D0,MOVEM_ADDR_REG
   					
   					MOVE.W	D7,D0
   					LSR.L	#3,D0
   					
   					* read An address mode
   					ANDI.B	#%111,D0
					MOVE.B	D0,MOVEM_ADDR_MODE
						
					MOVE.W	D7,D0
   					LSR.L	#6,D0
   					
					* read size code
					ANDI.B	#%1,D0
					MOVE.B	D0,MOVEM_SIZE_CODE
						
					* read register list
					MOVE.W	(A4)+,MOVEM_REG_LIST						

*-----------------------------------------------------------
*	DISPLAY OpCode
*-----------------------------------------------------------
					LEA			MOVEM_OUT,A0
					JSR			PRINT_STR
												
					* Output the size code					
					MOVE.B		MOVEM_SIZE_CODE,D0				
					MOVE.B		#%010010,D1					
					JSR			PRINT_SIZE
						
					JSR			PRINT_OPCODE_TAB	  
						
*-----------------------------------------------------------
*	DISPLAY Source and Destination
*-----------------------------------------------------------
						CMP.B	#%00,MOVEM_DIR
						BEQ		.REG_TO_MEM
						
.MEM_TO_REG				JSR		PRINT_AN
						JSR		PRINT_DIVIDER
						JSR		PRINT_MEM_TO_REG
						BRA		.FIN_MOVEM
						
.REG_TO_MEM				JSR		PRINT_REG_TO_MEM
						JSR		PRINT_DIVIDER
						JSR		PRINT_AN
						
.FIN_MOVEM				MOVEM.L	(SP)+,D0-D7
						RTS
						
*-----------------------------------------------------------
*	PRINT_MEM_TO_REG: Prints list of registers for 
*	transfering from memory to registers. Always prints in 
* 	the following order; D0-D7/A0-A7
*	
* 	MOVEM_REG_LIST contains register mask in the order A7-A0 D7-D0
*-----------------------------------------------------------

PRINT_MEM_TO_REG:	CLR		D0
					CLR		D1
					CLR		D2	* used to hold 1 if we printed a Dn, 0 otherwise 
					CLR		D3	* hold MOVEM_REG_LIST
					CLR		D4	* hold current loop addressing mode
					CLR		D5	* holds current head of register range
					CLR		D6	* holds loop counter
					
					MOVE.W	#0,D5 * set head to 0, can never be zero so this is our -1
					MOVE.W	#0,D6 * set counter to 0
					MOVE.W	MOVEM_DN_MODE,D4	
					MOVE.W	MOVEM_REG_LIST,D3
					
.LOOP_ONE			CMP.W	#8,D6	* check counter
					BGE		.SKIP
					
					LSR.W	#1,D3	* shift over reg list
					BCS		.PRINT_FIRST		* a 1 was removed, meaning this reg is being used.
												* it is the first reg in this range
					
					ADD.W	#1,D6	* increment counter and iterate
.LOOP_ONE_END		BRA		.LOOP_ONE
*-----------------------------------------------------------
.PRINT_FIRST		CMP.W	MOVEM_AN_MODE,D4	* we always print Dn first, if we are now printing
					BNE		.CONTINUE_PRINT					* An then we need a backslash before we print it
					
					CMP.B	#0,D2				* check if we printed any Dn registers, if so print backslash
					BEQ		.CONTINUE_PRINT		* sinc we are now printing An
					JSR		PRINT_BACK_SLASH
		
.CONTINUE_PRINT		MOVE.B	D6,D0	* print starting register
					MOVE.B	D4,D1
					JSR		PRINT_PARAM
					ADD.W	#1,D6	* increment counter
					MOVE.B	#1,D2
					BRA		.LOOP_TWO			* continue to loop two

.SKIP				CMP.W	MOVEM_DN_MODE,D4	* check address mode and decide where to go
					BNE		.MEM_TO_REG_FIN				* if we came here from An then we are done
					MOVE.W	#0,D6				* came from Dn, so reset counter
					MOVE.W	MOVEM_AN_MODE,D4	* change register mode
					BRA		.LOOP_ONE						* and loop to one tostart checking An registers
*-----------------------------------------------------------
.LOOP_TWO			CMP.W	#8,D6	* check counter
					BGE		.CHECK_END
					
					LSR.W	#1,D3			* shift over reg list
					BCC		.LOOP_TWO_END				* a 1 was removed, meaning this reg is being used
					MOVE.W	D6,D5	* save current end register
					
.LOOP_TWO_END		ADD.W	#1,D6			* increment counter
					BRA		.LOOP_TWO

.CHECK_END			CMP.W	#0,D5		* see if this range had a end
					BEQ		.SKIP
					JSR		PRINT_DASH		* print dash then end of range
					MOVE.B	D5,D0				* print ending register
					MOVE.B	D4,D1
					JSR		PRINT_PARAM
					MOVE.W	#0,D5		* reset range head
					BRA		.SKIP
					
.MEM_TO_REG_FIN		RTS
*-----------------------------------------------------------
*	PRINT_REG_TO_MEM: Prints list of registers for 
*	transfering from registers to memory.Always prints in 
* 	the following order; A0-A7/D0-D7
*	
* 	MOVEM_REG_LIST contains register mask in the order D0-D7 A0-A7
*-----------------------------------------------------------				
PRINT_REG_TO_MEM:	CLR		D0
					CLR		D1
					CLR		D2	* used to hold 1 if we printed a An, 0 otherwise 
					CLR		D3	* hold MOVEM_REG_LIST
					CLR		D4	* hold current loop addressing mode
					CLR		D5	* holds current head of register range
					CLR		D6	* holds loop counter
					
					MOVE.W	#0,D5 * set head to 0, can never be zero so this is our -1
					MOVE.W	#0,D6 * set counter to 0
					MOVE.W	MOVEM_AN_MODE,D4	
					MOVE.W	MOVEM_REG_LIST,D3
					
.RTM_LOOP_ONE		CMP.W	#8,D6	* check counter
					BGE		.RTM_SKIP
					
					LSR.W	#1,D3	* shift over reg list
					BCS		.RTM_PRINT_FIRST		* a 1 was removed, meaning this reg is being used.
												* it is the first reg in this range
					
					ADD.W	#1,D6	* increment counter and iterate
.RTM_FIRST_END		BRA		.RTM_LOOP_ONE
*-----------------------------------------------------------
.RTM_PRINT_FIRST	CMP.W	MOVEM_DN_MODE,D4				* we always print An first, if we are now printing
					BNE		.RTM_CONT_PRINT				* Dn then we need a backslash before we print it
					
					CMP.B	#0,D2				* check if we printed any Dn registers, if so print backslash
					BEQ		.RTM_CONT_PRINT		* sinc we are now printing An
					JSR		PRINT_BACK_SLASH
		
.RTM_CONT_PRINT	MOVE.B	#7,D0	* zeroth bit corresponds to A7
					SUB.B	D6,D0	* print starting register
					MOVE.B	D4,D1
					JSR		PRINT_PARAM
					ADD.W	#1,D6	* increment counter
					MOVE.B	#1,D2
					BRA		.RTM_LOOP_TWO			* continue to loop two

.RTM_SKIP			CMP.W	MOVEM_AN_MODE,D4	* check address mode and decide where to go
					BNE		.REG_TO_MEM_FIN				* if we came here from Dn then we are done
					MOVE.W	#0,D6				* came from An, so reset counter
					MOVE.W	MOVEM_DN_MODE,D4	* change address mode
					BRA		.RTM_LOOP_ONE						* and loop to one to start checking Dn registers
*-----------------------------------------------------------
.RTM_LOOP_TWO		CMP.W	#8,D6	* check counter
					BGE		.RTM_CHECK_END
					
					LSR.W	#1,D3			* shift over reg list
					BCC		.RTM_SECOND_END				* a 1 was removed, meaning this reg is being used
					MOVE.W	D6,D5	* save current end register
					
.RTM_SECOND_END	ADD.W	#1,D6			* increment counter
					BRA		.RTM_LOOP_TWO

.RTM_CHECK_END		CMP.W	#0,D5		* see if this range had a end
					BEQ		.RTM_SKIP
					JSR		PRINT_DASH		* print dash then end of range
					MOVE.B	#7,D0
					SUB.B	D5,D0				* print ending register
					MOVE.B	D4,D1
					JSR		PRINT_PARAM
					MOVE.W	#0,D5		* reset range head
					BRA		.RTM_SKIP
					
.REG_TO_MEM_FIN		RTS

*-----------------------------------------------------------
*	PRINT_AN: Prints <ea>
*-----------------------------------------------------------	
PRINT_AN:	CLR		D0
			CLR		D1
			MOVE.B	MOVEM_ADDR_REG,D0
			MOVE.B	MOVEM_ADDR_MODE,D1
			
			JSR		PRINT_PARAM
			
			RTS
*-----------------------------------------------------------	




































































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
