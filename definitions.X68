
*-----------------------------------------------------------
* Title      : Disassembler Final Project
* Written by : Team Awesome (Olga Rocheeva, Dwina Solihin, Peter Stanton)
* Date       : April 2, 2017
* Description: CSS 422 Final Project
*-----------------------------------------------------------
* Contains variables, constants, and definitions
*-----------------------------------------------------------
*Equates opcodes
CR              EQU     $0D         carriage return
LF              EQU     $0A         line feed
*-----------------------------------------------------------
*Output messages 
welcome_msg         DC.B    'CSS 422 Disassembler Final Project',CR,LF
                    DC.B    'By Team Awesome (Olga Rocheeva, Dwina Solihin, Peter Stanton)',CR,LF,0
location_start_msg  DC.B    'Enter Start location address',CR,LF,0
location_end_msg    DC.B    'Enter End location address',CR,LF,0
linebreak           DC.B    CR,LF,0
                    
*Printing out the Op-codes required
nop_disp            DC.B    'NOP',0


*Printing out the symbols needed
hexaTable               DC.B    '0',0
                        DC.B    '1',0
                        DC.B    '2',0
                        DC.B    '3',0
                        DC.B    '4',0
                        DC.B    '5',0
                        DC.B    '6',0
                        DC.B    '7',0
                        DC.B    '8',0
                        DC.B    '9',0
                        DC.B    'A',0
                        DC.B    'B',0
                        DC.B    'C',0
                        DC.B    'D',0
                        DC.B    'E',0
                        DC.B    'F',0
poundsign               DC.B    '#',0
dollarsign              DC.B    '$',0
plussign                DC.B    '+',0
minussign               DC.B    '-',0
commasign               DC.B    ',',0
backslashsigh           DC.B    '/',0
openparen               DC.B    '(',0
closeparen              DC.B    ')',0
space                   DC.B    ' ',0   
size_b                  DC.B    '.b',0
size_w                  DC.B    '.w',0        
size_l                  DC.B    '.l',0

*Defining storage
linecount               DS.B    1       *storeage for lines on a screen
input_buffer            DC.B    1













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
