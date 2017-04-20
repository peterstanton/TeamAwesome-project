*-----------------------------------------------------------
* Title      : Disassembler Final Project
* Written by : Team Awesome (Olga Rocheeva, Dwina Solihin, Peter Stanton)
* Date       : April 2, 2017
* Description: CSS 422 Final Project
*-----------------------------------------------------------
*Below is the class that connects to all of the subroutines
*used in the disassembler. 
START           ORG    $1000           * first instruction of program
    
                INCLUDE 'IO_subroutine.x68'

END_PROGRAM     SIMHALT                *Stop the simulator

*-----------------------------------------------------------
                *INCLUDE 'helpers.x68'
                INCLUDE 'definitions.x68'
                
                END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
