*-----------------------------------------------------------
* Title      : Disassembler Final Project
* Written by : Team Awesome
* Date       : April 15, 2017
* Description: 422 Final Project
*-----------------------------------------------------------

*Displays the welcome message
                LEA     welcome_msg, A1             *loads welcome message to A1
                MOVE.B  #13,D0              
                TRAP    #15
        
                MOVE.B  #7,linecount                *initializes counter
*Get Input               
*Shows start location prompt
FN_InputLoop    LEA     location_start_msg,A1       *Store the console message for output.
                MOVE.B  #14,D0                  
                TRAP    #15                         *Display to console.

*Get User Input
                LEA     input_buffer,A1             *Raw input stored
                MOVE.B  #2,D0                       *Read string from keyboard to A1
                TRAP    #15                         *Get the user input from console
                
*Show end location prompt               
                LEA     location_end_msg,A1         *Store the console message for output.
                MOVE.B  #14,D0                  
                TRAP    #15                         *Display to console.

*Get User Input
                LEA     input_buffer,A2             *Raw input stored
                MOVE.B  #2,D0                       *Read string from keyboard to A1
                TRAP    #15                         *Get the user input from console
               

                
                BRA     END_PROGRAM
                














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
