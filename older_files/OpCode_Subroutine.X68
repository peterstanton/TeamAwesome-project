*-----------------------------------------------------------
* Title      : Disassembler Final Project
* Written by : Team Awesome (Olga Rocheeva, Dwina Solihin, Peter Stanton)
* Date       : April 15, 2017
* Description: CSS 422 Final Project
*-----------------------------------------------------------
*Holds all the subroutines that build the opcodes
*-----------------------------------------------------------
OP_Invalid      LEA     Invalid_disp,A1         *Displays the invalid operand
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.B  #4,table_length         *puts 4 spaces between opcode and EA
                JSR     sub_PrintTable
                
                LEA     dollarsign,A1           *used for testing purposes
                MOVE.B  #14,D0
                TRAP    #15
                
                MOVE.W  (A2),D7                 *puts information from A2 in D7
                MOVE.L  #4,D6                   *puts the remaining 4 bits in D6
                JSR     sub_PrintTable
                
                JSR     sub_PrintCRLF
                RTS
*-----------------------------------------------------------
OP_NOP          LEA     NOP_disp,A1             *Displays the NOP operand name
                MOVE.B  #14,D0
                TRAP    #15
                
                JSR     sub_PrintCRLF           *output to the console
                RTS
*-----------------------------------------------------------                


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
