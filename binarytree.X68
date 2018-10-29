*--------------------------------------------------------------------
* Title      : Binary tree
* Description: Binary tree object for retrieving opcode information
*--------------------------------------------------------------------

TREE_ADDRESS        DC.L        1                       ; Stores value of the head node address
LAST_NODE           DC.L        1                       ; Stores value of next available spot in memory

*--------------------------------------------------------------------
* GET_MASK
* Gets a MSB mask for the specified amount of bits using a n-bit system
*
* INPUTS
* D0 - Bit to create a mask for
* D1 - Amount of bits to use in the system
*
* OUTPUTS
* D1 - Mask
*
* REGISTER USE
* D2 - Holds original value of D0
* D3 - Holds original value of D1
*--------------------------------------------------------------------
GET_MASK:
                    MOVEM.L     D2-D3,-(SP)                 ; Save D2 and D3
                    MOVE.L      D0,D2                       ; Move original value of D0 in D2
                    MOVE.L      D1,D3                       ; Move original value of D1 in D3
                    
                    MOVE.L      #1,D1                       ; Initialize mask with 1
                    SUBQ        #1,D3                       ; Subtract 1 from the amount of bits needed to be shifted, since we intialized with 1
                    
.MASK_START:        ; Shift until 1 is at nth bit for the n-bit system

                    CMPI.L      #0,D3                       ; Shift as long as n bits still need to be shifted
                    BEQ         .START                      ; Mask is ready, go to start
                    
                    LSL.L       #1,D1                       ; Shift mask left 1
                    SUBQ        #1,D3                       ; Decrease amount of bits needed to be shifted
                                
                    BRA         .MASK_START                 ; Branch back to beginning of the first loop
                    
.START:             ; Now start shifting the bits over using the mask

                    CMPI        #1,D0                       ; Loop until D0 is <= 1
                    BLE         .END                        ; Goto end when D0 is <= 1

                    LSR.W       #1,D1                       ; Shift mask right 1
                    SUBQ        #1,D0                       ; Subtract 1 from D0
                    BRA         .START                      ; Go back to start
.END:
                    MOVE.L      D2,D0                       ; Put original value back in D0 from D2                      
                    MOVEM.L     (SP)+,D2-D3                 ; Restore D2
                    RTS

*--------------------------------------------------------------------
* ALIGN_RIGHT
* Aligns the LSB to the rightmost bit
*
* INPUTS
* D0 - Bits to align
*
* OUTPUTS
* D0 - Aligned bits
*
*--------------------------------------------------------------------
ALIGN_RIGHT:
                    CMPI        #0,D0
                    BEQ         .END                        ; Test if 0, we don't need to align and to avoid the infinite loop
.START:
                    BTST        #0,D0                       ; Test the 0th bit
                    BNE         .END                        ; If 0th bit is 1, stop
                    
                    LSR.L       #1,D0                       ; 0th bit is still 0, shift right
                    BRA         .START                      ; Go back to start
.END:                
                    RTS                                     ; Return
                    
*--------------------------------------------------------------------
* TREE_INIT
* Initializes the tree at a specified address in the stack
*
* INPUTS
* D0 - Address to build tree at
*--------------------------------------------------------------------
TREE_INIT:
                    MOVE.L      D0,TREE_ADDRESS
                    MOVE.L      D0,LAST_NODE
                    RTS 

*--------------------------------------------------------------------
* TREE_LOOKUP
* Gets the last good value in the tree
*
* INPUTS
* D0 - Binary node (16-bit)
* D1 - Amount of bits to use
*
* OUTPUTS
* A0 - Used for value of last node address
*
* REGISTER USE
* D2 - temporrary placeholder for D0
* D3 - used for iterating through bits
* D4 - used for storing mask
* D6 - used for storing node pointer
* D7 - used for iterating through node
* A6 - used for iterating through tree
*--------------------------------------------------------------------
TREE_LOOKUP:
                    MOVEM.L     A5-A6/D2-D7,-(SP)           ; Save registers  
                                                
                    MOVE.L      TREE_ADDRESS,A6             ; Move tree head address to A6
                    
                    MOVE.L      #1,D3
                    
.READ_START:        ; Start reading bits from node (16-bits)           
                    
                    MOVE.W      D0,D7
    
                    MOVE.L      D0,D2                       ; Save registers before calling GET_MASK   
                    MOVE.L      D1,D4                       ; Save D1 in D4
                    
                    MOVE.L      D3,D0                       ; Set D3 as input to GET_MASK                  
                    JSR         GET_MASK
                    
                    EXG         D1,D4                       ; Swap MASK from D1 into D4 and old D1 from D4 back into D1
                    MOVE.L      D2,D0                       ; Restore D0 from D2 (our placeholder)
                    
                    AND.L       D4,D7                       ; Get current bit and store in D7
                    
                    EXG         D7,D0                       ; Swap D7 with D0                    
                    JSR         ALIGN_RIGHT                 ; Align D0 to right                    
                    EXG         D7,D0                       ; Swap D7 with D0

                    ADDQ        #1,D3                       ; Add 1 to bit iterator
                    
                    ; Add value to address to get correct node
                    
                    MULU.W      #$8,D7                      ; Multiply by 64-bits for offset
                    ADD.L       D7,A6                       ; Move pointer by offset
                    
					CMP.W       D1,D3                       ; Check if we have iterated through all the bits
                    BGT         .END_BITS                   ; If D3 (Bit placeholder) is > bits to use then go to end 
                    
                    ; We still have more bits to iterate, continue processing
                    
                    ADD.L       #$4,A6                      ; Skip over value
                    MOVE.L      (A6),D6                     ; Store node pointer in D6
                    
                    ; Top 32-bits in D6 are for the value, lower 32-bits are for pointer
                    
                    CMPI.L      #$FFFFFFFF,D6               ; Check the pointer bits for NULLPTR (0xFFFFFFFF)
                    BEQ         .END_TREE                   ; Node ptr is empty, exit     
                    BRA         .FILLED_NODE                ; Node ptr is not empty                    
                    
