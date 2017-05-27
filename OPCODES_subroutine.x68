*** D3 - ISOLATED BITS FOR COMPARISONS
*** D5 - CURRENT OPCODE
***
***


START    ORG   $6000                 LEA     $A000,SP        *Load the SP
                 
                 LEA     (A7), A2
                 LEA     jmp_table,A0    *Index into the table
                 LEA     BUFFER, A6      * Load buffer into A6
                 CLR.L   D3              *Zero it
                 * TEST OPCODES
                 ; MOVE.W  #$45D7,D3 * LEA (A7), A2
                 ;MOVE.W  #$4E71,D3 * NOP
                 ; MOVE.W  #$4E75,D3 * RTS
                 ; MOVE.W  #$4EB0,D3 * JSR
                 
                 MOVE.W   #$41D5,D3   ;LEA
                 
                 ;MOVE.W  #$0642,D3   *ADDI.W  #1000,D2
                 
                 MOVE.W  D3,D5
                 MOVE.B  #12,D4          *Shift 12 bits to the right  

           
                 LSR.W   D4,D3       *Move the bits
                 MULU    #6,D3       *Form offset     
                 JSR     0(A0,D3)   *Jump indirect with index
                
    INCLUDE 'definitions.x68'
           
EXIT                 
       SIMHALT   

jmp_table      JMP         code0000
                *ADDI

               JMP         code0001

               JMP         code0010

               JMP         code0011

               JMP         code0100
                           
               JMP         code0101

               JMP         code0110

               JMP         code0111

               JMP         code1000
               
               * DIVU
               * OR

               JMP         code1001

               JMP         code1010

               JMP         code1011

               JMP         code1100

               JMP         code1101

               JMP         code1110

               JMP         code1111


code0000      
               JSR          bits5to8 // RETURNS INTO D5
               CMP.L        #%0110, D3
               BNE          INVALID_OP
               BRA          ADDI  

code0001       STOP        #$2700

code0010       STOP        #$2700

code0011       STOP        #$2700

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
                
                *LEA - if it's not the top codes, it's LEA
                BRA     LEA
ADDI
                JSR     ADDI_BUFFER
                JSR     ADDI_SRC
                JSR     ADDI_DES
                BRA     PRINT_BUFFER
                
ADDI_SRC                        
                MOVE.B  #'#', (A6)+
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
               
               JSR      bits14to16
               CMP      #%100,D3  ** IMMEDIATE
               BEQ      INVALID_EA
               CMP      #%010,D3 ** COMPLICATED
               BEQ      INVALID_EA
               CMP      #%011,D3 ** COMPLICATED
               BEQ      INVALID_EA
               
               JSR      bits11to13 ** grab bits to jump with
               LEA     jmp_mode,A0    *Index into the table
               MULU    #6,D3       *Form offset     
               JSR     0(A0,D3)   *Jump indirect with index
               RTS
               
                           
ADDI_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   #'D', (A6)+  
               MOVE.B   #'D', (A6)+
               MOVE.B   #'I', (A6)+
               MOVE.B   #'.', (A6)+
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
               BRA      PRINT_BUFFER
               
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
            
            
             JSR      bits11to13 ** grab mode bits to jump with
             LEA     jmp_mode,A0    *Index into the table
             MULU    #6,D3       *Form offset     
             JSR     0(A0,D3)   *Jump indirect with index
             
             CLR     D3
             JSR     bits14to16
             JSR     insert_num
             
             MOVE.B     #',', (A6)+
             MOVE.B     #' ', (A6)+

             RTS
             
LEA_DEST    
                LEA     jmp_mode,A0    * LOAD MODE TABLE FOR JUMPING             
                MOVE.W  #%001,D3    * LEA CAN ONLY HAVE AN AS DESTINATION
                MULU    #6,D3       *Form offset     
                JSR     0(A0,D3)   *Jump indirect with index
                
                JSR     bits5to7
                JSR     insert_num
                
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
                MOVE.B  '0',(A6)+      ;Put ASCII value in buffer.
                BRA     FINISHER
                
ONE             CMP     #%001,D3       ;1
                BNE     TWO 
                MOVE.B  '1',(A6)+
                BRA     FINISHER

                
