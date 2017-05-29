START  ORG $1000
*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
*Displays welcome message
                LEA     welcome_msg, A1
                MOVE.B  #13,D0
                TRAP    #15
*-----------------------------------------------------------
*Gets the starting and ending inputs
*First, the start address prompt and location
IO_StartLoop    LEA     location_start_msg,A1
                MOVE.B  #14,D0
                TRAP    #15

*Gets the user input for start locatioin                
                LEA     input_buffer,A1
                MOVE.B  #2,D0
                TRAP    #15
                
*Converts that ASCII input into hexadecimal
                CLR.L   D0
                CLR.L   D1
                
                JSR     sub_AsToHeLoop          
                MOVEA.L  D1, A2
                MOVEA.L  A2,A4
                ADD.L    #$2,A4
                
                LEA     linebreak,A1            *appends line at the end of the user input
                MOVE.B  #14,D0
                TRAP    #15
                
                
                JSR    sub_StartReadingData    *checks the validity of the start address
                CMP.B  #1, D7                  *checks of subroutine returned 1, if so then invalid
                BEQ    IO_StartLoop            *starts loop over due to invalidity
*-----------------------------------------------------------
*Gets the starting and ending inputs
*Second, gets the ending address prompt and location
IO_EndLoop      LEA     location_end_msg,A1
                MOVE.B  #14,D0
                TRAP    #15

*Gets the user input for start locatioin                
                LEA     input_buffer,A1
                MOVE.B  #2,D0
                TRAP    #15
                
*Converts that ASCII input into hexadecimal
                CLR.L   D0
                CLR.L   D1
                
                JSR     sub_AstoHeLoop          
                MOVEA.L D1, A3
                
                LEA     linebreak,A1            *appends line at the end of the user input
                MOVE.B  #14,D0
                TRAP    #15
                
                
                JSR    sub_endReadingData    *checks the validity of the start address
                CMP.B  #1, D7                  *checks of subroutine returned 1, if so then invalid
                BEQ    IO_StartLoop            *starts loop over due to invalidity
*-----------------------------------------------------------
                JSR MAIN_LOOP

*** D3 - ISOLATED BITS FOR COMPARISONS
*** D4 - MODE
*** D5 - CURRENT OPCODE
***
*** 
MAIN_LOOP
                 LEA     jmp_table,A0    *Index into the table
                 LEA     BUFFER, A6      * Load buffer into A6
                 CLR.L   D3              *Zero it
                 
                 ;MOVE.W  (A2), D3

                 * TEST OPCODES
                 ; MOVE.W  #$45D7,D3 * LEA (A7), A2
                 ;MOVE.W  #$4E71,D3 * NOP
                 ; MOVE.W  #$4E75,D3 * RTS
                 ; MOVE.W  #$4EB0,D3 * JSR
                 ; MOVE.W  #$0642,D3   *ADDI.W  #1000,D2
                 ;MOVE.W  #$D4FC,D3   *ADDA.W   #1000, A2
                 ; MOVE.W  #$D5FC,D3   *ADDA.L   #1000, A2
                 ;MOVE.W  #$D64A, D3  * ADD.W A2,D3
                  ; MOVE.W    #$5613, D3    *ADDQ.B #$3, (A3)
                 ; MOVE.W     #$7E70, D3 *MOVEQ
                 ; MOVE.W     #$80C0, D3 *DIVU
                 ; MOVE.W     #$86D9, D3 *DIVU (A1)+,D3                      
                 ; MOVE.W     #$8000, D3 * OR
                  MOVE.W        #$9000, D3 * SUB
                 ; MOVE.W        #$B000, D3 * CMP
                 ; MOVE.W        #$C1C0, D3 * MULS
                 ; MOVE.W        #$C000, D3 * AND
                 ; MOVE.W        #$E0F8, D3  *ASR
                 ; MOVE.W        #$E1E2, D3  *ASL
                 ; MOVE.W        #$E393, D3  *LSL
                 ; MOVE.W        #$E2DC, D3  *LSR
                  ; MOVE.W        #$8E62, D3  *OR.W        -(A2),D7
                      

                 JSR    PRINT_ADDRESS
                 ADD.W   #2,A2 * Can safely increment the current address by a word
                 MOVE.W  D3,D5       * Before manipulating opcode, store in D5 
                 MOVE.B  #12,D4      *Shift 12 bits to the right  
                 LSR.W   D4,D3       *Move the bits
                 MULU    #6,D3       *Form offset     
                 JSR     0(A0,D3)   *Jump indirect with index
                 JSR     PRINT_BUFFER * GOT OPCODE AND EA LINE, PRINT IT
                 
                 ;CMP     A3,A2
                 ;BGT     EXIT
                 ;BRA     MAIN_LOOP
                 
                 BRA      EXIT
                                
    INCLUDE 'definitions.x68'
           
