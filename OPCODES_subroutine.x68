START    ORG   $6000
               
          
                 LEA     $A000,SP        *Load the SP
                 LEA     jmp_table,A0    *Index into the table
                 CLR.L   D3              *Zero it
                 MOVE.W  #$4E75,D3       *We'll play with it here
                 MOVE.W  D3,D5
                 MOVE.B  #12,D4          *Shift 12 bits to the right  

           
                 LSR.W   D4,D3       *Move the bits
                 MULU    #6,D3       *Form offset     
                 JSR     0(A0,D3)   *Jump indirect with index

                 
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
                *NOP
                MOVE.W  D5,D2
                AND     #%0000111111111111,D2
                CMP.L   #%0000111001111001, D2
                BEQ     NOP
               
               *RTS
               MOVE.W  D5,D2
               AND     #%0000111111111111,D2
               CMP.L   #%0000111001110101, D2
               BEQ     RTS

               *JSR
               MOVE.W  D5,D2
               AND     #%0000111111000000,D2
               CMP.L   #%0000111010000000, D2
               BEQ     JSR
               
               *MOVEM
               *LEA
               
               

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
                    MOVE.B  #13,D0
                    TRAP    #15
                    
RTS      
                    LEA     CLR_disp,A1          
                    MOVE.B  #13,D0
                    TRAP    #15 

JSR      
                    LEA     JSR_disp,A1          
                    MOVE.B  #13,D0
                    TRAP    #15 
    INCLUDE 'definitions.x68'
     


    END START 



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
