*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.W  (A1),D1
    //do something to convert to a big string of bits
    
    //get the 4 right bits with AND 0F... or F0000000?
    
    //grab 3 bits

code0000
//parse 000

    ;parse next 3 digits
    JMP 000
    jmp 001
    JMP 010
    JMP 011
    JMP 100
    JMP 101
    JMP 110
    JMP 111

code0001

code0010


code0011

code0100

    ;parse the next 4 digits
    JMP 0000
    JMP 0001
    JMP 0010
    JMP 0011
    JMP 0100
    JMP 0101
    JMP 0110
    JMP 0111
    JMP 1000

code0101

code0110

code0111

code1000

code1001

code1011

code1100

code1101

code1110

code1111
    
    
    
    

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