EXIT                 
       SIMHALT   


**TODO: PRINT INVALID OPCODES FOR REMAINING JMPS
jmp_table      JMP         code0000
                *ADDI

               JMP         code0001
               *MOVE
               *MOVEA

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


code0000      
               JSR          bits5to8 // RETURNS INTO D3
               CMP.L        #%0110, D3
               BNE          INVALID_OP
               BRA          ADDI  

code0001      
               JSR   MOVE_B
               *MOVE.B

code0010        
                * MOVE.L
                * MOVEA.L
code0011        
                *MOVEA.W
                *MOVE.W

code0100       
               JSR COPY_OPCODE // Makes a copy of Opcode into d2
                
               *NOP
               AND     #%0000111111111111,D2
               CMP.L   #%000111001110001, D2
               BEQ     NOP
               
               *RTS
               AND     #%0000111111111111,D2
               CMP.L   #%0000111001110101, D2
               BEQ     RTS

               *JSR
               AND     #%0000111111000000,D2
               CMP.L   #%0000111010000000,D2
               BEQ     JSR
               
               * MOVEM
                ** 0 1	0 0  	1 | D | 0	0 1 | S	M	Xn	
              ** AND     #%0000111110000000,D2
               * DATA REGISTER
              ** CMP.L   #%0000100010000000, D2
               ** JSR      MOVEM
               * ADDRESS REGISTER (DECREMENTED)
               ** CMP.L  #%0000110010000000, D2
               ** JSR    MOVEM
                
                ** TO DO: BRANCH IF INVALID OPCODE
                *LEA - if it's not the top codes, it's LEA
                BRA     LEA
code0101      

                BRA   ADDQ

code0110        BRA       INVALID_OP

code0111       
                BRA      MOVEQ

code1000      
                JSR        bits8to10
                CMP        #%011, D3  ** ONLY TIME IT'S DIVU
                BEQ        DIVU
                BRA        OR       ** OTHERWISE OR
                

code1001       
               BRA        SUB
code1010       BRA       INVALID_OP

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
                BEQ     ASR
                
                * ASL
                CMP     #%1110000111,D3
                BEQ     ASL
                
                ** TODO: MASK REGISTERS AND FIND SIZE RIGHT AWAY
                * LSL
                CLR     D4
                MOVE.L  D3,D4
                AND.L   #11110001,D4
                CMP     #%111000111,D4
                BEQ     LSL
                
                * LSR
                CMP     #%1110001011,D3
                BEQ     LSR
                
                * ROL
                
                * ROR

code1111       BRA      INVALID_OP

MOVE_B
               JSR     MOVEB_BUFFER
MOVEB_BUFFER
                NOP              
* ----------------------------------

ADDA    
               JSR     ADDA_BUFFER
               RTS
                
ADDA_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'D', (A6)+  
               MOVE.B   #'D', (A6)+
               MOVE.B   #'A', (A6)+
               JSR      GETSIZE_ADDA
               MOVE.B   #' ', (A6)+
               RTS
               
               
               
*********************************************               
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
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
               
***********************************************        



