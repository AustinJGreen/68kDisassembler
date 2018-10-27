*--------------------------------------------------------------
* Function Name : ReadHex
* Description   : Reads a hexadecimal string from the user
* Input         : NONE
* Output        : Outputs converted hexadecimal longword in D1
* D0            : Used for task number and string length
* D1            : Used for reading character
* D2            : Used to store output
* D3            : *
* D4            : *
* D5            : *
* D6            : *
* D7            : *
* A0            : *
* A1            : Used for reading input
* A2            : *
* A3            : *
* A4            : *
* A5            : *
* A6            : *
*--------------------------------------------------------------

READHEX:
                ; MOVEM.W     D2-D7/A0-A6,(SP)+           ; Save all registers

                MOVE.B      #2,D0                       ; Task 2 for TRAP 15: Read a string
                TRAP        #15                         ; Read the string and put it at A1, length is in D1
                MOVE.B      D1,D0                       ; Move string length stored in D1 to D0
.LOOP_S:     
                CMPI.W      #0,D0                       ; Check if done looping
                BLE         .READHEX_END                ; If read all characters, then go to end of the function
            
                LSL.L       #4,D2                       ; Move D2 left 4 bits for the next hexadecimal number 
            
                MOVE.B      (A1)+,D1                    ; Read current character
            
                CMPI.B      #97,D1                      ; Check if D1 >= 97
                BGE         .CONVERT_LOWER              ; If D1 >= 97 then assume character is lowercase
            
                CMPI.B      #65,D1                      ; Check if D1 >= 65
                BGE         .CONVERT_UPPER              ; If 97 >  D1 >= 65 then assume character is uppercase
            
                CMPI        #48,D1                      ; Check if D1 >= 48
                BGE         .CONVERT_NUMBER             ; If 65 >  D1 >= 48 then assume character is number
                
                BRA         .INPUT_INVALID              ; Character was invalid, brach to invalid case
.LOOP_E:           
                OR.L        D1,D2

                SUBQ        #1,D0                       ; Decrement amount of characters left
                BRA         .LOOP_S                     ; Go back to beginning of loop

.INPUT_INVALID:
                MOVE.L      #-1,D1                      ; Put -1 in D1 to represent invalid input
                BRA         .READHEX_END                ; Go to function end
            
.CONVERT_LOWER:            
                CMPI.B      #102,D1
                BGT         .INPUT_INVALID
                SUBI.B      #87,D1
                BRA         .LOOP_E

.CONVERT_UPPER:
                CMPI.B      #70,D1
                BGT         .INPUT_INVALID
                SUBI.B      #55,D1
                BRA         .LOOP_E
                
.CONVERT_NUMBER:
                CMPI.B      #57,D1
                BGT         .INPUT_INVALID
                SUBI.B      #48,D1
                BRA         .LOOP_E               
                
.READHEX_END:
                ; MOVEM.L     D2-D7/A0-A6,-(SP)           ; Restore all registers
                RTS                                     ; Return









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
