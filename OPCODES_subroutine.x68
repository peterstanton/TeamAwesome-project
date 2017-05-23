START    ORG   $6000
                 LEA     $A000,SP        *Load the SP
                 LEA     jmp_table,A0    *Index into the table
                 LEA     BUFFER, A6      * Load buffer into A6
                 CLR.L   D3              *Zero it
                 MOVE.W  #$4EB9,D3       *We'll play with it here
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


code0000       STOP        #$2700

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
               
               * MOVEM
                ** 0 1	0 0  	1 | D | 0	0 1 | S	M	Xn	
              ** AND     #%0000111110000000,D2
               * DATA REGISTER
              ** CMP.L   #%0000100010000000, D2
               ** JSR      MOVEM
               * ADDRESS REGISTER (DECREMENTED)
               ** CMP.L  #%0000110010000000, D2
               ** JSR    MOVEM

               *LEA
               JSR      LEA_buffer
               JSR      bits8to10   // 1 1 1
               CMP      #7, D2
               BNE      INVALID
               JSR      bits11to13  // source mode
               JSR      bits14to16  // source address
               JSR      bits5to7    // destination register (will be address)
               JSR      An_buffer
              
LEA_buffer 
               MOVE.W   #'L',(A6)+
               MOVE.W   #'E', (A6)+  
               MOVE.W   #'A', (A6)+
               MOVE.W   #' ', (A6)+
               RTS
        
               
bits5to7
               CLR      D3
               JSR      COPY_OPCODE  // opcode copied to D2
               AND      #%0000111000000000, D2
               ROR.L    #8, D2          // rotate bits so isolated at the end
               ROR.L    #1, D2
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

               
An_buffer
               MOVE.W   #'A',(A6)+
               MOVE.W   D6, (A6)+  ** TODO: TRYING TO MOVE DECIMAL REPRESENTATION
     
               ** TODO: TRYING TO TEST PRINT!
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