****************************************************************************************
ADD_SRC

                JSR    bits11to13
                MOVE   D3,D4
                LEA     jmp_mode,A0    *Index into the table
                MULU   #6,D3
                JSR    0(A0,D3)     
                JSR    bits14to16
                JSR    insert_num
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
                MOVE.B  #'#', (A6)+
                MOVE.B  #',', (A6)+
                MOVE.B  #' ', (A6)+
                RTS
                  ** TODO: IMPLEMENT THIS IN EA
                ** Immediate field—Data immediately following the instruction.
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

            
            * CHECK ON REGISTER BITS TO SEE IF NOW ABSOLUTE WORD OR LONG
            JSR      bits14to16 // source register - d4
            CMP      #%100, D3
            BEQ      INVALID_EA
            CMP      #%010, D3
            BEQ      INVALID_EA
            CMP      #%011, D3
            BEQ      INVALID_EA
            

             JSR      bits11to16 // check mode and register, invalid if immediate or 111010, 111011
             CMP      #%111100,D3 // immediate data
             BEQ      INVALID_EA
             CMP      #%111010,D3 // complicated
             BEQ      INVALID_EA
             CMP      #%111011,D3 // complicated
             BEQ      INVALID_EA
   
             JSR      bits11to13 ** grab mode bits to jump with
             MOVE    D3,D4

             LEA     jmp_mode,A0    *Index into the table
             MULU    #6,D3       *Form offset     
             JSR     0(A0,D3)   *Jump indirect with index
 
             MOVE.B     #',', (A6)+
             MOVE.B     #' ', (A6)+

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
               JSR      bits11to13
               MOVE     D3,D4
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index  
               CLR     D3
               JSR     bits14to16
               JSR     insert_num
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
               
               
               
               
               
CMP   
               JSR     CMP_BUFFER
               BRA     PRINT_BUFFER
                
CMP_BUFFER
               MOVE.B   #'C',(A6)+
               MOVE.B   #'M', (A6)+  
               MOVE.B   #'P', (A6)+
               MOVE.B   #'.', (A6)+
               ** TODO: ADD SIZE BASED ON BITS 8 TO 10
               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
               MOVE.B   #' ', (A6)+
               RTS   
               
MULS
                JSR     MULS_BUFFER
                BRA     PRINT_BUFFER

MULS_BUFFER
               MOVE.B   #'M',(A6)+
               MOVE.B   #'U', (A6)+  
               MOVE.B   #'L', (A6)+
               MOVE.B   #'S', (A6)+
               MOVE.B   #' ', (A6)+
               RTS

AND    
               JSR     AND_BUFFER
               BRA     PRINT_BUFFER
                
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

ASR     
                JSR     ASR_BUFFER
                BRA     PRINT_BUFFER

ASR_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'S', (A6)+  
               MOVE.B   #'R', (A6)+
               MOVE.B   #' ', (A6)+
               RTS      

ASL     
                JSR     ASL_BUFFER
                BRA     PRINT_BUFFER

ASL_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'S', (A6)+  
               MOVE.B   #'L', (A6)+
               MOVE.B   #' ', (A6)+
               RTS     

LSL     
                JSR     LSL_BUFFER
                BRA     PRINT_BUFFER

LSL_BUFFER
               MOVE.B   #'L',(A6)+
               MOVE.B   #'S', (A6)+  
               MOVE.B   #'L', (A6)+
               MOVE.B   #' ', (A6)+
               RTS     

LSR     
                JSR     LSR_BUFFER
                BRA     PRINT_BUFFER

LSR_BUFFER
               MOVE.B   #'L',(A6)+
               MOVE.B   #'S', (A6)+  
               MOVE.B   #'R', (A6)+
               MOVE.B   #' ', (A6)+
               RTS       
               
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
                *TO DO CHECK IF ABSOLUTE OR IMMEDIATE
               MOVE.B   #'$', (A6)+  
               JSR      PRINT_DEREF_ADDRESS
               ADD.W    #2, A2
               JSR      PRINT_DEREF_ADDRESS
               ADD.W    #2, A2
               RTS            
                                        
ADDRESS_BUFFER
                MOVE.B  #'A',(A6)+ 
                RTS
               
ABSOLUTE_BUFFER
               CLR      D3
               MOVE.W   D4,D3 // USE D3 FOR COMPARISON
               MOVE.B   '$', (A6)+
               CMP.W    #%000, D3
               BEQ      ABSOLUTE_WORD_BUFFER
               CLR      D3
               MOVE.W   D4,D3 // USE D3 FOR COMPARISON   
               CMP.W    #%001, D3
               BEQ      ABSOLUTE_LONG_BUFFER
               RTS
               
ABSOLUTE_WORD_BUFFER
                       *** TODO: SHOULD START AT THE CURRENT LOCATION AFTER OPCODE AND READ IN ADDRESS TO PRINT
                       *** TODO: PROPERLY INCREMENT CURRENT ADDRESS
                       MOVE.B #'F', (A6)+ 
                       MOVE.B #'F', (A6)+ 
                       MOVE.B #'F', (A6)+ 
                       MOVE.B #'F', (A6)+ 
                       RTS       
                  
