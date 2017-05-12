*-----------------------------------------------------------
* Title      : EA decomposer
* Written by : Peter Stanton
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.L #%0001001000000001, D5
    AND.L  #%0000000111000000, D5
    CMP    #%0000000000000000, D5
    JMP    MoveDn
    
    MOVE.L #%0001001000000001, D5
    AND.L  #%0000000111000000, D5
    CMP    #%0000000001000000, D5
    JMP    MoveAn
    
    MOVE.L #%0001001000000001, D5
    AND.L  #%0000000111000000, D5
    CMP    #%0000000010000000, D5
    JMP    MoveAdr
    
    MOVE.L #%0001001000000001, D5
    AND.L  #%0000000111000000, D5
    CMP    #%0000000011000000, D5
    JMP    MoveAdrPost
    
    
    MOVE.L #%0001001000000001, D5
    AND.L  #%0000000111000000, D5
    CMP    #%0000000100000000, D5
    JMP    MoveAdrPre
   
    
MoveDn
    LEA     DnMessage, A1
    MOVE    #14,D0
    TRAP    #15
    
MoveAN
    LEA     AnMessage, A1
    MOVE    #14,D0
    TRAP    #15
    
MoveAdr
    LEA     AdrMessage, A1
    MOVE    #14,D0
    TRAP    #15
    
MoveAdrPost
    LEA     AdrPostMessage, A1
    MOVE    #14,D0
    TRAP    #15

MoveAdrPre
    LEA     AdrPreMessage, A1
    MOVE    #14,D0
    TRAP    #15



DnMessage      DC.B    'Destination is a data register',0
AnMessage      DC.B    'Destination is an address register',0
AdrMessage     DC.B    'Destination is an address',0
AdrPostMessage DC.B    'Destination is a post-incremented address',0
AdrPreMessage  DC.B    'Destination is a pre-incremented address',0

    
           ;move, size, destination, destination mode, source mode, source.
           
    

code0000

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
