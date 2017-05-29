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
                
                MOVE.B  #7,linecount            *initializes a counter to keep track of how many lines on screen
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
                MOVEA.L  D1, A2
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
                MOVEA.L D1, A3
                
                LEA     linebreak,A1            *appends line at the end of the user input
                MOVE.B  #14,D0
                TRAP    #15
                
                
                JSR    sub_endReadingData       *checks the validity of the start address
                CMP.B  #1, D7                   *checks of subroutine returned 1, if so then invalid
                BEQ    IO_StartLoop             *starts loop over due to invalidity
*-----------------------------------------------------------
IO_Screen       JSR    MAIN_LOOP
                ADDQ.B  #1,linecount            *adds to the linecount after each line

                
                CMP     #29,linecount           *checks if the linecounter is at 29
                BEQ     IO_PauseOutput          *if so, will pause the output
                
                CMPA.L  A4,A5                   *checks if the end of the input has been reached
                BGE     IO_EndProgram
                
                ADDA.W  #2,A3                   If not, goes to the next opcode
                BRA     IO_Screen               Start main loop over
*-----------------------------------------------------------
IO_PauseOutput  LEA     pause_msg,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #5,D0                   *user press enter to continue
                TRAP    #15
                
                MOVE.B  #0,linecount            *update linecount to 0
                BRA     IO_Screen               *start the reading again
*-----------------------------------------------------------
IO_EndProgram   LEA     endTest_msg,A1
                MOVE.B  #14,D0
                TRAP    #15
                
*check the user input
                LEA     input_buffer,A1
                MOVE.B  #2,D0
                TRAP    #15
                
                LEA     linebreak,A1
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #5,linebreak
                
                MOVE.B  input_buffer,D7         *puts the input buffer into D7
                CMPI.L  #$79657300,D7           *checks of the input is yes
                BEQ     IO_StartLoop            *if it is yes, then start over
                
                BRA     EXIT                    *else, end program
*-----------------------------------------------------------


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
