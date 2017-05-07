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
    
    //if 000 jump to 000 
    //if 001 jump to 001   
    //if 010 jump to 010
    //if 011 jump to 011
    //if 100 jump to 100
    //if 101 jump to 101
    //if 110 jump to 110
    //if 111 jump to 111
    
    
    
JUMP000
    //stuff for 000 operations
    
    
JUMP001 
    //stuff for 001 operations
    
JUMP010
    //stuff for 010 operations
    
JUMP011
    //stuff for 011 operations
    
JUMP100
    //stuff for 100 operations
    
JUMP101
    //stuff for 101 operations
    
JUMP110
    //stuff for 110 operations
    
JUMP111
    //stuff for 111 operations.
    
    
    

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
