*-----------------------------------------------------------
* Title      : EA decomposer
* Written by : Peter Stanton
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.L  #%0000000000111000,D5
;Mode finding

LATE_MODE
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
    
DataRegister
    LEA     DnMessage, A1
    MOVE    #14,D0
    TRAP    #15
    BRA     FIND_DEST


AddressRegister
    LEA     AnMessage, A1
    MOVE    #14,D0
    TRAP    #15
    BRA     FIND_DEST


AddressRaw
    LEA     AdrMessage, A1
    MOVE    #14,D0
    TRAP    #15
    BRA     FIND_DEST

    

AdrPostIncr
    LEA     AdrPostMessage, A1
    MOVE    #14,D0
    TRAP    #15
    BRA     FIND_DEST


AdrPreDecr
    LEA     AdrPreMessage, A1
    MOVE    #14,D0
    TRAP    #15
    BRA     FIND_DEST




DnMessage      DC.B    'Destination is a data register',0
AnMessage      DC.B    'Destination is an address register',0
AdrMessage     DC.B    'Destination is an address',0
AdrPostMessage DC.B    'Destination is a post-incremented address',0
AdrPreMessage  DC.B    'Destination is a pre-incremented address',0




;JSR destination register.
FIND_DEST

    MOVE.L D5,D2
    AND.L  #%0000000000000111,D2
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
    
    
IsZero

IsOne

IsTwo

IsThree

IsFour

IsFive

IsSix

IsSeven
        

MOVEQ_PARSE
    MOVE.L  D5,D2
    


;move, size, destination, destination mode, source mode, source.
              
    
    
    

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
