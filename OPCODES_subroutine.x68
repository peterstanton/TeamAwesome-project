*** D3 - ISOLATED BITS FOR COMPARISONS
*** D5 - CURRENT OPCODE
***
***


START    ORG   $6000
                 LEA     $80FC,SP        *Load the SP
                 LEA     jmp_table,A0    *Index into the table
                 LEA     BUFFER, A6      * Load buffer into A6
                 CLR.L   D3              *Zero it
                 MOVE.W  #$43D5,D3       *We'll play with it here
                 MOVE.W  D3,D5
                 MOVE.B  #12,D4          *Shift 12 bits to the right  

           
                 LSR.W   D4,D3       *Move the bits
                 MULU    #6,D3       *Form offset     
                 JSR     0(A0,D3)   *Jump indirect with index
                
    INCLUDE 'definitions.x68'
           
EXIT                 
       SIMHALT   

jmp_table      JMP         code0000

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
               *ADDI
               AND      #%0000011000000000,D2
               CMP.L    #%0000011000000000,D2
               BEQ      ADDI
               JMP      INVALID

code0001       STOP        #$2700

code0010       STOP        #$2700

code0011       STOP        #$2700

code0100       
               JSR COPY_OPCODE // Makes a copy of Opcode into d2
                
               *NOP
               AND     #%0000111111111111,D2
               CMP.L   #%0000111001111001, D2
               BEQ     NOP
               
               *RTS
               AND     #%0000111111111111,D2
               CMP.L   #%0000111001110101, D2
               BEQ     RTS

               *JSR
               AND     #%0000111111000000,D2
               CMP.L   #%0000111010000000,D2
               BEQ     JSR
               
               *CLR
               AND     #%0000111100000000,D2
               CMP.L   #%0000001000000000,D2
               BEQ     CLR
               
               * MOVEM
                ** 0 1	0 0  	1 | D | 0	0 1 | S	M	Xn	
              ** AND     #%0000111110000000,D2
               * DATA REGISTER
              ** CMP.L   #%0000100010000000, D2
               ** JSR      MOVEM
               * ADDRESS REGISTER (DECREMENTED)
               ** CMP.L  #%0000110010000000, D2
               ** JSR    MOVEM
                
                BRA     LEA
               *LEA
              
LEA
               JSR      LEA_BUFFER
               JSR      bits8to10   // 1 1 1
               CMP      #7, D2
               BNE      INVALID
               JSR      LEA_SRC
          
LEA_SRC
            JSR      bits11to13  // source mode - D3
            CMP      #%000, D3
            BEQ      INVALID
            CMP      #%001, D3
            BEQ      INVALID
            CMP      #%011, D3
            BEQ      INVALID
            CMP      #%100, D3
            BEQ      INVALID
            CMP      #%101, D3
            BEQ      INVALID
            CMP      #%110, D3
            BEQ      INVALID
            
            JSR      bits14to16 // source register - d4
            CMP      #%100, D4
            BEQ      INVALID
            CMP      #%010, D4
            BEQ      INVALID
            CMP      #%011, D4
            BEQ      INVALID
            
             LEA     jmp_mode,A0    *Index into the table
             MULU    #6,D3       *Form offset     
             JSR     0(A0,D3)   *Jump indirect with index
             
             MOVE.B     #',', (A6)+
             MOVE.B     #' ', (A6)+
             
             JSR        LEA_DST
             NOP
             
LEA_DST    
             LEA     jmp_mode,A0    *Index into the table
             CLR     D3
             MOVE.W  #%111,D3    ;absolute address
             MULU    #6,D3       *Form offset     
             JSR     0(A0,D3)   *Jump indirect with index
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
                
ADDB
    MOVE.B  #'.',(A6)+
    MOVE.B  #'B',(A6)+


ADDW
    MOVE.B  #'.',(A6)+
    MOVE.B  #'W',(A6)+

ADDL
    MOVE.B  #'.',(A6)+
    MOVE.B  #'L',(A6)+


 
            
MODE000         
                ;MOVE.B  #'(', (A6)+
                MOVE.B  #'D',(A6)+     

MODE001         
                ;MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+        

MODE010         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+  
                RTS      

MODE011         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+        

MODE100         
                MOVE.B  #'-', (A6)+
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+ 
                
MODE101         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+ 

MODE110         
                MOVE.B  #'(', (A6)+
                MOVE.B  #'A',(A6)+              
MODE111         
                ;MOVE.B  #'(', (A6)+   ;We need to find a way to grab immediate data at the end of the command in memory.
                MOVE.B  #'#',(A6)+                
                               
***LOAD_LEA_SRC   
   ***            CMP      #%010, D3
      ***         CMP      #%111, D3
         ***      BNE      INVALID
            ***   JSR      LOAD_ADDRESS
              *** RTS
               

LOAD_LEA_DES
               MOVE.B   ',', (A6)+
               MOVE.B   ' ', (A6)+
               JSR      bits5to7    // destination register (will be address) -D3
               JSR      AN_BUFFER
               JSR      bits14to16  // source REGISTER -D4
               BRA      PRINT_BUFFER
                  
LEA_BUFFER 
               MOVE.B   #'L',(A6)+
               MOVE.B   #'E', (A6)+  
               MOVE.B   #'A', (A6)+
               MOVE.B   #' ', (A6)+
               RTS
        
               
bits5to7
               CLR      D5
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000111000000000, D2
               ROR.L    #8, D2          // rotate bits so isolated at the end
               ROR.L    #1, D2
               MOVE.W   D2,D5 // moving isolated bits into d3
               RTS
