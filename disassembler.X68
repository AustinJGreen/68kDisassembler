*--------------------------------------------------------------------------
* Title      : 68k Disassembler
* Written by : Austin Green, Damian Forrester, Jacob Lefeat
* Date       : 10/20/2018
* Description: Disassmbles 68k machine code back into readable 68k opcodes
*--------------------------------------------------------------------------

                    ORG         $1000                       ; Organize code at 0x1000 (Specification 5)
                
                    INCLUDE     "readhex.X68"               ; Load ReadHex Function
                    INCLUDE     "binarytree.X68"            ; Load Binary tree object
                    INCLUDE     "goto.X68"                  ; Load Goto function
                    
                    INCLUDE		"opcodes_header.X68"        ; Load all opcodes
           
CR                  EQU         $0D                         ; ASCII code for Carriage Return
LF                  EQU         $0A                         ; ASCII code for Line Feed
TAB                 EQU         $08                         ; ASCII code for Horizontal Tab                    
                    
START:              ; Load information for tree

                    MOVE.L      #$EEEE0000,D0
                    JSR         TREE_INIT                   ; Initialize binary tree
                    
*--------------------------------------------------------------------------
* Add OpCodes to tree
*--------------------------------------------------------------------------
                    
                    ; Add MOVE.B
                    MOVE.L      #%0001,D0
                    MOVE.L      #4,D1                    
                    LEA         HANDLE_MOVE_B,A0                              
                    JSR         TREE_ADD_NODE

                    ; Add ADDQ
					MOVE.L      #%0101,D0
                    MOVE.L      #4,D1                    
                    LEA         HANDLE_ADDQ,A0                              
                    JSR         TREE_ADD_NODE

					; Add MOVEQ
					MOVE.L      #%0111,D0
                    MOVE.L      #4,D1                    
                    LEA         HANDLE_MOVEQ,A0                              
                    JSR         TREE_ADD_NODE

					; Add OR
					MOVE.L      #%1000,D0
                    MOVE.L      #4,D1                    
                    LEA         HANDLE_OR,A0                              
                    JSR         TREE_ADD_NODE

					; Add SUB 
					MOVE.L      #%1001,D0
                    MOVE.L      #4,D1                    
                    LEA         HANDLE_SUB,A0                              
                    JSR         TREE_ADD_NODE
                    
                    ; Add NOT
                    MOVE.L      #%01000110,D0
                    MOVE.L      #8,D1
                    LEA         HANDLE_NOT,A0
                    JSR         TREE_ADD_NODE
                    
                    ; Add NOP
                    MOVE.L      #%0100111001110001,D0
                    MOVE.L      #16,D1                    
                    LEA         HANDLE_NOP,A0                              
                    JSR         TREE_ADD_NODE
                    
                    ; Add RTS               
                    MOVE.L      #%0100111001110101,D0
                    MOVE.L      #16,D1
                    LEA         HANDLE_RTS,A0                    
                    JSR         TREE_ADD_NODE
                    
*--------------------------------------------------------------------------
* Prompt user for start and end memory address
*--------------------------------------------------------------------------
                    
                    ; At startup, prompt the user for the starting location and 
                    ; ending location in hexadecimal format. (Specification 6)
                                                            
                    LEA         START_ADDR_STR,A1             ; Load question and prompt to user
                    MOVE.B      #14,D0                      ; Set task to 14 to display string
                    TRAP        #15                         ; Display the question and prompt to the user

                    JSR         READHEX
                    
                    ; TODO: Check for invalid input -1, for now I'm assuming input is valid
                    
                    MOVE.L      D2,A4                       ; Move start address to A4                    

                    LEA         END_ADDR_STR,A1               ; Load question and prompt to user
                    MOVE.B      #14,D0                      ; Set task to 14 to display string
                    TRAP        #15                         ; Display the question and prompt to the user
            
                    JSR         READHEX
                    
                    ; TODO: Check for invalid input -1 and make sure end address is greater than start
                    ; For now I'm assuming input is valid
                                        

                    MOVE.L      D2,A5                       ; Move end address to A5   
                                     
*--------------------------------------------------------------------------
* Read and process memory
*--------------------------------------------------------------------------
READ_START:         ; Begin reading at start address
                                   
                    CMPA.L      A4,A5
                    BEQ         END                         ; Go to end if reached end address
                    
                    ; TODO: Write current memory location (Specification 10)                    
                    ; Can't use Trap 15 task 15 :(
                    ; MOVE.L    A4,A0
                    ; JSR       WRITEHEX
                    
                    ; Read from binary stream                                         
                    
                    MOVE.W      (A4)+,D0                    ; Read 16-bits at a time       
                    MOVE.L      #16,D1                      ; Set tree to use 16-bits from                    
                    JSR         TREE_LOOKUP                 ; Looks for opcode handler, stores result in A0
                    
                    ; TODO: Check if invalid operator (AKA unhandled opcode)
                    
                    JSR         GOTO_ADDR                   ; Goto A0 found in tree 
                    
                    ; Print newline
                    
                    LEA         NEWLINE_STR,A1
                    MOVE.B      #14,D0
                    TRAP        #15
                     
                    
                    BRA         READ_START                  ; Go back to start                   

END:
                    SIMHALT                                 ; Halt simulator 

* Put variables and constants here

TAB_STR             DC.B        TAB,0
NEWLINE_STR         DC.B        CR,LF,0
START_ADDR_STR      DC.B        'Please enter in the starting address location in hexadecimal format.',CR,LF,'Example: 1A2B3a',CR,LF,'>>',0
END_ADDR_STR        DC.B        'Please enter in the ending address location in hexadecimal format.',CR,LF,'Example: 1A2B3a',CR,LF,'>>',0

                    END         START                       ; Last line of source









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