TWO             CMP     #%010,D3        ;2
                BNE     THREE
                MOVE.B  '2',(A6)+
                BRA     FINISHER
                
THREE           CMP     #%011,D3        ;3
                BNE     FOUR
                MOVE.B  '3',(A6)+
                BRA     FINISHER
                
FOUR            CMP     #%100,D3        ;4
                BNE     FIVE
                MOVE.B  '4',(A6)+
                BRA     FINISHER
                
FIVE            CMP     #%101,D3        ;5
                BNE     SIX
                MOVE.B  '5',(A6)+
                BRA     FINISHER
                
SIX             CMP     #%110,D3        ;6
                BNE     SEVEN
                MOVE.B  '6',(A6)+
                BRA     FINISHER
                
SEVEN           CMP     #%111,D3        ;7
                MOVE.B  '7',(A6)+
                
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
                MOVE.B  #')',(A6)+                
                RTS
        
               
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
               
** DN       
MODE000                                    
                MOVE.B  #'D',(A6)+     

** AN
MODE001         
                JSR ADDRESS_BUFFER  
                RTS      

 ** (AN)
MODE010         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+  
                MOVE.B  D3,D4
                RTS      

** (AN)+ 
MODE011         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+
                MOVE.B  D3,D4
                RTS        

 ** -(AN)
MODE100         
                MOVE.B  #'-', (A6)+
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+
                MOVE.B  D3,D4
                
**INVALID               
MODE101         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+ 
                
**INVALID
MODE110         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+  

** ABSOLUTE AND IMMEDIATE            
MODE111         
                *TO DO CHECK IF ABSOLUTE OR IMMEDIATE
               JSR ABSOLUTE_BUFFER  
               RTS            
                                        
ADDRESS_BUFFER
                MOVE.B  #'A',(A6)+ 
                ** TO DO : FIGURE OUT HOW TO PRINT THE REGISTER NUMBER
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
               
ABSOLUTE_WORD_BUFFER
                       *** TODO: SHOULD START AT THE CURRENT LOCATION AFTER OPCODE AND READ IN ADDRESS TO PRINT
                       *** TODO: PROPERLY INCREMENT CURRENT ADDRESS
                       MOVE.B #'F', (A6)+ 
                       MOVE.B #'F', (A6)+ 
                       MOVE.B #'F', (A6)+ 
                       MOVE.B #'F', (A6)+   
ABSOLUTE_LONG_BUFFER       
                       *** TODO: SHOULD START AT THE CURRENT LOCATION AFTER OPCODE AND READ IN ADDRESS TO PRINT
                       *** TODO: PROPERLY INCREMENT CURRENT ADDRESS
                       MOVE.B #'G', (A6)+ 
                       MOVE.B #'G', (A6)+ 
                       MOVE.B #'G', (A6)+ 
                       MOVE.B #'G', (A6)+ 
                                                    

PRINT_BUFFER    
                * TOD0: FIGURE OUT WHY IT HANGS AFTER TRAP 15         
               LEA      BUFFER, A1
               MOVE.W   #14,D0
               TRAP     #15
               BRA EXIT
               
               

INVALID_EA  
                * TODO: IMPLEMENT
                *** CLEAR OUT A6
                ** PUT INVALID MESSAGE INTO A6
                BRA EXIT
INVALID_OP  
                ** TODO: IMPLEMENT
               *** CLEAR OUT A6
                ** PUT INVALID MESSAGE INTO A6
                BRA EXIT             
            
               

code0101       STOP        #$2700

code0110       STOP        #$2700

code0111       STOP        #$2700

code1000       STOP        #$2700

code1001       STOP        #$2700

code1010       STOP        #$2700

code1011       BRA        code1011

  

code1100       STOP        #$2700

code1101       STOP        #$2700

code1110       STOP        #$2700

code1111       STOP        #$2700

NOP                 LEA     NOP_disp,A1          
                    MOVE.B  #14,D0
                    TRAP    #15
                    BRA     EXIT
                 
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

                
     
BUFFER DC.B '     ',0           

    END START 











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