ABSOLUTE_LONG_BUFFER       
                       *** TODO: SHOULD START AT THE CURRENT LOCATION AFTER OPCODE AND READ IN ADDRESS TO PRINT
                       *** TODO: PROPERLY INCREMENT CURRENT ADDRESS
                       MOVE.B #'G', (A6)+ 
                       MOVE.B #'G', (A6)+ 
                       MOVE.B #'G', (A6)+ 
                       MOVE.B #'G', (A6)+
                       RTS 

INVALID_EA  
                * TODO: IMPLEMENT
                *** CLEAR OUT A6
                ** PUT INVALID MESSAGE INTO A6
                BRA EXIT
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
                    LEA     RTS_disp,A1          
                    MOVE.B  #14,D0
                    TRAP    #15 
                    BRA     EXIT
JSR      
                    LEA     BUFFER, A6
                    MOVE.B #'J', (A6)+
                    MOVE.B #'S', (A6)+
                    MOVE.B #'R', (A6)+
                    MOVE.B #' ', (A6)+
                    LEA     BUFFER, A1
                    ** BITS 10 - 12 MODE       
                    ** BITS 13 - 16 REGISTER
                    MOVE.B  #14,D0
                    TRAP    #15 
                    BRA     EXIT
                  
MOVEM      
                   
                    ** SIZE SUBROUTINE
                    ** 0 1	0 0  	1 | D | 0	0 1 | S	M	Xn	
                    AND #%0000000001000000,D2 
                    * WORD
                    CMP.L   #%0000000001000000,D2
                    JSR     MOVEM_W 
                    *LONG
                    CMP.L   #%0000000001000000,D2 
                   ** JSR     MOVEM_L
                    MOVE.B  #14,D0
                    TRAP    #15
                    BRA     EXIT 
                    
MOVEM_W 
                     LEA     MOVEM_disp,A1
                    * PRINT MOVEM
                     MOVE.B  #14,D0
                     TRAP    #15
        
                    * PRINT WORD PORTION
                     LEA     size_w, A0
                     MOVE.B  #14,D0
                     TRAP    #15 
        
                     BRA     EXIT 
     
   
COPY_OPCODE 
                     ** HOLDS COPY OF OPCODE TO BE MANIPULATED
                     CLR    D2  
                     MOVE.W D5,D2 
                     RTS  

PRINT_ADDRESS     
                 CLR         D2
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
               CLR      D2
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
 ***************************

GETSIZE_ADDQ
                 
               ** VALID SIZES ARE B (00),W (01) ,L (10)
               
           JSR      bits8to10
           CMP      #%000,D3
           BNE      ADDQ_NOTBYTE
           JSR      SIZEISBYTE
           CLR      D3
           RTS
           
ADDQ_NOTBYTE
           CMP      #%001,D3
           BNE      ADDQ_NOTWORD
           JSR      SIZEISWORD
           CLR      D3
           RTS
           
ADDQ_NOTWORD
           CMP      #%010,D3
           BNE      INVALID_EA
           JSR      SIZEISLONG
           CLR      D3
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
            CLR     D3
            RTS
            
SUB_NOTBYTE 
            CMP     #%001,D3
            BNE     SUB_NOTWORD
            JSR     SIZEISWORD
            MOVE    #1,D6
            CLR     D3
            RTS
            
SUB_NOTWORD
            CMP     #%010,D3
            BNE     SUB_NOTLEFT
            JSR     SIZEISLONG
            MOVE    #1,D6
            CLR     D3
            RTS
            
SUB_NOTLEFT     ;check other direction
            CMP     #%100,D3
            BNE     SUB_NOTRIGHTBYTE
            JSR     SIZEISBYTE
            MOVE    #2,D6
            CLR     D3
            RTS
            
SUB_NOTRIGHTBYTE
            CMP     #%101,D3
            BNE     SUB_NOTRIGHTWORD
            JSR     SIZEISWORD
            MOVE    #2,D6
            CLR     D3
            RTS

