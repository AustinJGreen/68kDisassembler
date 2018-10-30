*-----------------------------------------------------------
* Title      : String Utils
* Description: Provides shortcuts for a lot of crap
*-----------------------------------------------------------
CR                  EQU         $0D                         ; ASCII code for Carriage Return
LF                  EQU         $0A                         ; ASCII code for Line Feed
TAB                 EQU         $09                         ; ASCII code for Horizontal Tab    

TAB_STR             DC.B        TAB,0
NEWLINE_STR         DC.B        CR,LF,0
D_REG_STR           DC.B        'D',0
A_REG_STR           DC.B        'A',0
LEFT_PAREN          DC.B        '(',0
RIGHT_PAREN         DC.B        ')',0
DECREMENT           DC.B        '-',0
INCREMENT           DC.B        '+',0
DIVIDER		        DC.B	    ',',0	
ADDRESS_STR         DC.B        '$',0
HEXDATA_STR         DC.B        '#$',0

*--------------------------------------------------------------------
* PRINT_STR
* Prints a string
*
* REGISTER USE
* A0 - address of string to print
*--------------------------------------------------------------------
PRINT_STR:          MOVEM.L     D0/A1,-(SP)                    
                    MOVE.L      A0,A1
                    MOVE.B      #14,D0
                    TRAP        #15                    
                    MOVEM.L     (SP)+,D0/A1
                    RTS
                    
*--------------------------------------------------------------------
* PRINT_ADDRESS
* Prints an address. For exmaple, If A0=A000 -> "$A000"
*
* REGISTER USE
* D0 - amount of letters to print. Use 4 for WORD, 8 for LONG
* A0 - address of string to print
*--------------------------------------------------------------------
PRINT_ADDRESS:      MOVEM.L     D0/A0-A1,-(SP)
                    
                    MOVEA.L     A0,A1                       ; Save A0 in A1
                    LEA         ADDRESS_STR,A0
                    JSR         PRINT_STR
                    
                    MOVEA.L     A1,A0                       ; Restore A1 from A0
                    JSR         WRITEHEX
                    
                    MOVEM.L     (SP)+,D0/A0-A1
                    RTS
                    
*--------------------------------------------------------------------
* PRINT_DATA
* Prints data. For exmaple, If A0=A000 -> "#$A000"
*
* REGISTER USE
* D0 - amount of letters to print. Use 4 for WORD, 8 for LONG
* A0 - address of string to print
*--------------------------------------------------------------------
PRINT_DATA:         MOVEM.L     D0/A0-A1,-(SP)
                    
                    MOVEA.L     A0,A1                       ; Save A0 in A1
                    LEA         HEXDATA_STR,A0
                    JSR         PRINT_STR
                    
                    MOVEA.L     A1,A0                       ; Restore A1 from A0
                    JSR         WRITEHEX
                    
                    MOVEM.L     (SP)+,D0/A0-A1
                    RTS

*--------------------------------------------------------------------
* PRINT_TAB
* Prints a tab (\t)
*
* REGISTER USE
* D0 - Holds task codes
* A1 - Holds tab string
*--------------------------------------------------------------------
PRINT_TAB:          MOVEM.L     D0/A1,-(SP)                 ; Save registers               
                    LEA         TAB_STR,A1                  ; Load tab string
                    MOVE.B      #14,D0                      ; Set task 14
                    TRAP        #15                         ; Run trap 15
                    
                    TRAP		#15							; print double tab to align better
                    
                    MOVEM.L     (SP)+,D0/A1                 ; Restore registers
                    RTS                                     ; Return

*--------------------------------------------------------------------
* PRINT_NEWLINE
* Prints a tab (\n)
*
* REGISTER USE
* D0 - Holds task codes
* A1 - Holds tab string
*--------------------------------------------------------------------
PRINT_NEWLINE:      MOVEM.L     D0/A1,-(SP)                 ; Save registers
                    LEA         NEWLINE_STR,A1              ; Load newline string
                    MOVE.B      #14,D0                      ; Set task 14
                    TRAP        #15                         ; Run trap 15
                    MOVEM.L     (SP)+,D0/A1                 ; Restore registers
                    RTS                                     ; Return

