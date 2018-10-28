*--------------------------------------------------------------------
* Title      : Binary tree
* Description: Binary tree object for retrieving opcode information
*--------------------------------------------------------------------

TREE_ADDRESS        DC.L        1                       ; Stores value of the head node address
LAST_NODE           DC.L        1                       ; Stores value of next available spot in memory

*--------------------------------------------------------------------
* TREE_INIT
* Initializes the tree at a specified address in the stack
*
* INPUTS
* D1 - Address to build tree at
*--------------------------------------------------------------------
TREE_INIT:
                    MOVE.L      D1,TREE_ADDRESS
                    MOVE.L      D1,LAST_NODE
                    RTS 

*--------------------------------------------------------------------
* TREE_GOTO
* Goes to the specified node on the tree given the value in D1 and
* stores the address in A1
*
* INPUTS
* D1 - Binary node (16-bit)
*
* OUTPUTS
* A1 - Used for value of node address
*
* REGISTER USE
* D5 - used for storing node value
* D6 - used for storing node pointer
* D7 - used for iterating through node
* A1 - used for output address
* A6 - used for iterating through tree
*--------------------------------------------------------------------
TREE_GOTO:
                    MOVEM.L     A5-A6/D5-D7,-(SP)           ; Save registers  
                                                
                    MOVE.L      TREE_ADDRESS,A6             ; Move tree head address to A6
                    
.READ_START:        ; Start reading bits from node (16-bits)           
                    
                    MOVE.W      D1,D7 
                    CMPI.W      #0,D7                       ; Loop while bits left aren't zero
                    BEQ         .END                        ; Done reading, go to end         
                    
                    AND.L       #$8000,D7                   ; Put most significant bit in D7
                    ROL.W       #1,D7                       ; Put the msb at the 0th bit, by rotating left 1 (rotating right 15)
                    LSL.L       #1,D1                       ; Shift D1 left 1 bit
                    
                    ; Add value to address to get correct node
                    
                    MULU.W      #$8,D7                      ; Multiply by 64-bits for offset
                    ADD.L       D7,A6                       ; Move pointer by offset
                    
                    ; Read current node from tree
                    
                    MOVE.L      (A6)+,D5                    ; Store node pointer in D6
                    MOVE.L      (A6),D6                     ; Store node value in D5
                    
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
                    
.END                ; End of function

                    MOVE.L      A6,A1                       ; Set output to current node
                    MOVEM.L     (SP)+,A5-A6/D5-D7           ; Restore registers
                    RTS
                    
*--------------------------------------------------------------------
* TREE_ADD_NODE
* Adds a node to the tree with the specified value
*
* INPUTS
* D1 - Binary node
* D2 - Node value
*
* REGISTER USE
*--------------------------------------------------------------------
TREE_ADD_NODE:
                    JSR         TREE_GOTO
                    MOVE.L      D2,(A1)                     ; Set value of node                    
                    RTS                                     ; Return

*--------------------------------------------------------------------
* TREE_READ_VALUE
* Reads the value of the node in the binary tree
*
* INPUTS
* D1 - Binary node
*
* OUTPUTS
* D0 - Binary node value
*
* REGISTER USE
* D0 - used for outputting value
*--------------------------------------------------------------------                    
TREE_READ_VALUE:
                    JSR         TREE_GOTO                                       
                    MOVE.L      (A1),D0                     ; Read value of node                    
                    RTS
                    
                    
                    
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
