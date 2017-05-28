*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
*Displays welcome message
                LEA     welcome_msg, A1
                MOVE.B  #13,D0
                TRAP    #15
*-----------------------------------------------------------
*Gets the starting and ending inputs
*First, the start address prompt and location
IO_StartLoop    LEA     location_start_msg,A1
                MOVE.B  #14,D0
                TRAP    #15

*Gets the user input for start locatioin                
                LEA     input_buffer,A1
                MOVE.B  #2,D0
                TRAP    #15
                
*Converts that ASCII input into hexadecimal
                CLR.L   D0
                CLR.L   D1
                
                JSR     sub_AsToHeLoop          
                MOVEA.L  location_startData, A2
                MOVEA.L  A2,A4
                ADD.L    #$2,A4
                
                LEA     linebreak,A1            *appends line at the end of the user input
                MOVE.B  #14,D0
                TRAP    #15
                
                
                JSR    sub_StartReadingData    *checks the validity of the start address
                CMP.B  #1, D7                  *checks of subroutine returned 1, if so then invalid
                BEQ    IO_StartLoop            *starts loop over due to invalidity
*-----------------------------------------------------------
*Gets the starting and ending inputs
*Second, gets the ending address prompt and location
IO_EndLoop      LEA     location_end_msg,A1
                MOVE.B  #14,D0
                TRAP    #15

*Gets the user input for start locatioin                
                LEA     input_buffer,A1
                MOVE.B  #2,D0
                TRAP    #15
                
*Converts that ASCII input into hexadecimal
                CLR.L   D0
                CLR.L   D1
                
                JSR     sub_AstoHeLoop          
                MOVEA.L location_endData, A3
                
                LEA     linebreak,A1            *appends line at the end of the user input
                MOVE.B  #14,D0
                TRAP    #15
                
                
                JSR    sub_endReadingData    *checks the validity of the start address
                CMP.B  #1, D7                  *checks of subroutine returned 1, if so then invalid
                BEQ    IO_StartLoop            *starts loop over due to invalidity
*-----------------------------------------------------------







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
