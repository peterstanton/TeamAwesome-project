*TEST  ORG $1000                       
*    CMP.B        D1,D4
*    CMP.B        (A5),D5
*    CMP.B        (A3)+,D6
*    CMP.B        -(A2),D7
*    CMP.B        $0,D6
*    CMP.B        $1000,D0
*    CMP.B        $8000,D1
*    CMP.B        $FF0FF0FF,D2
*    CMP.B        #0,D3
*    CMP.B        #$FF,D4
*    
*
*START  ORG $6000
*               MOVEA.L #$1000,A2 ** TEST START ADDRESS
*               MOVEA.L #$1040,A3 ** TEST END ADDRESS
*               JSR MAIN_LOOP
*** D3 - ISOLATED BITS FOR COMPARISONS
*** D4 - MODE
*** D5 - CURRENT OPCODE
***
*** 
MAIN_LOOP
                 
                 LEA     jmp_table,A0    *Index into the table
                 LEA     BUFFER, A6      * Load buffer into A6
                 CLR.L   D3              *Zero it
                 
                 ADDQ.B  #1,linecount
                 CMPI.B  #29,linecount
                 BEQ     IO_PauseOutput
                 
                 MOVE.W  (A2), D3                                     
                 JSR    PRINT_ADDRESS
                 ADD.W   #2,A2 * Can safely increment the current address by a word
                 MOVE.W  D3,D5       * Before manipulating opcode, store in D5 
                 MOVE.B  #12,D4      *Shift 12 bits to the right  
                 LSR.W   D4,D3       *Move the bits
                 MULU    #6,D3       *Form offset     
                 JSR     0(A0,D3)   *Jump indirect with index
                 JSR     PRINT_BUFFER * GOT OPCODE AND EA LINE, PRINT IT
                 CMP     A3,A2
                 BGT     IO_EndProgram
                 BRA     MAIN_LOOP
                 BRA     END_PROGRAM
                                
*    INCLUDE 'definitions.x68'
*    INCLUDE 'TEST_CODE.x68'
*           
*EXIT                 
*       SIMHALT   
       
jmp_table      JMP         code0000
                *ADDI

               JMP         code0001

               JMP         code0010

               JMP         code0011

               JMP         code0100
                           
               JMP         code0101
               * ADDQ
                
      
               JMP         code0110
               
               * BCC
               * BGT
               * BLE
               
               JMP         code0111
               * MOVEQ

               JMP         code1000
               * DIVU
               * OR

               JMP         code1001
                *SUB
               JMP         code1010
               
               JMP         code1011
               * CMP
               
               JMP         code1100
               * MULS
               * AND
        
               JMP         code1101
               *ADD
               *ADDA
               JMP         code1110
               * ASR
               * ASL
               * LSL
               * LSR
               * ROL
               * ROR

               JMP         code1111

* todo: complete check for invalid opcode
code0000      
               JSR          bits5to8 // RETURNS INTO D3
               CMP.L        #%0110, D3
               BNE          INVALID_OP
               BRA          ADDI  

* todo: complete check for invalid opcode
code0001      
               * MOVE/A BYTE
               ** CHECK IF MOVEA
               JSR         bits8to10
               CMP         #%001,D3
               BEQ         INVALID_OP  ** MOVEA CAN'T MOVE BYTE
               JSR         CHECK_INVALID_IMMEDIATE  ***TO DO: SHOULD ALSO CHECK ADDRESS REGISTER FOR MOVES
               BRA         MOVE_B

* todo: complete check for invalid opcode
code0010       * MOVE/A LONG
               * CHECK IF MOVEA
               JSR         bits8to10
               CMP         #%001,D3
               BEQ         MOVEA_L
               JSR         CHECK_INVALID_IMMEDIATE
               BRA         MOVE_L

* todo: complete check for invalid opcode
code0011       * MOVE/A WORD
               JSR         bits8to10
               CMP         #%001,D3
               BEQ         MOVEA_W
               JSR         CHECK_INVALID_IMMEDIATE
               BRA         MOVE_W
               
* TO DO: CHECK MOVEM AND LEA, ALL OTHER OPCODES CHECKED
code0100       
               JSR COPY_OPCODE // Makes a copy of Opcode into d2
                
               *NOP
               AND     #%0000111111111111,D2
               CMP.L   #%000111001110001, D2
               BEQ     NOP
               
               JSR COPY_OPCODE // Makes a copy of Opcode into d2
               *RTS
               AND     #%0000111111111111,D2
               CMP.L   #%0000111001110101, D2
               BEQ     RTS
                
                ** TODO: NEED THE OPCODE FIRST
               * NONE OF THE FOLLOWING OPCODES CAN DO IMMEDIATE
               JSR     bits11to16
               CMP     #%111100,D3
               BEQ     INVALID_EA
               
               JSR COPY_OPCODE // Makes a copy of Opcode into d2
               *JSR
               AND     #%0000111111000000,D2
               CMP.L   #%0000111010000000,D2
               BEQ     JSR
               
               JSR COPY_OPCODE // Makes a copy of Opcode into d2
               AND     #%0000000110000000,D2
               CMP.L   #%0000000110000000,D2
               BEQ     LEA
                
                              * MOVEM
                ** 0 1	0 0  	1 | D | 0	0 1 | S	M	Xn	
              ** AND     #%0000111110000000,D2
               * DATA REGISTER
              ** CMP.L   #%0000100010000000, D2
               ** JSR      MOVEM
               * ADDRESS REGISTER (DECREMENTED)
               ** CMP.L  #%0000110010000000, D2
               BRA      MOVEM
               
* TO DO: CHECK REMAINING OPCODES
code0101      

                BRA   ADDQ

code0110
                ***TODO: ADDI
                
                JSR     COPY_OPCODE //make a copy of OPcode into d2
                AND     #%0000111100000000,D2
                CMP.L   #%0000010000000000,D2
                BEQ     BCC
                
                CMP     #%0000111000000000,D2
                BEQ     BGT
                
                CMP     #%0000111100000000,D2
                BEQ     BLE

code0111       
                BRA       MOVEQ

code1000      
                JSR        bits8to10
                CMP        #%011, D3  ** ONLY TIME IT'S DIVU
                BEQ        DIVU
                BRA        OR       ** OTHERWISE OR
                

code1001       BRA         SUB

code1010       BRA         INVALID_OP

code1011       
               BRA         CMP

code1100      
                JSR        bits8to10
                CMP        #%111, D3  ** ONLY TIME IT'S MULS
                BEQ        MULS
                BRA        AND       ** OTHERWISE AND

code1101       
               JSR COPY_OPCODE // Makes a copy of Opcode into d2
               *ADDA
               JSR      bits8to10
               CMP      #%011, D3  ** WORD
               BEQ      ADDA
               CMP      #%111, D3   ** LONG
               BEQ      ADDA
               
               *ADD
               CMP      #%000, D3   ** BYTE TO DATA REGISTER
               BEQ      ADD
               CMP      #%001, D3   ** WORD TO DATA REGISTER
               BEQ      ADD
               CMP      #%010, D3   ** LONG TO DATA REGISTER
               BEQ      ADD
               CMP      #%100, D3   ** BYTE TO EA
               BEQ      ADD
               CMP      #%101, D3   ** WORD TO EA
               BEQ      ADD
               CMP      #%110, D3   ** LONG TO EA
               BEQ      ADD
               

code1110       
                * ASR
                JSR     bits1to10
                CMP     #%1110000011,D3
                BEQ     ASR_MEM
                
                * ASL
                CMP     #%1110000111,D3
                BEQ     ASL_MEM
                
                * LSL -- has register/immediate shift and 
                
                ** bit 8 is the direction
                CMP     #%1110001110,D3
                BEQ     LSL_MEM
                
                * LSR
                CMP     #%1110001010,D3
                BEQ     LSR_MEM
                
                * ROL
                
                * ROR

