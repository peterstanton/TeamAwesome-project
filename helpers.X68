*-----------------------------------------------------------
* Title      : Disassembler Final Project
* Written by : Team Awesome (Olga Rocheeva, Dwina Solihin, Peter Stanton)
* Date       : April 15, 2017
* Description: CSS 422 Final Project
*-----------------------------------------------------------
*-----------------------------------------------------------
*Below are helper subroutines that will be used throughout 
*this final project.
*-----------------------------------------------------------
*ASCII to Hexadecimal conversion Loop helper
sub_AsToHeLoop          MOVE.B  (A1)+,D0            *gets first byte
                        JSR     sub_breakDownAs     *breaks down ASCII code
                        ADD.L   D0,D1               *load that char into D1
                        CMPI.B  #$0,(A1)            *checks if more needs to be broken down
                        BEQ     athEndLoop          *if no more is needed to be worked on, exits
                        LSL.L   #$4,D1              *else, shift remaining char in D1 for next char
                        BRA     sub_AsToHeLoop      *loops through again
                        
athEndLoop              MOVE.L  D1,D7               *hex number in D7
                        RTS
*-----------------------------------------------------------
*Breaks down ASCII code from digits 0-9, a-f or A-F
*Makes the assumption that D0 holds $30-$39, $41-$46
*-----------------------------------------------------------
sub_breakDownAs         CMP.B   #$39,D0     *$30-$39 is a digit (0-9)
                        BGT     as_smallLetter
                        CMP.B   #$46,D0
                        
                        BGT     as_bigLetter
                        SUB.B   #$30,D0
                        RTS
                        
as_smallLetter          SUB.B   #$30,D0
                        RTS
                        
as_bigLetter            SUB.B  #$37,D0
                        RTS
*-----------------------------------------------------------
*start reading data helper method
*check the data start address
sub_StartReadingData    MOVE.L  location_startData,D0
    
                        BTST    #0,D0               *checks if LSB is 1, 
                        BNE     srdFailAddrOddB     *if 1, then address is odd and invalid
                        
                        MOVE.L  #0,D7               *if D7 equals 0, then address is valid
srdFinish               RTS

srdFailAddrOddB         LEA     addr_oddBit_msg,A1
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        MOVE.L  #1,D7               *if D7 equals 1, then address is invalid
                        BRA     srdFinish
*-----------------------------------------------------------
*end reading data helper method
*check the data end address            
sub_EndReadingData      MOVE.L  location_startData,D0
                        MOVE.L  location_endData,D1
    
                        BTST    #0,D0               *checks if LSB is 1, 
                        BNE     erdFailAddrOddB     *if 1, then address is odd and invalid
                        
                        CMP.L  D0,D1               *end address must be greater than start address
erdFinish               RTS

erdFailAddrOrder        LEA     addr_order_check,A1
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        MOVE.L  #1,D7
                        BRA     erdFinish

erdFailAddrOddB         LEA     addr_oddBit_msg,A1
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        MOVE.L  #1,D7               *if D7 equals 1, then address is invalid
                        BRA     erdFinish
*-----------------------------------------------------------
*Prints Table
sub_PrintTable  CLR.L   D7
                MOVE.B  table_length,D7             *moves data to D7 as decreasing counter

PrintTableLoopS CMP.B   #0,D7                       *checks of counter is 0
                BEQ     PrintTableLoopE             *will end loop
                
                LEA     space,A1                    *if not, print single space in consold
                MOVE.B  #14,D0                      
                TRAP    #15
                
                SUBQ.B  #1,D7                       *decrease loop counter by 1
                BRA     PrintTableLoopS
                
PrintTableLoopE RTS                       
*-----------------------------------------------------------
*Prints a CR,LF at end of printed string
sub_PrintCRLF   LEA     linebreak,A1
                MOVE.B  #14,D0
                TRAP    #15
                RTS
*-----------------------------------------------------------
*Converts Hex values to ASCII and displays in console
sub_PrintHexa       MOVEM.L D3-D6,-(SP)         ;Store registers in stack
                
                    LEA     hexatable,A3
                    MULU.W  #4,D6               ;Convert number of digits to total bits (4 bits per char)
                
                    MOVE.L  #32,D3              ;Set the total number of bits
                    SUB.L   D6,D3               ;Set the bit displacement for nibbles left to right
                    MOVE.L  #28,D4              ;Bit displacement to truncate all but one nibble
                
PrintHexaLoop       MOVE.L  D7,D5               ;Load/reload hex output into D5 for work.

                    LSL.L   D3,D5               ;For each loop, isolate the next nibble using displacement
                    LSR.L   D4,D5               ;Truncate everything else except the nibble
                
                    MULU    #2,D5               ;Multiply nibble by two, find character in char_table
                    LEA     0(A3,D5),A1         ;Store the character for output
                    MOVE.B  #14,D0              ;Will display from A1 without CR,LF.
                    TRAP    #15                 ;Display to console.
                
                    ADD.B   #4,D3               ;Add another 4 bits to displacement to get next nibble
                    CMP.B   #32,D3              ;If displacement = 32, we're done.
                    BNE     PrintHexaLoop

                    MOVEM.L (SP)+,D3-D6         ;Replace registers from stack
                    RTS
*-----------------------------------------------------------
*Prints the hex Address stored in A2
sub_PrintAddress    CLR.L   D7
                    MOVE.L  A2,D7
                    MOVE.L  #8,D6
                    JSR     sub_PrintHexa
                    
                    MOVE.B  #3,table_length
                    JSR     sub_PrintTable
                    RTS
*-----------------------------------------------------------













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