.FILLED_NODE:       ; Filled node case  
                       
                    MOVE.L      D6,A6                       ; Set pointer to next node
                    BRA         .READ_START

.END_BITS           ; We've reached the end of the bits we needed to read and are still in the tree, stop and read current value
                    
                    MOVE.L      (A6),A0                     ; Read current value
                    BRA         .END
                    
.END_TREE:          ; We've reached the end of the tree, go back to last value and read that value

                    SUB.L       #$4,A6                      ; We are currently pointing to ptr, subtract 0x4 to get last value
                    MOVE.L      (A6),A0
                    BRA         .END
                    
.END                ; End of the function, restore registers and return

                    MOVEM.L     (SP)+,A5-A6/D2-D7           ; Restore registers
                    RTS


*--------------------------------------------------------------------
* TREE_ADD_NODE
* Goes to the specified node on the tree given the value in D0 and
* stores the address in A1. NOTE: If the node does not exist, they
* will be created.
*
* INPUTS
* D0 - Binary node (16-bit)
* D1 - Amount of bits to use
* A0 - Node value
*
* REGISTER USE
* D2 - temporrary placeholder for D0
* D3 - used for iterating through bits
* D4 - used for storing mask
* D6 - used for storing node pointer
* D7 - used for iterating through node
* A6 - used for iterating through tree
*--------------------------------------------------------------------
TREE_ADD_NODE:
                    MOVEM.L     A5-A6/D2-D7,-(SP)           ; Save registers  
                                                
                    MOVE.L      TREE_ADDRESS,A6             ; Move tree head address to A6
                    
                    MOVE.L      #1,D3
                    
.READ_START:        ; Start reading bits from node (16-bits)           
                    
                    MOVE.W      D0,D7
    
                    MOVE.L      D0,D2                       ; Save registers before calling GET_MASK   
                    MOVE.L      D1,D4                       ; Save D1 in D4
                    
                    MOVE.L      D3,D0                       ; Set D3 as input to GET_MASK                    
                    JSR         GET_MASK
                    
                    EXG         D1,D4                       ; Swap MASK from D1 into D4 and old D1 from D4 back into D1
                    MOVE.L      D2,D0                       ; Restore D0 from D2 (our placeholder)
                    
                    AND.L       D4,D7                       ; Get current bit and store in D7
                    
                    EXG         D7,D0                       ; Swap D7 with D0                    
                    JSR         ALIGN_RIGHT                 ; Align D0 to right                    
                    EXG         D7,D0                       ; Swap D7 with D0

                    ADDQ        #1,D3                       ; Add 1 to bit iterator
                    
                    ; Add value to address to get correct node
                    
                    MULU.W      #$8,D7                      ; Multiply by 64-bits for offset
                    ADD.L       D7,A6                       ; Move pointer by offset
                    
                    CMP.W       D1,D3                       ; Check if we have iterated through all the bits
                    BGT         .END                        ; If D3 (Bit placeholder) is > bits to use then go to end 
                    
                    ; We still have more bits to iterate, continue processing
                    
                    ADD.L       #$4,A6                      ; Skip over value
                    MOVE.L      (A6),D6                     ; Store node pointer in D6
                    
                    ; Top 32-bits in D6 are for the value, lower 32-bits are for pointer
                    
                    CMPI.L      #$FFFFFFFF,D6               ; Check the pointer bits for NULLPTR (0xFFFFFFFF)
                    BEQ         .EMPTY_NODE                 ; Node ptr is empty     
                    BRA         .FILLED_NODE                ; Node ptr is not empty
                    
.EMPTY_NODE:        ; Empty node case, set pointer to next available spot                  
                    
                    ; Add 0x10 to LAST_NODE to get next available spot in memory
                    
                    ADD.L       #$10,LAST_NODE              ; Update LAST_NODE
                    MOVE.L      LAST_NODE,(A6)              ; Set the current node's pointer
                    MOVE.L      LAST_NODE,A6                ; Set the pointer to the new node
                    
                    BRA         .READ_START
                    
.FILLED_NODE:       ; Filled node case  
                       
                    MOVE.L      D6,A6                       ; Set pointer to next node
                    BRA         .READ_START
                    
.END:               ; End of function, we are at the value location of the node in memory

                    MOVE.L      A0,(A6)                     ; Set value of created node
                    MOVEM.L     (SP)+,A5-A6/D2-D7           ; Restore registers
                    RTS
                    




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
