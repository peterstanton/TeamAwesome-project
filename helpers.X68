*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
*ASCII to Hexadecimal conversion Loop helper
*This subroutine is used to convert the ASCII inputting in by user into 
*hexadecimal format
*-----------------------------------------------------------
sub_AsToHeLoop          MOVE.B  (A1)+,D0            *gets first byte
                        JSR     sub_breakDownAs     *breaks down ASCII code
                        ADD.L   D0,D1               *load that char into D1
                        CMPI.B  #$0,(A1)            *checks if more needs to be broken down
                        BEQ     athEndLoop          *if no more is needed to be worked on, exits
                        LSL.L   #$4,D1              *else, shift remaining char in D1 for next char
                        BRA     sub_AsToHeLoop      *loops through again
                        
athEndLoop
                        RTS ** RETURNS AFTER CONVERTING ASCII TO HEX
*-----------------------------------------------------------
*Breaks down ASCII code from digits 0-9, a-f or A-F
*Makes the assumption that D0 holds $30-$39, $41-$46
*-----------------------------------------------------------
sub_breakDownAs         CMP.B     #$30,D0           *$is it a 0-9 digit or an a-f letter?
                        BLT     as_ERROR                        
                        
                        CMP.B    #$39,D0            *is it an A-F letter?
                        BGT     as_LETTER
                        
                        BRA     as_NUMBER
                                               
as_number               SUB.B   #$30,D0             *subtract 30, used for digits
                        RTS
                        
as_LETTER               CMP.B     #$41,D0           *letters A-F helper
                        BLT     as_ERROR
                        
                        CMP.B     #$46, D0
                        BGT     as_ERROR
                        
                        SUBI.B  #$37,D0             *subtract 37, used for A-F
                        RTS
                        
as_ERROR                LEA     'err',A1            *will display error if conversion cannot happen
                        MOVE.B  #13,D0
                        TRAP    #15  
*-----------------------------------------------------------
*start reading data helper method
*This subroutine is used to check the validity of the start
*address inputted by user
*-----------------------------------------------------------
sub_StartReadingData    
                        BTST    #0,D1                   *checks if Least Significant Bit is 1, (looks at XNZVC and sees if Z is 1) 
                        BNE     srdFailAddrOddB         *if 1, then address is odd and invalid
                        
                        MOVE.L  #0,D7                   *if D7 equals 0, then address is valid
srdFinish               RTS

srdFailAddrOddB         LEA     addr_oddBit_msg,A1
                        MOVE.B  #14,D0
                        TRAP    #15
                        
                        MOVE.L  #1,D7               *if D7 equals 1, then address is invalid
                        BRA     srdFinish
*-----------------------------------------------------------
*end reading data helper method
*This subroutine is used to check the validity of the end
*address inputted by user
*-----------------------------------------------------------
sub_EndReadingData  
                        BTST    #0,D1               *checks if LSB is 1, 
                        BNE     erdFailAddrOddB     *if 1, then address is odd and invalid
                        
                        CMP.L   A3,A2               *end address must be greater than start address
                        BGT     erdFailAddrOrder    *if start addres is greater, go to error

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
                        









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
