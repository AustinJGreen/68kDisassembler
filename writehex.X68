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
* D4 - Stores current mask
* D3 - Stores mask exponent
*--------------------------------------------------------------

HEXADECIMAL_ARR:    DC.B        'ABCDEF',0

WRITEHEX:
                    MOVEM.L     D0-D7/A0,-(SP)              ; Save registers
                    
                    MOVE.L      A0,D7
                    MOVE.L      #0,D6
                    
.CHAR_START:        ; Start of letter by letter loop

                    CMPI.L      #8,D6
                    BEQ         .END                        ; If we are at 8th hex char then quit (0 indexed)

                    ; Get mask
                    
                    MOVE.L      #$F,D4                      ; Mask = 1111
                    MOVE.L      #$10,D3                     ; Set mask multiplier to 0x10
                    MULU.L      D3,D6
                    MULU.L      
                    
                    
                    MOVE.L      D7,D5                       ; Copy over current buffer 
                    AND.L       #$F,D5                      ; Get current character

                    LSR.L       #4,D7                       ; Shift buffer down 4-bit (hexadecimal char)

                    ; Print out letter in D5                         
                    
                    
                          
.END:               ; Done writing data

                    MOVEM.L     (SP)+,D0-D7/A0              ; Restore registers
                    RTS





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
