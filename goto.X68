*-----------------------------------------------------------
* GOTO_ADDR
* Goes to a specified address in A0. 
* Substitute for JSR, but JSR won't work with custom addresses
*
* INPUTS
* A0 - Address to go to
*-----------------------------------------------------------
GOTO_ADDR:
						LEA			.END,A1
						SUBQ		#$4,SP			; Move SP back 4 slots
						MOVE.L		A1,(SP)			; Add the end of the this function as return value for the function we are about to call so they can call RTS
						SUBQ		#$4,SP			; Move SP back 4 slots
						MOVE.L		A0,(SP)			; Add Target address to SP					
						RTS							; Call "RTS" which simulates a call back to the current value in the SP, which allows us to go to any address
.END					RTS							; Returns back from this function
						



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
