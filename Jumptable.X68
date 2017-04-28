*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
*    ORG    $1000
*START:                  ; first instruction of program

 moveq.l #0,d1               ;clear d1

    move.l  d0,d1               ;move the OpCode to d1

    lea     jmptable,a1

    rol.l   #4,d1               ;move the index to the right nibble
    andi.b  #$0F,d1             ;Just the first nibble
    asl.w   #2,d1               ;4 byte table entries
    movea.l (0,a1,d1.w),a0
    jmp     (a0)                ;jump to specified routine

jmptable:   dc.l    routine_0   *Bit manipulation/MOVEP/Immediate (D)
            dc.l    Op_MoveB    *Move Byte(D)
            dc.l    Op_MoveL    *Move Long (D)
            dc.l    Op_MoveW    *Move Word (D)
            dc.l    routine_4   *Misc
            dc.l    routine_5   *ADDQ/SUBQ/Scc/DBcc
            dc.l    routine_6   *BSR,BRA,Bcc
            dc.l    Op_MoveQ    *MOVEQ
            dc.l    routine_8   *OR/DIV/SBCD 
            dc.l    routine_9   *SUB/SUBX
            dc.l    Op_Invalid  *Unassigned (D)
            dc.l    routine_B   *CMP/EOR
            dc.l    routine_C   *AND/MUL/ABCD/EXG
            dc.l    routine_D   *ADD/ADDA/ADDX
            dc.l    routine_E   *Shift/Rotate
            dc.l    routine_F   *Special/Reserved

routine_0:
    *Bit manipulation/MOVEP/Immediate
    JSR     sub_Bits11to8       *reads A2, returns D7
    
    BRA     Op_Invalid

routine_4:
    *Miscellaneous
    JSR     sub_Bits11to8
    
    CMP.B   #$2,D7              *compares immediate data, 2 in D7
    BRA Op_NOP

routine_5:
    *ADDQ/SUBQ/Scc/DBcc
    MOVE.W  (A2),D7
    
    BTST    #8,D7
    BEQ     OP_AddQ
    
    BRA Op_Invalid

routine_6:
    *BSR,BRA,Bcc
    BRA Op_Invalid

routine_8:
    *OR/DIV/SBCD
    bra Op_Invalid

routine_9:
    *SUB/SUBX
    BRA Op_Invalid

routine_B:
    *CMP/EOR
    BRA Op_Invalid

routine_C:
    *AND/MUL/ABCD/EXG
    BRA Op_Invalid

routine_D:
    *ADD/ADDA/ADDX
    BRA Op_Invalid

routine_E:
    *Shift/Rotate
    BRA Op_Invalid

routine_F:
    *Special/Reserved
    BRA Op_Invalid


returnFromJumptable:
    *stack restore
    *RTS

*-----------------------------------------------------------
*Below are helper methods use to convert bits
*-----------------------------------------------------------
*Evaluates bits 2 to 0
sub_Bits2to0            MOVE.W  (A2),D7     *gets opcode for evauluation
                        MOVE.B  #12,D0      *gets ready to shift 12 bits
                        LSL.W   D0,D7       *truncates up to 4th nibble
                        LSR.W   D0,D7       *isolates nibble
                        RTS
*-----------------------------------------------------------
sub_Bits3to0            MOVE.W  (A2),D7     *gets opcode for evauluation
                        MOVE.B  #13,D0      *gets ready to shift 13 bits
                        LSL.W   D0,D7       *truncates up to 4th nibble
                        LSR.W   D0,D7       *isolates nibble
                        RTS
*-----------------------------------------------------------
sub_Bits5to3            MOVE.W  (A2),D7     *gets opcode for evauluation
                        MOVE.B  #10,D0      *gets ready to shift 10 bits
                        LSL.W   D0,D7       *truncates up to bit 5
                        MOVE.B  #13,D0      *gets ready to shift 13 bits
                        LSR.W   D0,D7      *gets remainder
                        RTS
*-----------------------------------------------------------
sub_Bits7to0            MOVE.W  (A2),D7     *gets opcode for evauluation
                        LSL.W   #8,D7       *truncates up to 7th bit
                        LSR.W   #8,D7       *isolates nibble
                        RTS
*-----------------------------------------------------------
sub_Bits7to4            MOVE.W  (A2),D7     *gets opcode for evauluation
                        LSL.W   #8,D7       *truncates up to 7th bit 
                        MOVE.B  #12,D0      *gets ready to shift 12 bits
                        LSR.W   D0,D7       *isolates nibble
                        RTS
*-----------------------------------------------------------
sub_Bits7to6            MOVE.W  (A2),D7     *gets opcode for evauluation
                        LSL.W   #8,D7       *truncates up to 7th bit 
                        MOVE.B  #14,D0      *gets ready to shift 14 bits
                        LSR.W   D0,D7       *isolates nibble
                        RTS
*-----------------------------------------------------------
sub_Bits8to3            MOVE.W  (A2),D7     *gets opcode for evauluation
                        LSL.W   #7,D7       *truncates up to 8th bit 
                        MOVE.B  #10,D0      *gets ready to shift 10 bits
                        LSR.W   D0,D7       *isolates nibble
                        RTS
*-----------------------------------------------------------
sub_Bits8to4            MOVE.W  (A2),D7     *gets opcode for evauluation
                        LSL.W   #7,D7       *truncates up to 8th bit 
                        MOVE.B  #11,D0      *gets ready to shift 11 bits
                        LSR.W   D0,D7       *isolates nibble
                        RTS     
*-----------------------------------------------------------
sub_Bits8to6            MOVE.W  (A2),D7     *gets opcode for evauluation
                        LSL.W   #7,D7       *truncates up to 8th bit 
                        MOVE.B  #13,D0      *gets ready to shift 13 bits
                        LSR.W   D0,D7       *isolates nibble
                        RTS
*-----------------------------------------------------------
sub_Bits11to6           MOVE.W  (A2),D7     *gets opcode for evauluation
                        LSL.W   #4,D7       *truncates up to 11th bit 
                        MOVE.B  #10,D0      *gets ready to shift 10 bits
                        LSR.W   D0,D7       *isolates nibble
                        RTS
*-----------------------------------------------------------
sub_Bits11to8           MOVE.W  (A2),D7     *gets opcode for evauluation
                        LSL.W   #4,D7       *truncates up to 11th bit 
                        MOVE.B  #12,D0      *gets ready to shift 13 bits
                        LSR.W   D0,D7       *isolates nibble
                        RTS
*-----------------------------------------------------------
sub_Bits11to9           MOVE.W  (A2),D7     *gets opcode for evauluation
                        LSL.W   #4,D7       *truncates up to 11th bit 
                        MOVE.B  #13,D0      *gets ready to shift 13 bits
                        LSR.W   D0,D7       *isolates nibble
                        RTS
*-----------------------------------------------------------


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
