*-----------------------------------------------------------
* Title      : Disassembler Final Project
* Written by : Team Awesome (Olga Rocheeva, Dwina Solihin, Peter Stanton)
* Date       : April 15, 2017
* Description: CSS 422 Final Project
*-----------------------------------------------------------
            MOVEQ.L #0,D1           *Clear D1
            MOVE.L  D0,D1           *Move the opcode to D1              
            
            LEA     jumptable,A1    *loads the jumptable into A1    
            
            ROL.L   #4,D1           *Moves the index to the right nibble
            ANDI.B  #$0F,D1          *Gets the first nibble
            MOVEA.L (0,A1,D1.W),A0  *It has 4 byte table entries
            JMP     (A0)            *Jumps to specified routine


jumptable:      DC.L    routine_0   *Bit manipulation/MOVEP/Immediate (D)
                DC.L     Op_Invalid    *Move Byte(D)
                DC.L     Op_Invalid     *Move Long (D)
                DC.L     Op_Invalid    *Move Word (D)
                DC.L    routine_4   *Misc
                DC.L    routine_5   *ADDQ/SUBQ/Scc/DBcc
                DC.L    routine_6   *BSR,BRA,Bcc
                DC.L     Op_Invalid     *MOVEQ
                DC.L    routine_8   *OR/DIV/SBCD 
                DC.L    routine_9   *SUB/SUBX
                DC.L    Op_Invalid  *Unassigned (D)
                DC.L    routine_B   *CMP/EOR
                DC.L    routine_C   *AND/MUL/ABCD/EXG
                DC.L    routine_D   *ADD/ADDA/ADDX
                DC.L    routine_E   *Shift/Rotate
                DC.L    routine_F   *Special/Reserved

routine_0:
    *Bit manipulation/MOVEP/Immediate
    JSR     sub_Bits11to8       *reads A2, returns D7
    BRA     Op_Invalid          *if unable to convert, goes to invalid    

routine_4:
    *Miscellaneous
    JSR     sub_Bits11to8
    CMP.B   #$2,D7              *compares immediate data, 2 in D7
    BRA     Op_NOP

routine_5:
    *ADDQ/SUBQ/Scc/DBcc
    *MOVE.W  (A2),D7
    *BTST    #8,D7
    *BEQ     OP_AddQ
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
                        LSR.W   D0,D7       *gets remainder
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
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
