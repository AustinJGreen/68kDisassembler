*--------------------------------------------------------------------------
* Title      : 68k Disassembler
* Written by : Austin Green, Damian Forrester, Jacob Lefeat
* Date       : 10/20/2018
* Description: Disassmbles 68k machine code back into readable 68k opcodes
*--------------------------------------------------------------------------

                    ORG         $1000                       ; Organize code at 0x1000 (Specification 5)
                    
                    INCLUDE     "readhex.x68"                 
           
CR                  EQU         $0D                         ; ASCII code for Carriage Return
LF                  EQU         $0A                         ; ASCII code for Line Feed

    
START:      
                    ; At startup, prompt the user for the starting location and 
                    ; ending location in hexadecimal format. (Specification 6)
            
                    LEA         START_ADDR_Q,A1             ; Load question and prompt to user
                    MOVE.B      #14,D0                      ; Set task to 14 to display string
                    TRAP        #15                         ; Display the question and prompt to the user

                    JSR         READHEX
            
                    LEA         END_ADDR_Q,A1               ; Load question and prompt to user
                    MOVE.B      #14,D0                      ; Set task to 14 to display string
                    TRAP        #15                         ; Display the question and prompt to the user
            
                    JSR         READHEX

ENDN:
                    SIMHALT                                 ; Halt simulator 

* Put variables and constants here

START_ADDR_Q        DC.B        'Please enter in the starting address location in hexadecimal format.',CR,LF,'Example: 1A2B3a',CR,LF,'>>',0
END_ADDR_Q          DC.B        'Please enter in the ending address location in hexadecimal format.',CR,LF,'Example: 1A2B3a',CR,LF,'>>',0

                    

                    END         START                       ; Last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
