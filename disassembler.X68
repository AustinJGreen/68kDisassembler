*--------------------------------------------------------------------------
* Title      : 68k Disassembler
* Written by : Austin Green, Damian Forrester, Jacob Lefeat
* Date       : 10/20/2018
* Description: Disassmbles 68k machine code back into readable 68k opcodes
*--------------------------------------------------------------------------

                    ORG         $1000                       ; Organize code at 0x1000 (Specification 5)
                
                    INCLUDE     "readhex.x68"               ; Load READHEX Function
                    INCLUDE     "binarytree.x68"            ; Load Binary tree object
                    INCLUDE     "goto.x68"
                    
                    INCLUDE     "opcodes\nop.x68"           ; Load NOP Opcode Handler
                    INCLUDE     "opcodes\rts.x68"           ; Load RTS Opcode Handler
           
CR                  EQU         $0D                         ; ASCII code for Carriage Return

LF                  EQU         $0A                         ; ASCII code for Line Feed                    
                    
START:              ; Load information for tree

                    MOVE.L      #$EEEE0000,D0
                    JSR         TREE_INIT                   ; Initialize binary tree
                    
                    ; Add opcodes to tree
                    
                    ; Add address for NOP, can later use address label for
                    ; specific handler of code
                    
                    MOVE.L      #$4E71,D0
                    MOVE.L      #16,D1                    
                    LEA         HANDLE_NOP,A0                   
                    MOVE.L      A0,D2              
                    JSR         TREE_ADD_NODE               ; 4E71 for NOP
                    
                    ; Add address for RTS, can later use address for specific handler of code instead
                    ; of the direct label
                    

                    MOVE.L      #$4E75,D0
                    MOVE.L      #16,D1
                    LEA         HANDLE_RTS,A0                    
                    MOVE.L      A0,D2
                    JSR         TREE_ADD_NODE
                    
                    ; At startup, prompt the user for the starting location and 
                    ; ending location in hexadecimal format. (Specification 6)
                                                            
                    LEA         START_ADDR_Q,A1             ; Load question and prompt to user
                    MOVE.B      #14,D0                      ; Set task to 14 to display string
                    TRAP        #15                         ; Display the question and prompt to the user

                    JSR         READHEX
                    
                    ; TODO: Check for invalid input -1, for now I'm assuming input is valid
                    
                    MOVE.L      D2,A2                       ; Move start address to A2                    

                    LEA         END_ADDR_Q,A1               ; Load question and prompt to user
                    MOVE.B      #14,D0                      ; Set task to 14 to display string
                    TRAP        #15                         ; Display the question and prompt to the user
            
                    JSR         READHEX
                    
                    ; TODO: Check for invalid input -1 and make sure end address is greater than start
                    ; For now I'm assuming input is valid
                                        

                    MOVE.L      D2,A3                       ; Move end address to A3   
                                     
READ_START:         ; Begin reading at start address
                                   
                    CMPA.L      A2,A3
                    BEQ         END                         ; Go to end if reached end address
                    
                    ; Read from binary stream 
                    
                    MOVE.W      (A2)+,D0                    ; Read 16-bits at a time       
                    MOVE.L      #16,D1          
                    JSR         TREE_READ_VALUE             ; Reads value in tree into D0
                    
                    ; TODO: Check if invalid operator (AKA unhandled opcode)
                            
                    MOVE.L      D2,A0
                    JSR         GOTO_ADDR                
                    
                    BRA         READ_START                  ; Go back to start                   

END:
                    SIMHALT                                 ; Halt simulator 

* Put variables and constants here

START_ADDR_Q        DC.B        'Please enter in the starting address location in hexadecimal format.',CR,LF,'Example: 1A2B3a',CR,LF,'>>',0
END_ADDR_Q          DC.B        'Please enter in the ending address location in hexadecimal format.',CR,LF,'Example: 1A2B3a',CR,LF,'>>',0

* Opcodes?

                    END         START                       ; Last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
