*-----------------------------------------------------------
* Title      : EA decomposer
* Written by : Peter Stanton
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

;ORI to BSET


MOVE.L #%0100111001110010,D5
MOVE.L D5,D2
CMP    #%0100111001110010,D2
JMP    ISNOOP

MOVE.L #%0100111001110101,D5
MOVE.L D5,D2
CMP    #%0100111001110101,D2
JMP    ISRTS

;I need to do JSR.
MOVE.L #%0100111010001001,D5
MOVE.L D5,D2
AND.L  #%0000000000111000,D2
CMP    #%0000000000000000,D2
JMP    DataRegister

CMP    #%0000000000001000,D2
JMP    AddressRegister

CMP    #%0000000000010000,D2
JMP    AddressRaw

CMP    #%0000000000011000,D2
JMP    AdrPostIncr

CMP    #%0000000000100000,D2
JMP    AdrPreDecr

CMP    #%0000000000101000,D2
JMP    AdrDisplace

CMP    #%0000000000110000,D2
JMP    AdrIndex

JMP    #%0000000000111000,D2
JMP    AdrImmediate

FIND_DEST

MOVE.L D5,D2
AND,L  #%0000000000000111,D2
CMP    #%0000000000000000,D2
JMP    IsZero

CMP    #%0000000000000001,D2
JMP    IsOne


CMP    #%0000000000000010,D2
JMP    IsTwo

CMP    #%0000000000000011,D2
JMP    IsThree

CMP    #%0000000000000100,D2
JMP    IsFour

CMP    #%0000000000000101,D2
JMP    IsFive

CMP    #%0000000000000110,D2
JMP    IsSix

CMP    #%0000000000000111,D2
JMP    IsSeven

PARSELATERDESTINATIONMODE

    MOVE.L #%0001001000000001, D5
    MOVE.L D5,D2
    AND.L  #%0000000111000000, D2
    CMP    #%0000000000000000, D2
    JMP    MoveDn
    
    MOVE.L #%0001001000000001, D5
    MOVE.L D5,D2
    AND.L  #%0000000111000000, D2
    CMP    #%0000000001000000, D2
    JMP    MoveAn
    
    MOVE.L #%0001001000000001, D5
    MOVE.L D5,D2
    AND.L  #%0000000111000000, D2
    CMP    #%0000000010000000, D2
    JMP    MoveAdr
    
    MOVE.L #%0001001000000001, D5
    MOVE.L D5,D2
    AND.L  #%0000000111000000, D2
    CMP    #%0000000011000000, D2
    JMP    MoveAdrPost
    
    
    MOVE.L #%0001001000000001, D5
    MOVE.L D5,D2
    AND.L  #%0000000111000000, D2
    CMP    #%0000000100000000, D2
    JMP    MoveAdrPre
    
    
PARSELATERSOURCEMODE
    
;BTST to MOVEP

    MOVE.L #%0000111100000000,D5
    MOVE.L D5,D2
    AND.L  #%0000111000000000,D2
    CMP    #%0000000000000000,D2
    ;print destination is register 0.
    
    MOVE.L #%0000111100000000,D5
    MOVE.L D5,D2
    AND.L  #%0000111000000000,D2
    CMP    #%0000001000000000,D2
    ;print destination is register 1.
    
    MOVE.L #%0000111100000000,D5
    MOVE.L D5,D2
    AND.L  #%0000111000000000,D2
    CMP    #%0000010000000000,D2
    ;print destination is register 2.
    
    MOVE.L #%0000111100000000,D5
    MOVE.L D5,D2
    AND.L  #%0000111000000000,D2
    CMP    #%0000011000000000,D2
    ;print destination is register 3.
    
    MOVE.L #%0000111100000000,D5
    MOVE.L D5,D2
    AND.L  #%0000111000000000,D2
    CMP    #%0000100000000000,D2
    ;print destination is register 4.
    
    MOVE.L #%0000111100000000,D5
    MOVE.L D5,D2
    AND.L  #%0000111000000000,D2
    CMP    #%0000101000000000,D2
    ;print destination is register 5.
    
    MOVE.L #%0000111100000000,D5
    MOVE.L D5,D2
    AND.L  #%0000111000000000,D2
    CMP    #%0000110000000000,D2
    ;print destination is register 6.
    
    
    MOVE.L #%0000111100000000,D5
    MOVE.L D5,D2
    AND.L  #%0000111000000000,D2
    CMP    #%0000111000000000,D2
    ;print destination is register 7.
    

   
    
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