code1111       BRA       INVALID_OP

*************************************



BCC
           MOVE.B   #'B',(A6)+
           MOVE.B   #'C',(A6)+
           MOVE.B   #'C',(A6)+
           MOVE.B   #' ',(A6)+

*************************************

BGT
           MOVE.B   #'B',(A6)+
           MOVE.B   #'G',(A6)+
           MOVE.B   #'T',(A6)+
           MOVE.B   #' ',(A6)+





*************************************

BLE
           MOVE.B   #'B',(A6)+
           MOVE.B   #'L',(A6)+
           MOVE.B   #'E',(A6)+
           MOVE.B   #' ',(A6)+



*************************************


ADDA    
               JSR     ADDA_BUFFER
               BRA     PRINT_BUFFER
                
ADDA_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'D', (A6)+  
               MOVE.B   #'D', (A6)+
               MOVE.B   #'A', (A6)+
               JSR      GETSIZE_ADDA
               MOVE.B   #' ', (A6)+
               RTS
           
*********************************************      
MOVEA_W
        JSR     MOVE_BUFFER
        MOVE.B  #'A', (A6)+
        JSR     SIZEISWORD
        JSR     MOVE_W_SRC
        MOVE.B  #',', (A6)+
        MOVE.B  #' ', (A6)+
        JSR     MOVE_W_DEST
        RTS
        
        
MOVEA_L
        JSR     MOVE_BUFFER
        MOVE.B  #'A', (A6)+
        JSR     SIZEISLONG
        JSR     MOVE_L_SRC
        MOVE.B  #',', (A6)+
        MOVE.B  #' ', (A6)+
        JSR     MOVE_L_DEST
        RTS
 
MOVE_BUFFER
        MOVE.B  #'M', (A6)+
        MOVE.B  #'O', (A6)+
        MOVE.B  #'V', (A6)+
        MOVE.B  #'E', (A6)+
        RTS
        
MOVE_B
        JSR     MOVE_BUFFER
        JSR     SIZEISBYTE
        JSR     MOVE_B_SRC
        MOVE.B  #',', (A6)+
        MOVE.B  #' ', (A6)+
        JSR     MOVE_B_DEST
        RTS
        
MOVE_B_SRC
        JSR     BITS11TO16_BYTE_SRC
        RTS

MOVE_B_DEST
        JSR     BITS5TO10_BYTE_DEST
        RTS

MOVE_W_SRC
        JSR     BITS11TO16_WORD_SRC
        RTS

MOVE_W_DEST
        JSR     BITS5TO10_WORD_DEST
        RTS
MOVE_L_SRC
        JSR     BITS11TO16_LONG_SRC
        RTS

MOVE_L_DEST
        JSR     BITS5TO10_LONG_DEST
        RTS

BITS11TO16_BYTE_SRC
        JSR     bits11to16
        CMP     #%111000, D3 *** ABSOLUTE WORD
        BEQ     ABSOLUTE_WORD
        CMP     #%111001, D3 *** ABSOLUTE LONG 
        BEQ     ABSOLUTE_LONG
        CMP     #%111100, D3 *** IMMEDIATE
        BEQ     IMMEDIATE_BYTE
        
        ** OTHERWISE SOURCE IS DIFFERENT
        JSR    BITS11TO13MODE
        RTS
        
BITS5TO10_BYTE_DEST
        JSR     bits5to10
        CMP     #%000111, D3 *** ABSOLUTE WORD
        BEQ     ABSOLUTE_WORD
        CMP     #%001111, D3 *** ABSOLUTE LONG 
        BEQ     ABSOLUTE_LONG
        CMP     #%100111, D3 *** IMMEDIATE
        BEQ     IMMEDIATE_BYTE
 
        ** OTHERWISE DES IS DIFFERENT
        JSR    BITS8TO10MODE
        RTS
    *----
BITS11TO16_WORD_SRC
        JSR     bits11to16
        CMP     #%111000, D3 *** ABSOLUTE WORD
        BEQ     ABSOLUTE_WORD
        CMP     #%111001, D3 *** ABSOLUTE LONG 
        BEQ     ABSOLUTE_LONG
        CMP     #%111100, D3 *** IMMEDIATE
        BEQ     IMMEDIATE_WORD
        
        ** OTHERWISE SOURCE IS DIFFERENT
        JSR    BITS11TO13MODE
        RTS
        
BITS5TO10_WORD_DEST
        JSR     bits5to10
        CMP     #%000111, D3 *** ABSOLUTE WORD
        BEQ     ABSOLUTE_WORD
        CMP     #%001111, D3 *** ABSOLUTE LONG 
        BEQ     ABSOLUTE_LONG
        CMP     #%100111, D3 *** IMMEDIATE
        BEQ     IMMEDIATE_WORD
 
        ** OTHERWISE DES IS DIFFERENT
        JSR    BITS8TO10MODE
        RTS
 *-------
BITS11TO16_LONG_SRC
        JSR     bits11to16
        CMP     #%111000, D3 *** ABSOLUTE WORD
        BEQ     ABSOLUTE_WORD
        CMP     #%111001, D3 *** ABSOLUTE LONG 
        BEQ     ABSOLUTE_LONG
        CMP     #%111100, D3 *** IMMEDIATE
        BEQ     IMMEDIATE_LONG
        
        ** OTHERWISE SOURCE IS DIFFERENT
        JSR    BITS11TO13MODE
        RTS
        
BITS5TO10_LONG_DEST
        JSR     bits5to10
        CMP     #%000111, D3 *** ABSOLUTE WORD
        BEQ     ABSOLUTE_WORD
        CMP     #%001111, D3 *** ABSOLUTE LONG 
        BEQ     ABSOLUTE_LONG
        CMP     #%100111, D3 *** IMMEDIATE
        BEQ     IMMEDIATE_LONG
 
        ** OTHERWISE DES IS DIFFERENT
        JSR    BITS8TO10MODE
        RTS

BITS11TO13MODE
        JSR    bits11to13
        MOVE   D3,D4
        LEA     jmp_mode,A0    *Index into the table
        MULU   #6,D3
        JSR    0(A0,D3)     
        JSR    bits14to16
        JSR    insert_num
        RTS
             
BITS8TO10MODE
        JSR    bits8to10
        MOVE   D3,D4
        LEA     jmp_mode,A0    *Index into the table
        MULU   #6,D3
        JSR    0(A0,D3)     
        JSR    bits5to8
        JSR    insert_num
        RTS
             
MOVE_W
        JSR     MOVE_BUFFER
        JSR     SIZEISWORD
        JSR     MOVE_W_SRC
        MOVE.B  #',', (A6)+
        MOVE.B  #' ', (A6)+
        JSR     MOVE_W_DEST
        RTS
                
MOVE_L    
        JSR     MOVE_BUFFER
        JSR     SIZEISLONG
        JSR     MOVE_L_SRC
        MOVE.B  #',', (A6)+
        MOVE.B  #' ', (A6)+
        JSR     MOVE_L_DEST
        RTS
        

IMMEDIATE_BYTE
               MOVE.B #'#', (A6)+
               JSR     ABSOLUTE_WORD  
               RTS
IMMEDIATE_WORD
               MOVE.B #'#', (A6)+
               JSR     ABSOLUTE_WORD 
               RTS
IMMEDIATE_LONG   
               MOVE.B #'#', (A6)+
               JSR     ABSOLUTE_LONG     
               RTS
ADD    
               JSR     ADD_BUFFER
               RTS
                