bits8to10
               CLR      D6
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000000111000000, D2
               ROR.L    #6, D2          // rotate bits so isolated at the end
               MOVE.W   D2,D6 // moving isolated bits into d3
               RTS               
           
bits11to13
               CLR      D3
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000000000111000, D2
               ROR.L    #3, D2          // rotate bits so isolated at the end
               MOVE.W   D2,D3 // moving isolated bits into d3
               RTS
           
bits14to16
               CLR      D4
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000000000000111, D2
               MOVE.W   D2,D4 // moving isolated bits into d3
               RTS

               
AN_BUFFER
               MOVE.B   #'A',(A6)+
               MOVE.B   D3, (A6)+  ** TODO: TRYING TO MOVE DECIMAL REPRESENTATION
               RTS
               
LEA_AN_PAREN_BUFFER
               MOVE.B   #'(',(A6)+
               MOVE.B   #'A',(A6)+
             **  MOVE.B   D3, (A6)+  ** TODO: TRYING TO MOVE DECIMAL REPRESENTATION
               MOVE.B   #')',(A6)+
               BRA      LOAD_LEA_DES

LEA_ABSOLUTE_BUFFER
               MOVE.B   #'(',(A6)+
               MOVE.B   #'A',(A6)+
               ** MOVE.B   D3, (A6)+  ** TODO: TRYING TO MOVE DECIMAL REPRESENTATION
               MOVE.B   #')',(A6)+
               BRA      LOAD_LEA_DES
               
               
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
               LEA      BUFFER, A1
               MOVE.W   #14,D0
               TRAP     #15
               RTS
               
               

INVALID
                *** CLEAR OUT A6
                ** PUT INVALID MESSAGE INTO A6
                BRA EXIT
                            
            
               

code0101       STOP        #$2700

code0110       STOP        #$2700

code0111       STOP        #$2700

code1000
               JSR COPY_OPCODE // Makes a copy of Opcode into d2
               
                              *DIVU*
               AND     #%0000000011000000,D2
               CMP.L   #%0000000011000000,D2
               BEQ     DIVU
              
                           
               BRA     OR
               *OR
               
               
DIVU
               JSR      DIVU_BUFFER
               ;JSR      bits8to10   // 1 1 1
               ;CMP      #7, D2
               ;BNE      INVALID
               JSR      DIVU_SRC
               
DIVU_SRC
            JSR      bits11to13  // source mode - D3   keep working from here. 
            CMP      #%001, D3
            BEQ      INVALID
            
             LEA     jmp_mode,A0    *Index into the table
             MULU    #6,D3       *Form offset     
             JSR     0(A0,D3)   *Jump indirect with index
             
             MOVE.B     #',', (A6)+
             MOVE.B     #' ', (A6)+
             
             JSR        DIVU_DST
             NOP
             
             
             
DIVU_DST    
            JSR     bits8to10 //check validity 
            CMP     #%001,D3
            BNE     INVALID
                
                
             LEA     jmp_mode,A0    *Index into the table
             CLR     D3
             MOVE.W  #%000,D3
             MULU    #6,D3       *Form offset     
             JSR     0(A0,D3)   *Jump indirect with index
             RTS
     

               
               
DIVU_BUFFER 
               MOVE.B   #'D', (A6)+
               MOVE.B   #'I', (A6)+  
               MOVE.B   #'V', (A6)+
               MOVE.B   #'U', (A6)+
               MOVE.B   #' ', (A6)+
               RTS
               
               
               
ADDI
               JSR      ADDI_BUFFER
               JSR      ADDI_SRC
               
               
ADDI_SRC
            JMP      111        ;Source mode is always immediate
            JSR      bits8to10  ;this is the size. I will need to use this to get the trailing immediate value from memory.
            ;Based on the received size, jump forward and read in more memory of that size, and add it to the buffer.
             
             MOVE.B     #',', (A6)+
             MOVE.B     #' ', (A6)+
             
             JSR        ADDI_DST
             NOP
             
             
ADDI_DST    
            JSR     bits11to13  //check validity 
            CMP     #%001,D3
            BEQ     INVALID
                
                
             LEA     jmp_mode,A0    *Index into the table
             ;CLR     D3
             ;MOVE.W  #%000,D3  
             MULU    #6,D3       *Form offset     
             JSR     0(A0,D3)   *Jump indirect with index
             RTS               
               
               
ADDI_BUFFER 
               MOVE.B   #'A', (A6)+
               MOVE.B   #'D', (A6)+  
               MOVE.B   #'D', (A6)+
               MOVE.B   #'I', (A6)+
               MOVE.B   #' ', (A6)+
               RTS
               
CLR
               JSR      bits5to7   // 0 0 1
               CMP      #1, D2
               BNE      INVALID
               JSR      CLR_BUFFER
               JSR     bits8to10
             ;size is now a 3 bit value in D3. Based on that, go to ADDB, ADDW, or ADDL
             CMP    #0,D3
             BEQ    ADDB
             CMP    #1,D3
             BEQ    ADDW
             CMP    #2,D3
             BEQ    ADDL
             JSR      CLR_DEST              
               
CLR_DST    

             LEA     jmp_mode,A0    *Index into the table             
             CLR     D3
             JSR     bits11to13  ;get destinatiom mode bits                          
             ;MOVE.W  #%111,D3    ;absolute address
             MULU    #6,D3       *Form offset     
             JSR     0(A0,D3)   *Jump indirect with index
             RTS
     
             
CLR_BUFFER 
               MOVE.B   #'C', (A6)+
               MOVE.B   #'L', (A6)+  
               MOVE.B   #'R', (A6)+
               MOVE.B   #' ', (A6)+
               RTS
              


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


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
