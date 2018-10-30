*--------------------------------------------------------------
* WRITEHEX
* Write a full 32-bit hexadecimal string given in A0
*
* INPUTS
* A0 - Register to output
*
* REGISTER USE
* D7 - Store value of output
* D6 - Tracks which bit we are on
* D5 - Stores current letter
*--------------------------------------------------------------

HEX_ALPHABET:       DC.B        '0',0,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0,'8',0,'9',0,'A',0,'B',0,'C',0,'D',0,'E',0,'F',0

WRITEHEX:           MOVEM.L     D0-D7/A0,-(SP)              ; Save registers
                    
                    MOVE.L      A0,D7
                    MOVE.L      #0,D6
                    
.CHAR_START:        ; Start of letter by letter loop

                    CMPI.L      #8,D6
                    BEQ         .END                        ; If we are at 8th hex char then quit (0 indexed)
                    
                    MOVE.L      D7,D5                       ; Copy over current buffer 
                    AND.L       #$F0000000,D5               ; Get current character                 
                    ROL.L       #4,D5                       ; Rotate the letter left 4 to put in the rightmost 4 bits
                    
                    ; Print out letter in D5                         
                    
                    LEA         HEX_ALPHABET,A1             ; Load hexadecimal alphabet address into A1
                    MULU.W      #2,D5                       ; Multiply D5 by 2 because each letter in the alphabet has itself and 0
                    ADD.L       D5,A1                       ; Add that to the starting address
                    MOVE.L      #1,D0                       ; Use Task 1
                    MOVE.L      #2,D1                       ; Display 2 bytes (1st byte is letter, 2nd is null terminator)
                    TRAP        #15                         ; Run Trap 15
                    
                    LSL.L       #4,D7                       ; Shift buffer left 4-bits (hexadecimal char)
                    ADDQ        #1,D6                       ; Increment D6 (amount of bits displayed)
                    
                    BRA         .CHAR_START
      
.END:               ; Done writing string

                    MOVEM.L     (SP)+,D0-D7/A0              ; Restore registers
                    RTS










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