ADD_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'D', (A6)+  
               MOVE.B   #'D', (A6)+
               JSR      GETSIZE_ADD
               
               ;Okay, the directionality bit in D6 should determine which order we should process bits in?
               
               CMP      #1,D6
               BNE      ADD_DIRECTION_REVERSED
               JSR      ADD_SRC
               MOVE.B   #',', (A6)+
               MOVE.B   #' ', (A6)+
               JSR      ADD_DEST
               RTS
               
               
ADD_DIRECTION_REVERSED
               CLR      D6
               JSR      ADD_DEST
               MOVE.B   #',', (A6)+
               MOVE.B   #' ', (A6)+
               JSR      ADD_SRC      
               RTS       
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
               
ADD_SRC
                CLR.L   D7
                JSR     bits14to16
                MOVE.B  D3,D7 ** need to know if immediate or absolute
                
                JSR     bits11to13  ** mode to jump with 
                MOVE.B  D3,D4
                
                LEA     jmp_mode,A0  *Index into the table
                MULU    #6,D3
                JSR     0(A0,D3) 
                JSR     bits14to16 ** register number if not absolute or immediate
                
                CMP.B   #$FF,D7
                BNE     NUM_INSERT    
                
                RTS
                
NUM_INSERT  
            JSR insert_num
            RTS   
ADD_DEST
                MOVE.W #%000,D3     ;Can only have a data register.
                MOVE   D3,D4
                LEA     jmp_mode,A0    *Index into the table
                MULU    #6,D3       *Form offset     
                JSR     0(A0,D3)   *Jump indirect with index
                JSR     bits5to7
                JSR     insert_num
                RTS
                              
ADDI
                JSR     ADDI_BUFFER
                JSR     ADDI_SRC
                JSR     ADDI_DES
                RTS
                
ADDI_SRC                        
                CLR.L   D7
                JSR     bits14to16
                MOVE.B  D3,D7 ** need to know if immediate or absolute
                JSR     bits11to13  ** mode to jump with 
                MOVE.B  D3,D4
                LEA     jmp_mode,A0  *Index into the table
                MULU    #6,D3
                JSR     0(A0,D3) 
                JSR     bits14to16 ** register number if not absolute or immediate
                CMP.B   #$FF,D7
                BNE     NUM_INSERT    
                RTS

                RTS
                  ** TODO: IMPLEMENT THIS IN EA
                ** Immediate field Data immediately following the instruction.
                **If size = 00, the data is the low-order byte of the immediate word.
                **If size = 01, the data is the entire immediate word.
                **If size = 10, the data is the next two immediate words. 
ADDI_DES
                * LATER BITS ARE DESTINATION (11 TO 13 FOR MODE, 14 TO 16 FOR REGISTER)
                ** INVALID INCLUDE AN, IMMEDIATE AND TYPICAL INVALIDS
               JSR      bits11to13
               CMP      #%001, D3 **AN
               BEQ      INVALID_EA
               CMP      #%101, D3 **COMPLICATED
               BEQ      INVALID_EA
               CMP      #%110, D3 **COMPLICATED
               BEQ      INVALID_EA
               
               JSR      bits11to16 // check mode and register, invalid if immediate or 111010, 111011
               CMP      #%111100,D3 // immediate data
               BEQ      INVALID_EA
               CMP      #%111010,D3 // complicated
               BEQ      INVALID_EA
               CMP      #%111011,D3 // complicated
               BEQ      INVALID_EA
               
               JSR      bits11to13 ** grab bits to jump with\
               MOVE     D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index
               
               CLR     D3
               JSR     bits14to16
               JSR     insert_num
               CLR     D4
               
               RTS
               
                           
ADDI_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'D', (A6)+  
               MOVE.B   #'D', (A6)+
               MOVE.B   #'I', (A6)+
               
               JSR      GETSIZE_ADDI
               
               ** TODO: ADD SIZE BASED ON BITS 9 TO 10   
               ** VALID SIZES ARE B (00),W (01) ,L (10)
               MOVE.B   #' ', (A6)+
               RTS
                            
LEA
               JSR      bits8to10   // 1 1 1
               CMP      #7, D2 // if the returned bits are not 7, it's not LEA
               BNE      INVALID_OP
               JSR      LEA_BUFFER
               JSR      LEA_SRC
               MOVE.B     #',', (A6)+
               MOVE.B     #' ', (A6)+
               JSR      LEA_DEST
               RTS
               
LEA_BUFFER 
               MOVE.B   #'L',(A6)+
               MOVE.B   #'E', (A6)+  
               MOVE.B   #'A', (A6)+
               MOVE.B   #' ', (A6)+
               RTS
          