SUB_NOTRIGHTWORD
            CMP     #%110,D3
            BNE     INVALID_EA
            JSR     SIZEISLONG
            MOVE    #2,D6
            CLR     D3
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
            CLR     D3
            RTS
            
OR_NOTBYTE 
            CMP     #%001,D3
            BNE     OR_NOTWORD
            JSR     SIZEISWORD
            MOVE    #1,D6
            CLR     D3
            RTS
            
OR_NOTWORD
            CMP     #%010,D3
            BNE     OR_NOTLEFT
            JSR     SIZEISLONG
            MOVE    #1,D6
            CLR     D3
            RTS
            
OR_NOTLEFT     ;check other direction
            CMP     #%100,D3
            BNE     OR_NOTRIGHTBYTE
            JSR     SIZEISBYTE
            MOVE    #2,D6
            CLR     D3
            RTS
            
OR_NOTRIGHTBYTE
            CMP     #%101,D3
            BNE     OR_NOTRIGHTWORD
            JSR     SIZEISWORD
            MOVE    #2,D6
            CLR     D3
            RTS

OR_NOTRIGHTWORD
            CMP     #%110,D3
            BNE     INVALID_EA
            JSR     SIZEISLONG
            MOVE    #2,D6
            CLR     D3
            RTS 

            

                   
****************************

               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN 
                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> 
GETSIZE_ADD
            JSR     bits8to10
            CMP     #%000,D3
            BNE     ADD_NOTBYTE
            JSR     SIZEISBYTE
            MOVE    #1,D6
            CLR     D3
            RTS
        
ADD_NOTBYTE 
            CMP     #%001,D3
            BNE     ADD_NOTWORD
            JSR     SIZEISWORD
            MOVE    #1,D6
            CLR     D3
            RTS
            
ADD_NOTWORD
            CMP     #%010,D3
            BNE     ADD_NOTLEFT
            JSR     SIZEISLONG
            MOVE    #1,D6
            CLR     D3
            RTS
            
ADD_NOTLEFT     ;check other direction
            CMP     #%100,D3
            BNE     ADD_NOTRIGHTBYTE
            JSR     SIZEISBYTE
            MOVE    #2,D6
            CLR     D3
            RTS
            
ADD_NOTRIGHTBYTE
            CMP     #%101,D3
            BNE     ADD_NOTRIGHTWORD
            JSR     SIZEISWORD
            MOVE    #2,D6
            CLR     D3
            RTS

ADD_NOTRIGHTWORD
            CMP     #%110,D3
            BNE     INVALID_EA
            JSR     SIZEISLONG
            MOVE    #2,D6
            CLR     D3
            RTS 
                             
                     
                     
*****************************                  
GETSIZE_ADDI
        JSR     bits8to10
        CMP     #%000,D3
        BNE     ADDI_NOTBYTE
        JSR     SIZEISBYTE
        CLR     D3
        RTS

ADDI_NOTBYTE
        CMP     #%001,D3
        BNE     ADDI_NOTWORD
        JSR     SIZEISWORD
        CLR     D3
        RTS
        
ADDI_NOTWORD
        CMP     #%010,D3
        BNE     INVALID_EA
        JSR     SIZEISLONG
        CLR     D3
        RTS
        
                            
                     
********************************          
                     
                     
********************************                     
GETSIZE_ADDA
        JSR     bits8to10
        CMP     #%011,D3
        BNE     ADDA_NOTWORD
        JSR     SIZEISWORD
        CLR     D3
        RTS
        

        
ADDA_NOTWORD
        CMP     #%111,D3
        BNE     INVALID_EA
        JSR     SIZEISLONG
        CLR     D3
        RTS
**********************************        
    
SIZEISBYTE
       MOVE.B   #'.',(A6)+
       MOVE.B   #'B',(A6)+
       MOVE.B   #' ',(A6)+
       CLR      D3
       RTS

SIZEISWORD    
       MOVE.B   #'.',(A6)+
       MOVE.B   #'W',(A6)+
       MOVE.B   #' ',(A6)+
       CLR      D3
       RTS
                
SIZEISLONG    
       MOVE.B   #'.',(A6)+
       MOVE.B   #'L',(A6)+
       MOVE.B   #' ',(A6)+

       CLR      D3
       RTS
                
     
BUFFER DC.L 1     
    INCLUDE 'helpers.x68'
    END START 


































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
