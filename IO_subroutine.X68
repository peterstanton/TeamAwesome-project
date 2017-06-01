*START   ORG $1000      
        *INCLUDE     'OP_EA.x68' 
        *INCLUDE     'definitions.x68' 
        *INCLUDE     'newHelper.x68'
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
                
                MOVE.B  #8,linecount            *keeps a counter of how many lines there are
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
                
                JSR     sub_AsToHeLoop          *this will put the newly converted hex value into D7
                MOVE.L  D7, location_startData  *puts that value into a variable, 'location_startData'
                
                MOVE.L  location_startData,A2
                MOVEA.L A2,A4
                *ADD.L   #$2,A4                  *moves to next OpCode
                
                LEA     linebreak,A1            *appends line at the end of the user input
                MOVE.B  #14,D0
                TRAP    #15
                
                JSR    sub_StartReadingData    *checks the validity of the start address
                CMP    #1, D7                  *checks of subroutine returned 1, if so then invalid
                BEQ    IO_StartLoop            *starts loop over due to invalidity
*-----------------------------------------------------------
*Gets the starting and ending inputs
*Second, gets the ending address prompt and location
*-----------------------------------------------------------
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
                
                JSR     sub_AstoHeLoop          *this will put the newly converted hex value into D7
                MOVE.L  D7, location_endData  *puts that value into a variable, 'location_startData'
                
                MOVE.L  location_endData,A3
                
                LEA     linebreak,A1            *appends line at the end of the user input
                MOVE.B  #14,D0
                TRAP    #15
                
                
                JSR    sub_endReadingData    *checks the validity of the start address
                CMP    #1, D7                  *checks of subroutine returned 1, if so then invalid
                BEQ    IO_StartLoop            *starts loop over due to invalidity
                
                BRA     MAIN_LOOP
*-----------------------------------------------------------
* Pause Screen Ouput 
* This subroutine will pause the output after 29 lines are shown
**----------------------------------------------------------
IO_PauseOutput  LEA     pause_msg,A1          *prints pause message to the screen
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #5,D0                 *allows user to click enter to continue
                TRAP    #15
                
                MOVE.B  #0,linecount
                
                CMPA.L  A3,A2                   * checks if the program is at the end
                BGE     IO_EndProgram
                
                BRA     MAIN_LOOP
                
*-----------------------------------------------------------
* Terminate program
* This subroutine will be used to end the program. It shows the
* end test message and then ask user input for continuing or
* not. 
*-----------------------------------------------------------
IO_EndProgram   LEA     endtest_msg,A1
                MOVE.B  #14,D0
                TRAP    #15
                
*checks and validates user input
                LEA     input_buffer,A1
                MOVE.B  #2,D0
                TRAP    #15

                LEA     linebreak,A1
                MOVE.B  #14,D0
                TRAP    #15

                MOVE.B  #5,linebreak            *used for question and prompts user to answer

                MOVE.L  input_buffer,D7
                CMPI.L  #$79657300,D7
                BEQ     IO_StartLoop

                BRA     END_PROGRAM             
*-----------------------------------------------------------












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
