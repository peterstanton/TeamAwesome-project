*-----------------------------------------------------------
* Title      : Disassembler Final Project
* Written by : Team Awesome (Olga Rocheeva, Dwina Solihin, Peter Stanton)
* Date       : April 15, 2017
* Description: CSS 422 Final Project
*-----------------------------------------------------------
*First test will be with NOP
*Machine code is 01 00 111 001 110 010
*Use test code
*-----------------------------------------------------------
*Displays the welcome message
                LEA     welcome_msg, A1             *loads welcome message to A1
                MOVE.B  #13,D0              
                TRAP    #15
        
                MOVE.B  #7,linecount                *initializes counter
*-----------------------------------------------------------
*Get Input               
*Shows start location prompt
IO_StartLoop    LEA     location_start_msg,A1       *Store the console message for output.
                MOVE.B  #14,D0                  
                TRAP    #15                         *Display to console.

*Get User Input
                LEA     input_buffer,A1             *Raw input stored
                MOVE.B  #2,D0                       *Read string from keyboard to A1
                TRAP    #15                         *Get the user input from console

*Convert ASCII input to hexadecimal
                CLR.L   D0
                CLR.L   D1

                JSR     sub_AstoHeLoop              *conversion method for raw input characters
                MOVE.L  D7, location_startData      *store hex value 
                
                LEA     linebreak,A1                *appends a linefeed to the end of the user input
                MOVE.B  #14,D0                      *no next line when displaying
                TRAP    #15
                
                JSR     sub_startReadingData        *reads the location_StartData and returns D7
                CMP.B   #1,D7                       *checks of D7 == 1. If it is, then input is invalid
                BEQ     IO_StartLoop                *starts all over
*-----------------------------------------------------------                
*Show end location prompt               
IO_EndLoop      LEA     location_end_msg,A1         *Store the console message for output.
                MOVE.B  #14,D0                  
                TRAP    #15                         *Display to console.

*Get User Input
                LEA     input_buffer,A2             *Raw input stored
                MOVE.B  #2,D0                       *Read string from keyboard to A1
                TRAP    #15                         *Get the user input from console

*Convert ASCII input to hexadecimal
                CLR.L   D0
                CLR.L   D1
                
                JSR     sub_AstoHeLoop              *conversion method for raw input characters
                MOVE.L  D7, location_endData        *store hex value 
                
                LEA     linebreak,A1                *appends a linefeed to the end of the user input
                MOVE.B  #14,D0                      *no next line when displaying
                TRAP    #15
                
                JSR     sub_endReadingData          *reads the location_StartData and returns D7
                CMP.B   #1,D7                       *checks of D7 == 1. If it is, then input is invalid
                BEQ     IO_EndLoop                  *starts all over
                
                BRA     IO_commandPars
*-----------------------------------------------------------
*Parser through the various commands
IO_commandPars  
*                LEA     jumptable, A0                *goes to the jump table
                MOVE.L  location_startData, A2
                MOVE.L  location_endData, A3  
                
cmParsLoop      CMPI.B  #29, linecount              *will pause output if the screen lines equal 30
                BEQ     IO_pause

cmParsReturn    JSR     sub_PrintAddress            *goes to helper subroutine
                ADDQ.B  #1,linecount                increments screen line counter
                
                CLR.L   D7                          *clears D7 which holds the hex value
                    
                MOVE.W  (A2),D7                     *puts the next opcode in D7
                MOVE.B  #12,D0                      *set to shift 12 bits
                LSR.W   D0,D7                       *uses the shift call to isolate bits from root
                
                MULU    #6,D7
                JSR     0(A0,D7)
                *ASL.W   #2,D7                       *4 byte table entries
                *MOVEA.L (0,A0,D7.W),A1
                *JSR     (A1)                        *jumps to specific subroutine in jumptable
                
                *MOVEA.L location_endData,A6
                
                CMPA.L  A6,A2                       *checks if the end of input is reached
                BGE     IO_endProg                  *if it is reached, then exits the loop
                
                ADDA.W  #2,A2                       *if not, it will go to the next opcode in test                      
                BRA     cmParsLoop                  *continues the loop
*-----------------------------------------------------------               
*Pause the program
IO_pause        LEA     pause_msg, A1               *displays pause_msg
                MOVE.B  #14,D0                      *without next line
                TRAP    #15

                MOVE.B  #5,D0                       *Press enter key
                TRAP    #15

                MOVE.B  #0,linecount
                BRA     cmParsReturn                *start program again  
*-----------------------------------------------------------                              
*Terminate Program
IO_endProg      LEA     endTest_msg,A1
                MOVE.B  #14,D0
                TRAP    #15

*checks what the user inputs (yes or no)
                LEA     input_buffer,A1             *the input is put in buffer
                MOVE.B  #2,D0
                TRAP    #15
                
                LEA     linebreak,A1                *puts a linebreak between the input and question
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #5,linebreak                *this is used for the question and prompts user input
                
                MOVE.L  input_buffer,D7
                
                CMPI.L  #$79657300,D7               *if they type in yes, go to program again
                BEQ     IO_StartLoop
*-----------------------------------------------------------                               
                BRA     END_PROGRAM                 *else end program
                
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
