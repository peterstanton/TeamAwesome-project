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

EARLY_MODE 
    MOVE.L  D5,D2
    AND.L   #%0000000111000000,D2
    CMP     #%0000000000000000,D2
    JSR     DataRegister
    JSR     FIND_DN
    JSR     PRINT_CLOSER
    JMP     LATE_MODE
    
    ;continue with all mode possibilities
    


;Find destination

FIND_DN
    MOVE.L  D5,D2
    AND.L   #%0000111000000000,D2
    CMP     #%0000111000000000,D2
    JSR     IsSeven
    RTS
    
    ;continue with all destination combinations.

;Get 2nd mode

LATE_MODE
    MOVE.L D5,D2
    AND.L  #%0000000000111000,D2
    CMP    #%0000000000000000,D2
    JSR    DataRegister
    JSR    FIND_XN
    JSR    PRINT_CLOSER
    ;end
    

    CMP    #%0000000000001000,D2
    JSR    AddressRegister

    CMP    #%0000000000010000,D2
    JSR    AddressRaw

    CMP    #%0000000000011000,D2
    JSR    AdrPostIncr

    CMP    #%0000000000100000,D2
    JSR    AdrPreDecr
    
    
    

PRINT_ADR
    ;move raw D5 and print it.
    ;this should be AddressRaw
    
DataRegister
    LEA     DnMessage, A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS


AddressRegister
    LEA     AnMessage, A1
    MOVE.B    #14,D0
    TRAP    #15
    RTS


AddressRaw
    LEA     AdrMessage, A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS

    

AdrPostIncr
    LEA     AdrPostMessage, A1
    MOVE.B    #14,D0
    TRAP    #15
    RTS


AdrPreDecr
    LEA     AdrPreMessage, A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS
    
    
;Registers should also JSR to a close parenthesis subroutine so the above prints (, then goes to




DnMessage      DC.B    'Destination is a data register',0                   ;should be just "D"
AnMessage      DC.B    'Destination is an address register',0               ;Should be just "A"
AdrMessage     DC.B    'Destination is an address',0                        ;Raw number
AdrPostMessage DC.B    'Destination is a post-incremented address',0        ;raw number with a plus sign
AdrPreMessage  DC.B    'Destination is a pre-incremented address',0         ;plus sign with a raw number.




;JSR destination register.
FIND_XN
    MOVE.L D5,D2
    AND.L  #%0000000000000111,D2
    CMP    #%0000000000000000,D2
    JSR    IsZero
    RTS
    

    CMP    #%0000000000000001,D2
    JSR    IsOne
    RTS


    CMP    #%0000000000000010,D2
    JSR    IsTwo
    RTS

    CMP    #%0000000000000011,D2
    JSR    IsThree
    RTS

    CMP    #%0000000000000100,D2
    JSR    IsFour
    RTS

    CMP    #%0000000000000101,D2
    JSR    IsFive
    RTS

    CMP    #%0000000000000110,D2
    JSR    IsSix
    RTS

    CMP    #%0000000000000111,D2
    JSR    IsSeven
    RTS
    
IsZero
    MOVE.W  #0,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS
    

IsOne
    MOVE.W  #1,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS

IsTwo
    MOVE.W  #2,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS

IsThree
    MOVE.W  #3,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS

IsFour
    MOVE.W  #4,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS
    
IsFive
    MOVE.W  #5,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS
    
IsSix
    MOVE.W  #6,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS

IsSeven
    MOVE.W  #7,A1
    MOVE.B  #14,D0
    TRAP    #15
    RTS
    

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
