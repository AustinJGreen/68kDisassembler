*--------------------------------------------------------------------------
* Title      : 68k Disassembler
* Written by : Austin Green, Damian Forrester, Jacob Lefeat
* Date       : 10/20/2018
* Description: Disassmbles 68k machine code back into readable 68k opcodes
*--------------------------------------------------------------------------

                    ORG         $1000                       ; Organize code at 0x1000 (Specification 5)
                
                    INCLUDE     "stringutils.X68"           ; Load String Utils
                    INCLUDE     "readhex.X68"               ; Load ReadHex Function
                    INCLUDE     "writehex.X68"              ; Load WriteHex Function
                    INCLUDE     "binarytree.X68"            ; Load Binary tree object
                    INCLUDE     "goto.X68"                  ; Load Goto function
                    
                    INCLUDE		"opcodes_header.X68"        ; Load all opcodes, all opcodes should have access to the included files above                 
                    
START:              ; Display about
                    
                    LEA         ABOUT_STR,A0                ; Load about string
                    JSR         PRINT_STR                   ; Print about information
                    
                    ; Load information for tree
                    
                    MOVE.L      #$EEEE0000,D0
                    JSR         TREE_INIT                   ; Initialize binary tree
                    
                    ;--------------------------------------------------------------------------
                    ; Add OpCodes to tree
                    ;--------------------------------------------------------------------------
                                                  
					JSR         LOAD_ADDQ                   ; Add ADDQ
					JSR         LOAD_MOVE_B                 ; Add MOVE.B
					JSR         LOAD_MOVEQ                  ; Add MOVEQ
					JSR         LOAD_OR                     ; Add OR
                    JSR         LOAD_SUB                    ; Add SUB
                    JSR         LOAD_NOT                    ; Add NOT
                    JSR         LOAD_NOP                    ; Add NOP             
                    JSR         LOAD_RTS                    ; Add RTS
                    JSR			LOAD_MOVE_MOVEA_L			; Add MOVE.L/MOVEA.L
                    JSR         LOAD_JSR                    ; Add JSR
                    
                    ;--------------------------------------------------------------------------
                    ; Prompt user for start and end memory address
                    ;--------------------------------------------------------------------------
                    
                    LEA         BEGIN_PROMPT,A0             ; Load information about input
                    JSR         PRINT_STR
                    
                    ; At startup, prompt the user for the starting location and 
                    ; ending location in hexadecimal format. (Specification 6)
                                                            
                    LEA         START_ADDR_STR,A0           ; Load question and prompt to user
                    JSR         PRINT_STR                   ; Print question
                    JSR         READHEX
                    
                    ; TODO: Check for invalid input -1, for now I'm assuming input is valid
                    
                    MOVE.L      D2,A4                       ; Move start address to A4                    

                    LEA         END_ADDR_STR,A0             ; Load question and prompt to user
                    JSR         PRINT_STR                   ; Print question            
                    JSR         READHEX
                    
                    ; TODO: Check for invalid input -1 and make sure end address is greater than start
                    ; For now I'm assuming input is valid

                    MOVE.L      D2,A5                       ; Move end address to A5   
                                     
                    ;--------------------------------------------------------------------------
                    ; Read and process memory
                    ;--------------------------------------------------------------------------
                    
                    ; MOVE.B      #11,D0
                    ; MOVE.W      #$FF00,D1                    
                    ; TRAP        #15                         ; Clear screen to separate input from disassembled code          
                    
READ_START:         ; Begin reading at start address
                                   
                    CMPA.L      A4,A5
                    BEQ         END                         ; Go to end if reached end address
                    
                    ; Write current memory location (Specification 10)                    

                    MOVE.L      A4,A0
                    MOVE.L      #8,D0
                    JSR         WRITEHEX        
                    JSR         PRINT_TAB                   ; Print tab
                    
                    ; Read from binary stream                                         
                    
                    CLR.L       D0                          ; Clear all 32-bits so handler files are looking at a clean 16-bits just to be safe
                    MOVE.W      (A4)+,D0                    ; Read 16-bits at a time       
                    MOVE.L      #16,D1                      ; Set tree to use 16-bits from                    
                    JSR         TREE_LOOKUP                 ; Looks for opcode handler, stores result in A0
                    
                    ; TODO: Check if invalid operator (AKA unhandled opcode)
                    
                    JSR         GOTO_ADDR                   ; Goto A0 found in tree                     
                    JSR         PRINT_NEWLINE               ; Print newline                               
                    BRA         READ_START                  ; Go back to start                   

END:

                    SIMHALT                                 ; Halt simulator 

ABOUT_STR           DC.B        '68k Disassembler by Austin Green, Damian Forrester, Jacob Lefeat.',CR,LF,0
BEGIN_PROMPT        DC.B        'Please enter hexadecimal characters only. (0123456789abcdefABCDEF)',CR,LF,0
START_ADDR_STR      DC.B        'Starting address : ',0
END_ADDR_STR        DC.B        'Ending address   : ',0

                    END         START                       ; Last line of source












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