LEA_SRC
            *INVALID SRCS ARE DN, AN, (AN)+, -(AN), 101 (COMPLICATED, 110, #DATA
            JSR      bits11to13  // source mode - D3
            CMP      #%000, D3
            BEQ      INVALID_EA
            CMP      #%001, D3
            BEQ      INVALID_EA
            CMP      #%011, D3
            BEQ      INVALID_EA
            CMP      #%100, D3
            BEQ      INVALID_EA
            CMP      #%101, D3
            BEQ      INVALID_EA
            CMP      #%110, D3
            BEQ      INVALID_EA

             JSR      bits11to16 // check mode and register, invalid if immediate or 111010, 111011
             CMP      #%111100,D3 // immediate data
             BEQ      INVALID_EA
             CMP      #%111010,D3 // complicated
             BEQ      INVALID_EA
             CMP      #%111011,D3 // complicated
             BEQ      INVALID_EA
   
             JSR     bits11to16 ** finds if absolute long or word
             CMP     #%111000, D3
             BEQ     ABSOLUTE_WORD
             CMP     #%111001, D3
             BEQ     ABSOLUTE_LONG

             JSR      bits11to13  // source mode - D3
             MOVE     D3,D4
             LEA     jmp_mode,A0    *Index into the table
             MULU    #6,D3       *Form offset     
             JSR     0(A0,D3)   *Jump indirect with index

             JSR     bits14to16
             JSR     insert_num
             CLR     D3
             CLR     D4 

             RTS
             
LEA_DEST    
                CLR     D4
                LEA     jmp_mode,A0    * LOAD MODE TABLE FOR JUMPING            
                MOVE.W  #%001,D3    * LEA CAN ONLY HAVE AN AS DESTINATION
                MOVE    D3,D4
                MULU    #6,D3       *Form offset     
                JSR     0(A0,D3)   *Jump indirect with index
                
                JSR     bits5to7
                JSR     insert_num
                
                RTS

*************************************************

ADDQ
                JSR     ADDQ_BUFFER
                JSR     ADDQ_SRC
                MOVE.B  #',',(A6)+
                MOVE.B  #' ',(A6)+
                JSR     ADDQ_DEST
                RTS                 ;BRA     PRINT_BUFFER

ADDQ_SRC
                JSR     bits5to7
                MOVE.B  #'#',(A6)+
                MOVE.B  #%000,D4
                JSR     insert_num
                CLR     D4
                RTS
                
ADDQ_DEST
               JSR      bits11to13
               MOVE     D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index
               CLR     D3
               JSR     bits14to16
               JSR     insert_num
               CLR     D4
               CLR     D3
               RTS
               
                    
ADDQ_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'D', (A6)+  
               MOVE.B   #'D', (A6)+
               MOVE.B   #'Q', (A6)+
               JSR      GETSIZE_ADDQ
               ** TODO: ADD SIZE BASED ON BITS 9 TO 10
               ** VALID SIZES ARE B (00),W (01) ,L (10)
               RTS               


****************************************               
MOVEQ
                JSR     MOVEQ_BUFFER  
                BRA     PRINT_BUFFER

MOVEQ_BUFFER
               MOVE.B   #'M',(A6)+
               MOVE.B   #'O', (A6)+  
               MOVE.B   #'V', (A6)+
               MOVE.B   #'E', (A6)+
               MOVE.B   #'Q', (A6)+
               MOVE.B   #'.', (A6)+
               MOVE.B   #'L', (A6)+
               MOVE.B   #' ', (A6)+
               RTS


****************************************

DIVU
                JSR     bits8to10
                CMP     #%011,D3
                BNE     INVALID_EA
                CLR     D3
                JSR     DIVU_BUFFER
                JSR     DIVU_SRC
                MOVE.B  #',',(A6)+
                MOVE.B  #' ',(A6)+
                JSR     DIVU_DEST
                RTS                 ;BRA     PRINT_BUFFER

DIVU_BUFFER
               MOVE.B   #'D',(A6)+
               MOVE.B   #'I', (A6)+  
               MOVE.B   #'V', (A6)+
               MOVE.B   #'U', (A6)+
               MOVE.B   #' ', (A6)+
               RTS  
               
               
DIVU_SRC

                CLR.L   D7
                JSR     bits14to16
                MOVE.B  D3,D7 ** need to know if immediate or absolute


               JSR      bits11to13
               MOVE     D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits14to16
               
                CMP.B   #$FF,D7
                BNE     NUM_INSERT    
                
               CLR     D4
               CLR     D3
               RTS
               
DIVU_DEST
               MOVE    #%000,D3     ;DIVU destination can only be a data register.
               MOVE    D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits5to7
               JSR     insert_num
               CLR     D4
               CLR     D3
               RTS
               
               
               
*****************************************               
               
OR    
               JSR     OR_BUFFER              
               ;Okay, the directionality bit in D6 should determine which order we should process bits in?
               CMP      #1,D6
               BNE      OR_DIRECTION_REVERSED
               CLR      D6
               JSR      OR_SRC
               MOVE.B   #',', (A6)+
               MOVE.B   #' ', (A6)+
               JSR      OR_DEST
               RTS
               
               
OR_DIRECTION_REVERSED
               CLR      D6
               JSR      OR_DEST
               MOVE.B   #',', (A6)+
               MOVE.B   #' ', (A6)+
               JSR      OR_SRC             
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA>                
               
               
               RTS                  ;BRA     PRINT_BUFFER
                
OR_BUFFER
               MOVE.B   #'O',(A6)+
               MOVE.B   #'R', (A6)+
               JSR      GETSIZE_OR  
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
               MOVE.B   #' ', (A6)+
               RTS   
               
               
               
               
OR_SRC

                CLR.L   D7
                JSR     bits14to16
                MOVE.B  D3,D7 ** need to know if immediate or absolute
                
                
               JSR      bits11to13
               CMP      #%001,D3
               BEQ      INVALID_EA
               MOVE     D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits14to16
               
                  CMP.B   #$FF,D7
                BNE     NUM_INSERT    
                
               CLR     D3
               CLR     D4
               RTS


OR_DEST
               MOVE.B  #%000,D3
               MOVE    D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits5to7    
               JSR     insert_num
               CLR     D3
               CLR     D4
               RTS   






***********************************************

SUB   
               JSR     SUB_BUFFER
               ;Okay, the directionality bit in D6 should determine which order we should process bits in?
               CMP      #1,D6
               BNE      SUB_DIRECTION_REVERSED
               CLR      D6
               JSR      SUB_SRC
               MOVE.B   #',', (A6)+
               MOVE.B   #' ', (A6)+
               JSR      SUB_DEST
               RTS
               
               
SUB_DIRECTION_REVERSED
               CLR      D6
               JSR      OR_DEST
               MOVE.B   #',', (A6)+
               MOVE.B   #' ', (A6)+
               JSR      OR_SRC             
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA>                
               
               
               RTS                  ;BRA     PRINT_BUFFER
               
SUB_BUFFER
               MOVE.B   #'S',(A6)+
               MOVE.B   #'U', (A6)+  
               MOVE.B   #'B', (A6)+
               JSR      GETSIZE_SUB
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
               MOVE.B   #' ', (A6)+
               RTS  
             
               
SUB_SRC



                CLR.L   D7
                JSR     bits14to16
                MOVE.B  D3,D7 ** need to know if immediate or absolute
                
                
               JSR      bits11to13
               MOVE     D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits14to16
               
                 CMP.B   #$FF,D7
                BNE     NUM_INSERT    
               
               CLR     D3
               CLR     D4
               RTS


SUB_DEST
               MOVE.B  #%000,D3
               MOVE    D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits5to7    
               JSR     insert_num
               CLR     D3
               CLR     D4
               RTS    
         
************************************************   
************************************************               
              
               
               
CMP   
               JSR     CMP_BUFFER
                              ;Okay, the directionality bit in D6 should determine which order we should process bits in?
               CMP      #1,D6
               BNE      CMP_DIRECTION_REVERSED
               CLR      D6
               JSR      CMP_SRC
               MOVE.B   #',', (A6)+
               MOVE.B   #' ', (A6)+
               JSR      CMP_DEST
               RTS

CMP_DIRECTION_REVERSED
               CLR      D6
               JSR      CMP_DEST
               MOVE.B   #',', (A6)+
               MOVE.B   #' ', (A6)+
               JSR      CMP_SRC             
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA>                               
               RTS                  ;BRA     PRINT_BUFFER
               
                              
               
               
CMP_SRC


                CLR.L   D7
                JSR     bits14to16
                MOVE.B  D3,D7 ** need to know if immediate or absolute
                
                
               JSR      bits11to13
               MOVE     D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits14to16
               
                CMP.B   #$FF,D7
                BNE     NUM_INSERT    
               
               
               CLR     D3
               CLR     D4
               RTS                      


CMP_DEST
               MOVE.B  #%000,D3
               MOVE    D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits5to7    
               JSR     insert_num
               CLR     D3
               CLR     D4
               RTS   
               
CMP_BUFFER
               MOVE.B   #'C',(A6)+
               MOVE.B   #'M', (A6)+  
               MOVE.B   #'P', (A6)+
               JSR      GETSIZE_CMP
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
               MOVE.B   #' ', (A6)+
               RTS   
               
               
               
               CLR     D4
               RTS   

************************************************
               
************************************************               
              
************************************************               
              
MULS
                JSR     MULS_BUFFER  ;returns with size bits in D3
                CMP     #%000,D3
                BNE     MULS_MAIN_SIZENOTWORD
                CLR     D3
                JSR     MULS_ISWORD
                BRA     MULS_DONE
                
MULS_MAIN_SIZENOTWORD
                CLR     D3
                JSR     MULS_ISLONG
                BRA     MULS_DONE
                
                ;go to word, long, etc.
                
MULS_DONE                
                RTS                     ;BRA     PRINT_BUFFER


MULS_BUFFER
               MOVE.B   #'M',(A6)+
               MOVE.B   #'U', (A6)+  
               MOVE.B   #'L', (A6)+
               MOVE.B   #'S', (A6)+
               JSR      GETSIZE_MULS
               MOVE.B   #' ', (A6)+
               RTS



MULS_ISWORD
               CLR      D3
               CLR      D4
               JSR      bits11to13
               CMP      #%001,D3
               BEQ      INVALID_EA
               MOVE     D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits14to16
               JSR     insert_num
               
               MOVE.B  #',',(A6)+
               MOVE.B  #' ',(A6)+
               MOVE.B  #'D',(A6)+
               
               JSR     bits5to7
               JSR     insert_num
               CLR     D3
               CLR     D4
               RTS
               


MULS_ISLONG

                CLR.L   D7
                JSR     bits14to16
                MOVE.B  D3,D7 ** need to know if immediate or absolute
                
                
               CLR      D3
               CLR      D4
               JSR      bits11to13
               JSR      bits11to13
               CMP      #%001,D3
               MOVE     D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits14to16
               
                CMP.B   #$FF,D7
                BNE     NUM_INSERT    
               
               MOVE.B  #',',(A6)+
               MOVE.B  #' ',(A6)+
               MOVE.B  #'D',(A6)+
               
               MOVE.B  #%100,D3
               JSR     insert_num
               CLR     D3
               CLR     D4
               RTS

************************************************    

************************************************    


************************************************               


************************************************               

AND    
               JSR     AND_BUFFER
                                             ;Okay, the directionality bit in D6 should determine which order we should process bits in?
               CMP      #1,D6
               BNE      CMP_DIRECTION_REVERSED  ;?????
               CLR      D6
               JSR      CMP_SRC
               MOVE.B   #',', (A6)+
               MOVE.B   #' ', (A6)+
               JSR      CMP_DEST
               RTS
                
AND_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'N', (A6)+  
               MOVE.B   #'D', (A6)+
               MOVE.B   #'.', (A6)+
               ** TODO: ADD SIZE BASED ON BITS 8 TO 10
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
               MOVE.B   #' ', (A6)+
               RTS    


**************************************************
ASR_MEM
                JSR     ASR_BUFFER
                JSR     bits11to13
                CMP     #%000,D3
                BEQ     INVALID_EA
                CMP     #%001,D3
                BEQ     INVALID_EA
            
               MOVE    D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               
               JSR      bits14to16
               JSR      insert_num
               RTS
            
**************************************************
ASL_MEM
                JSR     ASL_BUFFER
                JSR     bits11to13
                CMP     #%000,D3
                BEQ     INVALID_EA
                CMP     #%001,D3
                BEQ     INVALID_EA
            
               MOVE    D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               
               JSR      bits14to16
               JSR      insert_num
               RTS 


**************************************************


ASR_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'S', (A6)+  
               MOVE.B   #'R', (A6)+
               MOVE.B   #' ', (A6)+
               RTS      


ASL_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'S', (A6)+  
               MOVE.B   #'L', (A6)+
               MOVE.B   #' ', (A6)+
               RTS     

************************************************

ASR_REG     
                JSR     bits11to13
                CMP     #%001,D3
                BEQ     INVALID_EA
                CMP     #%010,D3
                BEQ     INVALID_EA
                CMP     #%011,D3
                BEQ     INVALID_EA
                CMP     #%101,D3
                BEQ     INVALID_EA
                CMP     #%110,D3
                BEQ     INVALID_EA
                CMP     #%111,D3
                BEQ     INVALID_EA
                
                JSR     ASR_BUFFER
                                
                CMP     #%000,D3
                BEQ     SHIFT_REG_HOLDSSHIFTCOUNT
                CMP     #%100,D3
                BEQ     AS_REG_HOLDSSHIFTREG
                
AS_DONE
                RTS
                
SHIFT_REG_HOLDSSHIFTCOUNT 

                CLR     D3
                JSR     bits5to7
                MOVE.B  #'#',(A6)+
                
                CMP     #%000,D3
                BNE     SHIFT_NOTEIGHT
                MOVE.B  #'8',(A6)+
                BRA     AS_GETDEST
                
SHIFT_NOTEIGHT  
                CMP     #%001,D3
                BNE     SHIFT_NOTONE
                MOVE.B  #'1',(A6)+
                BRA     AS_GETDEST
                
SHIFT_NOTONE    
                CMP     #%010,D3
                BNE     SHIFT_NOTTWO
                MOVE.B  #'2',(A6)+
                BRA     AS_GETDEST
                

SHIFT_NOTTWO    
                CMP     #%010,D3
                BNE     SHIFT_NOTTHREE
                MOVE.B  #'3',(A6)+
                BRA     AS_GETDEST

SHIFT_NOTTHREE   
                CMP     #%010,D3
                BNE     SHIFT_NOTFOUR
                MOVE.B  #'4',(A6)+
                BRA     AS_GETDEST

SHIFT_NOTFOUR    
                CMP     #%010,D3
                BNE     SHIFT_NOTFIVE
                MOVE.B  #'5',(A6)+
                BRA     AS_GETDEST

SHIFT_NOTFIVE    
                CMP     #%010,D3
                BNE     SHIFT_NOTSIX
                MOVE.B  #'6',(A6)+
                BRA     AS_GETDEST 

SHIFT_NOTSIX    
                CMP     #%010,D3
                MOVE.B  #'7',(A6)+
                BRA     AS_GETDEST                             

AS_REG_HOLDSSHIFTREG
                CLR     D3
                JSR     bits5to7
                MOVE.B  #'D',(A6)+
                CLR     D4
                JSR     insert_num
                CLR     D3
                BRA     AS_GETDEST
                




AS_GETDEST                
                MOVE.B  #',',(A6)+
                MOVE.B  #' ',(A6)+
                
                CLR     D3
                CLR     D4
                MOVE.B  #'D',(A6)+
                JSR     bits14to16
                JSR     insert_num
                BRA     AS_DONE



ASL_REG     
                JSR     bits11to13
                CMP     #%001,D3
                BEQ     INVALID_EA
                CMP     #%010,D3
                BEQ     INVALID_EA
                CMP     #%011,D3
                BEQ     INVALID_EA
                CMP     #%101,D3
                BEQ     INVALID_EA
                CMP     #%110,D3
                BEQ     INVALID_EA
                CMP     #%111,D3
                BEQ     INVALID_EA
                
                JSR     ASL_BUFFER
                                
                CMP     #%000,D3
                BEQ     SHIFT_REG_HOLDSSHIFTCOUNT
                CMP     #%100,D3
                BEQ     AS_REG_HOLDSSHIFTREG
                RTS


*******************************************************

LSL_MEM     
                JSR     bits5to7
                CMP     #%001,D3
                BNE     INVALID_EA
                
                CLR     D3
                JSR     bits8to10
                
                CMP     #%111,D3
                BNE     INVALID_EA
                CLR     D3
                
                JSR     bits11to13
                CMP     #%000,D3
                BEQ     INVALID_EA
                CMP     #%001,D3
                BEQ     INVALID_EA
                
               JSR     LSL_BUFFER
               MOVE    D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               
               JSR     bits14to16
               JSR     insert_num
               CLR     D3
               CLR     D4
                
                RTS

LSL_BUFFER
               MOVE.B   #'L',(A6)+
               MOVE.B   #'S', (A6)+  
               MOVE.B   #'L', (A6)+
               MOVE.B   #' ', (A6)+
               RTS     

LSR_MEM     
                JSR     bits5to7
                CMP     #%001,D3
                BNE     INVALID_EA
                
                CLR     D3
                JSR     bits8to10
                
                CMP     #%011,D3
                BNE     INVALID_EA
                CLR     D3
                
                JSR     bits11to13
                CMP     #%000,D3
                BEQ     INVALID_EA
                CMP     #%001,D3
                BEQ     INVALID_EA
                
                JSR     LSR_BUFFER
               MOVE    D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               
               JSR     bits14to16
               JSR     insert_num
               CLR     D3
               CLR     D4
                
                RTS


LSR_BUFFER
               MOVE.B   #'L',(A6)+
               MOVE.B   #'S', (A6)+  
               MOVE.B   #'R', (A6)+
               MOVE.B   #' ', (A6)+
               RTS       
               
               
               
               
               
LSR_REG     
                JSR     bits11to13
                CMP     #%001,D3
                BEQ     INVALID_EA
                CMP     #%010,D3
                BEQ     INVALID_EA
                CMP     #%011,D3
                BEQ     INVALID_EA
                CMP     #%101,D3
                BEQ     INVALID_EA
                CMP     #%110,D3
                BEQ     INVALID_EA
                CMP     #%111,D3
                BEQ     INVALID_EA
                
                JSR     LSR_BUFFER
                                
                CMP     #%000,D3
                BEQ     SHIFT_REG_HOLDSSHIFTCOUNT
                CMP     #%100,D3
                BEQ     AS_REG_HOLDSSHIFTREG
                


LSL_REG     
                JSR     bits11to13
                CMP     #%001,D3
                BEQ     INVALID_EA
                CMP     #%010,D3
                BEQ     INVALID_EA
                CMP     #%011,D3
                BEQ     INVALID_EA
                CMP     #%101,D3
                BEQ     INVALID_EA
                CMP     #%110,D3
                BEQ     INVALID_EA
                CMP     #%111,D3
                BEQ     INVALID_EA
                
                JSR     LSL_BUFFER
                                
                CMP     #%000,D3
                BEQ     SHIFT_REG_HOLDSSHIFTCOUNT
                CMP     #%100,D3
                BEQ     AS_REG_HOLDSSHIFTREG
                RTS

 
**********************************************
 
**********************************************
ROL_MEM
               JSR      bits5to7
               CMP      #%011,D3
               BNE      INVALID_EA
               CLR      D3
               
               JSR      bits8to10
               CMP      #%111,D3
               BNE      INVALID_EA
               CLR      D3
               
               JSR      bits11to13
               CMP      #%000,D3
               BEQ      INVALID_EA
               CMP      #%001,D3
               BEQ      INVALID_EA
               
               JSR      ROL_BUFFER
               MOVE    D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               
               JSR     bits14to16
               JSR     insert_num
               CLR     D3
               CLR     D4
               RTS
               


ROR_MEM
               JSR      bits5to7
               CMP      #%011,D3
               BNE      INVALID_EA
               CLR      D3
               
               JSR      bits8to10
               CMP      #%011,D3
               BNE      INVALID_EA
               CLR      D3
               
               JSR      bits11to13
               CMP      #%000,D3
               BEQ      INVALID_EA
               CMP      #%001,D3
               BEQ      INVALID_EA
               
               JSR     ROR_BUFFER
               MOVE    D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               
               JSR     bits14to16
               JSR     insert_num
               CLR     D3
               CLR     D4
               RTS
               



ROR_BUFFER
               MOVE.B   #'R',(A6)+
               MOVE.B   #'O',(A6)+
               MOVE.B   #'R',(A6)+
               MOVE.B   #' ',(A6)+
               RTS
               
ROL_BUFFER
               MOVE.B   #'R',(A6)+
               MOVE.B   #'O',(A6)+
               MOVE.B   #'L',(A6)+
               MOVE.B   #' ',(A6)+
               RTS
               
****************************************************




              
jmp_mode
                JMP     MODE000  ** DN
                JMP     MODE001  ** AN
                JMP     MODE010  ** (AN)
                JMP     MODE011  ** (AN)+   
                JMP     MODE100  ** -(AN)
                JMP     MODE101  **INVALID
                JMP     MODE110  **INVALID
                JMP     MODE111  ** ABSOLUTE AND IMMEDIATE

                
insert_num
                
                CMP     #%111,D4
                BEQ     FINISHER
                
                ;get number from D3
                CMP     #%000,D3       ;0
                BNE     ONE         
                MOVE.B  #'0',(A6)+      ;Put ASCII value in buffer.
                BRA     FINISHER
                
ONE             CMP     #%001,D3       ;1
                BNE     TWO 
                MOVE.B  #'1',(A6)+
                BRA     FINISHER

                
TWO             CMP     #%010,D3        ;2
                BNE     THREE
                MOVE.B  #'2',(A6)+
                BRA     FINISHER
                
THREE           CMP     #%011,D3        ;3
                BNE     FOUR
                MOVE.B  #'3',(A6)+
                BRA     FINISHER
                
FOUR            CMP     #%100,D3        ;4
                BNE     FIVE
                MOVE.B  #'4',(A6)+
                BRA     FINISHER
                
FIVE            CMP     #%101,D3        ;5
                BNE     SIX
                MOVE.B  #'5',(A6)+
                BRA     FINISHER
                
SIX             CMP     #%110,D3        ;6
                BNE     SEVEN
                MOVE.B  #'6',(A6)+
                BRA     FINISHER
                
SEVEN           CMP     #%111,D3        ;7
                MOVE.B  #'7',(A6)+
                BRA     FINISHER
                
FINISHER                
                
                ;check D4, do we need to do stuff?
                CMP     #%010,D4
                BNE     POSTINCR
                MOVE.B  #')',(A6)+
                RTS
                
POSTINCR        CMP     #%011,D4
                BNE     ONEPAREN
                MOVE.B  #')',(A6)+
                MOVE.B  #'+',(A6)+
                RTS
                
ONEPAREN        CMP     #%100,D4
                BNE     DONE
                MOVE.B  #')',(A6)+                

                CLR     D4
DONE            RTS

        
               
bits5to7
               CLR      D3
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000111000000000, D2
               ROR.L    #8, D2          // rotate bits so isolated at the end
               ROR.L    #1, D2
               MOVE.W   D2,D3 // moving isolated bits into d3
               RTS
               
bits5to8
               CLR      D3
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000111100000000, D2
               ROR.L    #8, D2          // rotate bits so isolated at the end
               ROR.L    #1, D2
               MOVE.W   D2,D3 // moving isolated bits into d3
               RTS

bits5to10
               CLR      D3
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000111111000000, D2
               ROR.L    #6, D2          // rotate bits so isolated at the end
               MOVE.W   D2,D3 // moving isolated bits into d3
               RTS
               
bits8to10
               CLR      D3
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000000111000000, D2
               ROR.L    #6, D2          // rotate bits so isolated at the end
               MOVE.W   D2,D3 // moving isolated bits into d3
               RTS               
           
bits11to13
               CLR      D3
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000000000111000, D2
               ROR.L    #3, D2          // rotate bits so isolated at the end
               MOVE.W   D2,D3 // moving isolated bits into d3
               RTS
           
bits14to16
               CLR      D3
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000000000000111, D2
               MOVE.W   D2,D3 // moving isolated bits into d3
               RTS
bits11to16
               CLR      D3
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000000000111111, D2
               MOVE.W   D2,D3 // moving isolated bits into d3
               RTS
bits1to10
               CLR      D3
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%1111111111000000, D2
               ROR.L    #6, D2 
               MOVE.W   D2,D3 // moving isolated bits into d3
               RTS
** DN       
MODE000         
                MOVE.B  #'D',(A6)+     
                RTS

** AN
MODE001         
                JSR ADDRESS_BUFFER  
                RTS      

 ** (AN)
MODE010         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+  
                RTS      

** (AN)+ 
MODE011         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+ 
                RTS       

 ** -(AN)
MODE100         
                MOVE.B  #'-', (A6)+
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+
                RTS
                
**INVALID               
MODE101         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+ 
                RTS
                
**INVALID
MODE110         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+
                RTS  

** ABSOLUTE AND IMMEDIATE            
MODE111         
                LEA     sub_mode,A0    *Index into the table
                MULU    #6,D7       *Form offset     
                JSR     0(A0,D7)   *Jump indirect with index
                CLR.L   D7
                MOVE.B  #$FF,D7
                RTS

sub_mode        JMP     ABS_W_MODE  
                JMP     ABS_L_MODE
                JMP     INVALID_EA  
                JMP     INVALID_EA
                JMP     IMMEDIATE
                JMP     INVALID_EA  
                JMP     INVALID_EA 
                JMP     INVALID_EA  
                RTS
ABS_W_MODE  
            JSR  ABSOLUTE_WORD
            RTS     

ABS_L_MODE  
            JSR  ABSOLUTE_LONG
            RTS 

IMMEDIATE 
            CMP.B   #%10, D1
            BEQ     IMMEDIATE_LONG
            BRA     IMMEDIATE_WORD 
            RTS           
                                        
ADDRESS_BUFFER
                MOVE.B  #'A',(A6)+ 
                RTS
               
INVALID_EA  
                * TODO: IMPLEMENT
                *** CLEAR OUT A6
                ** PUT INVALID MESSAGE INTO A6
                BRA MAIN_LOOP
INVALID_OP  
                ** TODO: IMPLEMENT
               *** CLEAR OUT A6
                ** PUT INVALID MESSAGE INTO A6
                    MOVE.B #'D', (A6)+
                    MOVE.B #'A', (A6)+
                    MOVE.B #'T', (A6)+
                    MOVE.B #'A', (A6)+ 
                    MOVE.B #' ', (A6)+ 
                    JSR     PRINT_DEREF_ADDRESS
          
                
NOP                 MOVE.B #'N', (A6)+
                 	MOVE.B #'O', (A6)+
                    MOVE.B #'P', (A6)+
                    RTS
                 
RTS      
                    MOVE.B #'R', (A6)+
                 	MOVE.B #'T', (A6)+
                    MOVE.B #'S', (A6)+
                    RTS
JSR      
                    
                    JSR    bits5to7
                    CMP    #%111,D3
                    BNE    INVALID_EA
                    CLR    D3
                    
                    JSR    bits8to10
                    CMP    #%010,D3
                    BNE    INVALID_EA
                    CLR    D3

                    MOVE.B #'J', (A6)+
                    MOVE.B #'S', (A6)+
                    MOVE.B #'R', (A6)+
                    MOVE.B #' ', (A6)+
                    
                    CLR.L   D7
                    JSR     bits14to16
                    MOVE.B  D3,D7
                    JSR    bits11to13
                    MOVE    D3,D4
                    LEA     jmp_mode,A0    *Index into the table
                    MULU    #6,D3       *Form offset     
                    JSR     0(A0,D3)   *Jump indirect with index  
                    CLR     D3
                    
                    JSR     bits14to16
                    JSR     insert_num
                    CLR     D4
                    CLR     D3

                    ;JSR    ABSOLUTE_LONG
                    RTS
                    
ABSOLUTE_WORD    
               MOVE.B   #'$', (A6)+
               JSR      PRINT_DEREF_ADDRESS
               ADD.W    #2, A2
               RTS
ABSOLUTE_LONG    
               MOVE.B   #'$', (A6)+
               JSR      PRINT_DEREF_ADDRESS
               ADD.W    #2, A2
               JSR      PRINT_DEREF_ADDRESS
               ADD.W    #2, A2
               RTS
           
** TODO: CHANGE MOVEM TO GET SIZE LIKE OTHER OPCODES   
MOVEM      
                    ** SIZE SUBROUTINE
                    ** 0 1	0 0  	1 | D | 0	0 1 | S	M	Xn	
*                    AND #%0000000001000000,D2 
*                    * WORD
*                    CMP.L   #%0000000001000000,D2
*                    JSR     MOVEM_W 
*                    *LONG
*                    CMP.L   #%0000000001000000,D2 
*                   ** JSR     MOVEM_L
*                    MOVE.B  #14,D0
*                    TRAP    #15
*                    RTS 
                    
MOVEM_W             MOVE.B #'M', (A6)+
                    MOVE.B #'O', (A6)+
                    MOVE.B #'V', (A6)+
                    MOVE.B #'E', (A6)+
                    MOVE.B #'M', (A6)+
                    RTS
     
   
COPY_OPCODE 
                     ** HOLDS COPY OF OPCODE TO BE MANIPULATED
                     CLR.L    D2  
                     MOVE.W D5,D2 
                     RTS  

PRINT_ADDRESS     
                 CLR.L         D2
                 MOVE.B      #16,D2          // Setup for Base-16 conversion
                 MOVE.L      A2,D1        
                 MOVE.B      #15,D0          
                 TRAP        #15            
                 MOVE.B      #' ', (A6)+
                 MOVE.B      #' ', (A6)+
                 MOVE.B      #' ', (A6)+
                 MOVE.B      #' ', (A6)+
                 RTS     
PRINT_BUFFER    
               MOVE.B   #%0,  (A6)+ ** null terminate the string       
               LEA      BUFFER, A1
               MOVE.W   #14,D0
               TRAP     #15
              
               LEA     linebreak,A1            *appends line at the end of the user input
               MOVE.B  #14,D0
               TRAP    #15
               RTS  

PRINT_DEREF_ADDRESS
               MOVE.B   #%0,  (A6)+ ** null terminate the string       
               LEA      BUFFER, A1
               MOVE.W   #14,D0
               TRAP     #15
               LEA      BUFFER, A6
               CLR.L      D2
               CMP      #0, (A2)
               BEQ      PRINT_ZEROES
               BRA      PRINT_HEX
               
PRINT_ZEROES
              LEA   BUFFER,A6
              MOVE.B #'0', (A6)+
              MOVE.B #'0', (A6)+
              MOVE.B #'0', (A6)+
              MOVE.B #'0', (A6)+
              RTS
PRINT_HEX
               MOVE.B      #16,D2          // Setup for Base-16 conversion
               MOVE.W      (A2),D1        // print the hex value in current address      
               MOVE.B      #15,D0          
               TRAP        #15 
               RTS

** USED FOR MOVE INVALID SOURCE
CHECK_INVALID_IMMEDIATE
               JSR         bits5to10
               CMP         #%111100,D3
               BEQ         INVALID_OP
               CMP         #%111010,D3
               BEQ         INVALID_OP
               CMP         #%111011,D3
               BEQ         INVALID_OP
               RTS
 ***************************

GETSIZE_ADDQ
                 
           ** VALID SIZES ARE B (00),W (01) ,L (10)    
           JSR      bits8to10
           CMP      #%000,D3
           BNE      ADDQ_NOTBYTE
           JSR      SIZEISBYTE
           CLR.L      D3
           RTS
           
ADDQ_NOTBYTE
           CMP      #%001,D3
           BNE      ADDQ_NOTWORD
           JSR      SIZEISWORD
           CLR.L      D3
           RTS
           
ADDQ_NOTWORD
           CMP      #%010,D3
           BNE      INVALID_EA
           JSR      SIZEISLONG
           CLR.L      D3
           RTS
           
************************************                 




****************************  
GETSIZE_MULS
            JSR     bits8to10
            CMP     #%111,D3
            BNE     MULS_NOTWORD
            JSR     SIZEISWORD
            RTS

MULS_NOTWORD
            CMP     #%000,D3
            BNE     INVALID_EA
            JSR     SIZEISLONG
            RTS
            







****************************


GETSIZE_CMP
               ** TODO: ADD SIZE BASED ON BITS 8 TO 10
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 

            JSR     bits8to10
            CMP     #000,D3
            BNE     CMP_NOTBYTE
            JSR     SIZEISBYTE
            MOVE    #1,D6
            CLR.L     D3
            RTS
            
CMP_NOTBYTE 
            CMP     #%001,D3
            BNE     CMP_NOTWORD
            JSR     SIZEISWORD
            MOVE    #1,D6
            CLR.L     D3
            RTS
            
CMP_NOTWORD
            CMP     #%010,D3
            BNE     CMP_NOTLEFT
            JSR     SIZEISLONG
            MOVE    #1,D6
            CLR.L     D3
            RTS
            
CMP_NOTLEFT     ;check other direction
            CMP     #%100,D3
            BNE     CMP_NOTRIGHTBYTE
            JSR     SIZEISBYTE
            MOVE    #2,D6
            CLR.L     D3
            RTS
            
CMP_NOTRIGHTBYTE
            CMP     #%101,D3
            BNE     CMP_NOTRIGHTWORD
            JSR     SIZEISWORD
            MOVE    #2,D6
            CLR.L     D3
            RTS

CMP_NOTRIGHTWORD
            CMP     #%110,D3
            BNE     INVALID_EA
            JSR     SIZEISLONG
            MOVE    #2,D6
            CLR.L     D3
            RTS 




****************************


GETSIZE_SUB
               ** TODO: ADD SIZE BASED ON BITS 8 TO 10
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
            JSR     bits8to10
            CMP     #000,D3
            BNE     SUB_NOTBYTE
            JSR     SIZEISBYTE
            MOVE    #1,D6
            CLR.L     D3
            RTS
            
SUB_NOTBYTE 
            CMP     #%001,D3
            BNE     SUB_NOTWORD
            JSR     SIZEISWORD
            MOVE    #1,D6
            CLR.L     D3
            RTS
            
SUB_NOTWORD
            CMP     #%010,D3
            BNE     SUB_NOTLEFT
            JSR     SIZEISLONG
            MOVE    #1,D6
            CLR.L     D3
            RTS
            
SUB_NOTLEFT     ;check other direction
            CMP     #%100,D3
            BNE     SUB_NOTRIGHTBYTE
            JSR     SIZEISBYTE
            MOVE    #2,D6
            CLR.L     D3
            RTS
            
SUB_NOTRIGHTBYTE
            CMP     #%101,D3
            BNE     SUB_NOTRIGHTWORD
            JSR     SIZEISWORD
            MOVE    #2,D6
            CLR.L     D3
            RTS

SUB_NOTRIGHTWORD
            CMP     #%110,D3
            BNE     INVALID_EA
            JSR     SIZEISLONG
            MOVE    #2,D6
            CLR.L     D3
            RTS 


****************************
GETSIZE_OR
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
        
            JSR     bits8to10
            CMP     #000,D3
            BNE     OR_NOTBYTE
            JSR     SIZEISBYTE
            MOVE    #1,D6
            CLR.L     D3
            RTS
            
OR_NOTBYTE 
            CMP     #%001,D3
            BNE     OR_NOTWORD
            JSR     SIZEISWORD
            MOVE    #1,D6
            CLR.L     D3
            RTS
            
OR_NOTWORD
            CMP     #%010,D3
            BNE     OR_NOTLEFT
            JSR     SIZEISLONG
            MOVE    #1,D6
            CLR.L     D3
            RTS
            
OR_NOTLEFT     ;check other direction
            CMP     #%100,D3
            BNE     OR_NOTRIGHTBYTE
            JSR     SIZEISBYTE
            MOVE    #2,D6
            CLR.L     D3
            RTS
            
OR_NOTRIGHTBYTE
            CMP     #%101,D3
            BNE     OR_NOTRIGHTWORD
            JSR     SIZEISWORD
            MOVE    #2,D6
            CLR.L     D3
            RTS

OR_NOTRIGHTWORD
            CMP     #%110,D3
            BNE     INVALID_EA
            JSR     SIZEISLONG
            MOVE    #2,D6
            CLR.L   D3
            RTS 

            

                   
****************************

               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
GETSIZE_ADD
            JSR     bits8to10
            CMP     #%000,D3
            BNE     ADD_NOTBYTE
            ****
            CLR.L   D1
            MOVE.B  #%00, D1 ** RECORD SIZE IN D1 FOR IMMEDIATE ADDRESSING
            CLR.L   D6
            ****
            JSR     SIZEISBYTE
            MOVE    #1,D6
            CLR.L    D3
            RTS
        
ADD_NOTBYTE 
            CMP     #%001,D3
            BNE     ADD_NOTWORD
            ****
            CLR.L   D1
            MOVE.B  #%01, D1 ** RECORD SIZE IN D1 FOR IMMEDIATE ADDRESSING
            CLR.L   D6
            ****
            JSR     SIZEISWORD
            MOVE    #1,D6
            CLR.L     D3
            RTS
            
ADD_NOTWORD
            CMP     #%010,D3
            BNE     ADD_NOTLEFT
            ****
            CLR.L   D1
            MOVE.B  #%10, D1 ** RECORD SIZE IN D1 FOR IMMEDIATE ADDRESSING
            CLR.L   D6
            ****
            JSR     SIZEISLONG
            MOVE    #1,D6
            CLR.L    D3
            RTS
            
ADD_NOTLEFT     ;check other direction
            CMP     #%100,D3
            BNE     ADD_NOTRIGHTBYTE
            JSR     SIZEISBYTE
            MOVE    #2,D6
            CLR.L   D3
            RTS
            
ADD_NOTRIGHTBYTE
            CMP     #%101,D3
            BNE     ADD_NOTRIGHTWORD
            ****
            CLR.L   D1
            MOVE.B  #%01, D1 ** RECORD SIZE IN D1 FOR IMMEDIATE ADDRESSING
            CLR.L   D6
            ****
            JSR     SIZEISWORD
            MOVE    #2,D6
            CLR.L    D3
            RTS

ADD_NOTRIGHTWORD
            CMP     #%110,D3
            BNE     INVALID_EA
            ****
            CLR.L   D1
            MOVE.B  #%10, D1 ** RECORD SIZE IN D1 FOR IMMEDIATE ADDRESSING
            CLR.L   D6
            ****
            JSR     SIZEISLONG
            MOVE    #2,D6
            CLR.L   D3
            RTS 
                             
                     
                     
*****************************                  
GETSIZE_ADDI
        JSR     bits8to10
        CMP     #%000,D3
        BNE     ADDI_NOTBYTE
        JSR     SIZEISBYTE
        CLR.L     D3
        RTS

ADDI_NOTBYTE
        CMP     #%001,D3
        BNE     ADDI_NOTWORD
        JSR     SIZEISWORD
        CLR.L     D3
        RTS
        
ADDI_NOTWORD
        CMP     #%010,D3
        BNE     INVALID_EA
        JSR     SIZEISLONG
        CLR.L     D3
        RTS
        
                            
                     
********************************          
                     
                     
********************************                     
GETSIZE_ADDA
        JSR     bits8to10
        CMP     #%011,D3
        BNE     ADDA_NOTWORD
        JSR     SIZEISWORD
        CLR.L     D3
        RTS
        

        
ADDA_NOTWORD
        CMP     #%111,D3
        BNE     INVALID_EA
        JSR     SIZEISLONG
        CLR.L     D3
        RTS
**********************************        
    
SIZEISBYTE
       MOVE.B   #'.',(A6)+
       MOVE.B   #'B',(A6)+
       MOVE.B   #' ',(A6)+
       CLR.L      D3
                    ****
            CLR.L   D1
            MOVE.B  #%00, D1 ** RECORD SIZE IN D1 FOR IMMEDIATE ADDRESSING
            CLR.L   D6
            ****
       RTS

SIZEISWORD    
       MOVE.B   #'.',(A6)+
       MOVE.B   #'W',(A6)+
       MOVE.B   #' ',(A6)+
                    ****
            CLR.L   D1
            MOVE.B  #%01, D1 ** RECORD SIZE IN D1 FOR IMMEDIATE ADDRESSING
            CLR.L   D6
            ****
       CLR.L      D3
       RTS
                
SIZEISLONG    
       MOVE.B   #'.',(A6)+
       MOVE.B   #'L',(A6)+
       MOVE.B   #' ',(A6)+
       ****
        CLR.L   D1
        MOVE.B  #%10, D1 ** RECORD SIZE IN D1 FOR IMMEDIATE ADDRESSING
        CLR.L   D6
        ****
       CLR.L      D3
       RTS
                
     
BUFFER DC.L 1     
*    INCLUDE 'helpers.x68'
*    END START 
*    END TEST

               

































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