*--------------------------------------------------------------------
* PRINT_D_REG
* Prints a data register Dn
*
* INPUTS
* D0 - Register number
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------
PRINT_D_REG:        MOVEM.L     D0-D1/A1,-(SP)              ; Save registers
                    MOVE.L      D0,D1                       ; Save D0 in D1
                    LEA         D_REG_STR,A1                ; Load D string
                    MOVE.B      #14,D0                      ; Set task 14
                    TRAP        #15                         ; Run trap 15
                    MOVE.B      #3,D0                       ; Set task 3
                    TRAP        #15                         ; Run trap 15
                    MOVEM.L     (SP)+,D0-D1/A1              ; Restore registers
                    RTS                                     ; Return

*--------------------------------------------------------------------
* PRINT_A_REG
* Prints a address register An
*
* INPUTS
* D0 - Register number
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------
PRINT_A_REG:        MOVEM.L     D0-D1/A1,-(SP)              ; Save registers
                    MOVE.L      D0,D1                       ; Save D0 in D1
                    LEA         A_REG_STR,A1                ; Load A string
                    MOVE.B      #14,D0                      ; Set task 14
                    TRAP        #15                         ; Run trap 15
                    MOVE.B      #3,D0                       ; Set task 3
                    TRAP        #15                         ; Run trap 15
                    MOVEM.L     (SP)+,D0-D1/A1              ; Restore registers
                    RTS                                     ; Return

*--------------------------------------------------------------------
* PRINT_A_DIR
* Prints a address register in direct addressing mode (An)
*
* INPUTS
* D0 - Register number
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------
PRINT_A_DIR:        MOVEM.L     D0-D1/A1,-(SP)              ; Save registers
                    MOVE.L      D0,D1                       ; Save D0 in D1
                    LEA         LEFT_PAREN,A1               ; Load (
                    MOVE.B      #14,D0                      
                    TRAP        #15                         ; Print (
                    MOVE.L      D1,D0                       ; Put D1 back in D0
                    JSR         PRINT_A_REG                 ; Print An
                    LEA         RIGHT_PAREN,A1              ; Load )
                    MOVE.B      #14,D0
                    TRAP        #15                         ; Print )
                    MOVEM.L     (SP)+,D0-D1/A1              ; Restore registers
                    RTS                                     ; Return

*--------------------------------------------------------------------
* PRINT_A_PRE
* Prints a address register in pre-decrement mode -(An)
*
* INPUTS
* D0 - Register number
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------
PRINT_A_PRE:        MOVEM.L     D0-D1/A1,-(SP)              ; Save registers
                    MOVE.L      D0,D1                       ; Save D0 in D1
                    LEA         DECREMENT,A1                ; Load -
                    MOVE.B      #14,D0              
                    TRAP        #15                         ; Print -
                    MOVE.L      D1,D0                       ; Put D1 back in D0
                    JSR         PRINT_A_DIR                 ; Print (An)
                    MOVEM.L     (SP)+,D0-D1/A1              ; Restore registers
                    RTS                                     ; Return

*--------------------------------------------------------------------
* PRINT_A_POST
* Prints a address register in post-decrement mode (An)+
*
* INPUTS
* D0 - Register number
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------                    
PRINT_A_POST:       MOVEM.L     D0-D1/A1,-(SP)              ; Save registers               
                    JSR         PRINT_A_DIR                 ; Print (An)
                    LEA         INCREMENT,A1                ; Load +
                    MOVE.B      #14,D0
                    TRAP        #15                         ; Print +
                    MOVEM.L     (SP)+,D0-D1/A1              ; Restore registers
                    RTS                                     ; Return
                    
*--------------------------------------------------------------------
* PRINT_DIVIDER
* Prints a comma, used to separate source and destination
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------                    
PRINT_DIVIDER:      MOVEM.L     D0-D1/A1,-(SP)              ; Save registers    
					LEA         DIVIDER,A1                  ; Load ,
                    MOVE.B      #14,D0
                    TRAP        #15                         ; Print ,
                    MOVEM.L     (SP)+,D0-D1/A1              ; Restore registers
                    RTS                                     ; Return



















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
