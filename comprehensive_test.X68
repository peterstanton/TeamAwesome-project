*------------------------------------------------------------
* Title      : Disassembler Test
* Written by : rishabh
* Date       :
* Description: Comprehensive test input for the disassembler.
*------------------------------------------------------------
    ORG    $7000
THETOP    
    BCC     ROCKBOTTOM
    BCC     GOINUP
    BGT     THETOP
    BLE     GOINDOWN
GOINUP    
    MOVE.B  D0,D1
    MOVE.B  (A3),(A4)+
    MOVE.B  (A4)+,-(A5)
    MOVE.B  -(A5),$6000
    MOVE.B  $6000,$7000
    MOVE.B  $7000,$8000
    MOVE.B  $8000,$7000
    MOVE.B  $8000,$9000
    MOVE.B  #$70,$4000
    MOVE.B  #$70,$A000
    
    
STUFF   DC.B    'AKSJKALSJAAKLSJALKAJSALKJASALKSJAL D8',0
    
    MOVE.W  D0,D1
    MOVE.W  D1,A2 
    MOVE.W  A2,(A3)
    MOVE.W  (A3),(A4)+ 
    MOVE.W  (A4)+,-(A5) 
    MOVE.W  -(A5),$6000 
    MOVE.W  $6000,$7000
    MOVE.W  $7000,$8000
    MOVE.W  $8000,$7000
    MOVE.W  $8000,$9000 
    MOVE.W  #$70,$4000
    MOVE.W  #$70,$A000
    MOVE.W  #$7000,$4000
    MOVE.W  #$7000,$A000
    
    MOVE.L  D0,D1 
    MOVE.L  D1,A2 
    MOVE.L  A2,(A3)
    MOVE.L  (A3),(A4)+
    MOVE.L  (A4)+,-(A5)
    MOVE.L  -(A5),$6000
    MOVE.L  $6000,$7000
    MOVE.L  $7000,$8000             
    MOVE.L  $8000,$7000            
    MOVE.L  $8000,$9000             
    MOVE.L  #$70,$4000              
    MOVE.L  #$70,$A000              
    MOVE.L  #$7000,$4000            
    MOVE.L  #$7000,$A000            
    MOVE.L  #$70000000,$4000        
    MOVE.L  #$70000000,$A000        
    
    MOVEA.W  D0,A0                  
    MOVEA.W  A0,A1                  
    MOVEA.W  (A1),A2               
    MOVEA.W  (A2)+,A3              
    MOVEA.W  -(A3),A4              
    MOVEA.W  $4000,A5               
    MOVEA.W  $A000,A6              
    MOVEA.W  #$70,A7                
    MOVEA.W  #$7000,A0             
    
    MOVEA.L  D0,A0                 
    MOVEA.L  A0,A1                 
    MOVEA.L  (A1),A2               
    MOVEA.L  (A2)+,A3              
    MOVEA.L  -(A3),A4               
    MOVEA.L  $4000,A5               
    MOVEA.L  $A000,A6              
    MOVEA.L  #$70,A7               
    MOVEA.L  #$7000,A0             
    MOVEA.L  #$70000000,A1         
    
    MOVEQ  #$70,D7                 
    
    MOVEM.L  (A3),D0/D2/D4/D6/A1/A3/A5/A7            
    MOVEM.L  (A4)+,D0/D2/D4/D6/A1/A3/A5/A7          
    MOVEM.L  $6000,D0/D2/D4/D6/A1/A3/A5/A7          
    MOVEM.L  $8000,D0/D2/D4/D6/A1/A3/A5/A7          
    MOVEM.L  (SP)+,D0-D7/A0-A7                       
    
    MOVEM.L  A0/A2/A4/A6/D1/D3/D5/D7,(A3)           
    MOVEM.L  A0/A2/A4/A6/D1/D3/D5/D7,-(A5)           
    MOVEM.L  A0/A2/A4/A6/D1/D3/D5/D7,$6000          
    MOVEM.L  A0/A2/A4/A6/D1/D3/D5/D7,$8000          
    MOVEM.L  A7-A0/D7-D0,-(SP)                       
    
    MOVEM.W  (A3),D0/D2/D4/D6/A1/A3/A5/A7            
    MOVEM.W  (A4)+,D0/D2/D4/D6/A1/A3/A5/A7          
    MOVEM.W  $6000,D0/D2/D4/D6/A1/A3/A5/A7           
    MOVEM.W  $8000,D0/D2/D4/D6/A1/A3/A5/A7           
    MOVEM.W  (SP)+,D0-D7/A0-A7                      
    
    MOVEM.W  A0/A2/A4/A6/D1/D3/D5/D7,(A3)            
    MOVEM.W  A0/A2/A4/A6/D1/D3/D5/D7,-(A5)           
    MOVEM.W  A0/A2/A4/A6/D1/D3/D5/D7,$6000           
    MOVEM.W  A0/A2/A4/A6/D1/D3/D5/D7,$8000           
    MOVEM.W  A7-A0/D7-D0,-(SP)                       
    
    ADD.B  D0,D0                 
    ADD.B  (A1),D2                
    ADD.B  (A2)+,D3              
    ADD.B  -(A3),D4               
    ADD.B  $4000,D5              
    ADD.B  $A000,D6               
    ADD.B  #$70,D7               
    
    ADD.B  D0,D1                 
    ADD.B  D2,(A3)                
    ADD.B  D3,(A4)+               
    ADD.B  D4,-(A5)               
    ADD.B  D5,$6000              
    ADD.B  D6,$8000              
    
    ADD.W  D0,D0                 
    ADD.W  A0,D1                 
    ADD.W  (A1),D2                
    ADD.W  (A2)+,D3               
    ADD.W  -(A3),D4               
    ADD.W  $4000,D5               
    ADD.W  $A000,D6               
    ADD.W  #$70,D7               
    ADD.W  #$7000,D0              
    
    ADD.W  D0,D1                  
    ADD.W  D1,A2                 
    ADD.W  D2,(A3)               
    ADD.W  D3,(A4)+               
    ADD.W  D4,-(A5)              
    ADD.W  D5,$6000              
    ADD.W  D6,$8000              
    
    ADD.L  D0,D0                  
    ADD.L  A0,D1                 
    ADD.L  (A1),D2               
    ADD.L  (A2)+,D3               
    ADD.L  -(A3),D4              
    ADD.L  $4000,D5              
    ADD.L  $A000,D6              
    ADD.L  #$70,D7                
    ADD.L  #$7000,D0              
    ADD.L  #$70000000,D1         
    
    ADD.L  D0,D1                 
    ADD.L  D1,A2                  
    ADD.L  D2,(A3)               
    ADD.L  D3,(A4)+              
    ADD.L  D4,-(A5)              
    ADD.L  D5,$6000              
    ADD.L  D6,$8000              
    
    ADDA.W  D0,A0                
    ADDA.W  A0,A1                 
    ADDA.W  (A1),A2               
    ADDA.W  (A2)+,A3             
    ADDA.W  -(A3),A4              
    ADDA.W  $4000,A5             
    ADDA.W  $A000,A6             
    ADDA.W  #$70,A7              
    ADDA.W  #$7000,A0             
    
    ADDA.L  D0,A0                 
    ADDA.L  A0,A1                
    ADDA.L  (A1),A2              
    ADDA.L  (A2)+,A3              
    ADDA.L  -(A3),A4              
    ADDA.L  $4000,A5             
    ADDA.L  $A000,A6              
    ADDA.L  #$70,A7               
    ADDA.L  #$7000,A0            
    ADDA.L  #$70000000,A1         
    
    ADDI.B  #$70,D1               
    ADDI.B  #$70,(A3)              
    ADDI.B  #$70,(A4)+             
    ADDI.B  #$70,-(A5)             
    ADDI.B  #$70,$6000             
    ADDI.B  #$70,$8000             
    
    ADDI.W  #$70,D1                
    ADDI.W  #$70,(A3)              
    ADDI.W  #$7000,(A4)+          
    ADDI.W  #$70,-(A5)             
    ADDI.W  #$7000,$6000          
    ADDI.W  #$70,$8000             
    
    ADDI.L  #$70,D1                
    ADDI.L  #$70000000,(A3)        
    ADDI.L  #$70,(A4)+             
    ADDI.L  #$7000,-(A5)          
    ADDI.L  #$70000000,$6000       
    ADDI.L  #$70,$8000         

    ADDQ.B  #$1,D1                        
    ADDQ.B  #$3,(A3)              
    ADDQ.B  #$4,(A4)+             
    ADDQ.B  #$5,-(A5)              
    ADDQ.B  #$6,$6000              
    ADDQ.B  #$7,$8000             
    ADDQ.B  #$8,$A000 

    ADDQ.W  #$1,D1    
    ADDQ.W  #$7,D3             
    ADDQ.W  #$3,A2                
    ADDQ.W  #$5,(A3)              
    ADDQ.W  #$7,(A4)+             
    ADDQ.W  #$8,-(A5)              
    ADDQ.W  #$6,$6000              
    ADDQ.W  #$7,$8000             
    ADDQ.W  #$8,$A000   
    
    ADDQ.L  #$1,D1                
    ADDQ.L  #$2,A2                
    ADDQ.L  #$3,(A3)              
    ADDQ.L  #$4,(A4)+             
    ADDQ.L  #$5,-(A5)              
    ADDQ.L  #$6,$6000              
    ADDQ.L  #$7,$8000             
    ADDQ.L  #$8,$A000       

    SUB.B  D0,D0                 
    SUB.B  (A1),D2                
    SUB.B  (A2)+,D3              
    SUB.B  -(A3),D4               
    SUB.B  $4000,D5              
    SUB.B  $A000,D6               
*    SUB.B  #$70,D7            Translates to SUBI which is not required.   
    
    SUB.B  D0,D1                 
    SUB.B  D2,(A3)                
    SUB.B  D3,(A4)+               
    SUB.B  D4,-(A5)               
    SUB.B  D5,$6000              
    SUB.B  D6,$8000              
    
    SUB.W  D0,D0                 
    SUB.W  A0,D1                 
    SUB.W  (A1),D2                
    SUB.W  (A2)+,D3               
    SUB.W  -(A3),D4               
    SUB.W  $4000,D5               
    SUB.W  $A000,D6               
*    SUB.W  #$70,D7           Translates to SUBI which is not required.    
*    SUB.W  #$7000,D0         Translates to SUBI which is not required.     
    
    SUB.W  D0,D1                  
*    SUB.W  D1,A2             Translates to SUBA which is not required.    
    SUB.W  D2,(A3)               
    SUB.W  D3,(A4)+               
    SUB.W  D4,-(A5)              
    SUB.W  D5,$6000              
    SUB.W  D6,$8000              
    
    SUB.L  D0,D0                  
    SUB.L  A0,D1                 
    SUB.L  (A1),D2               
    SUB.L  (A2)+,D3               
    SUB.L  -(A3),D4              
    SUB.L  $4000,D5              
    SUB.L  $A000,D6              
*    SUB.L  #$70,D7          Translates to SUBI which is not required.      
*    SUB.L  #$7000,D0        Translates to SUBI which is not required.      
*    SUB.L  #$80000000,D1    Translates to SUBI which is not required.    
    
    SUB.L  D0,D1                 
*    SUB.L  D1,A2            Translates to SUBA which is not required.       
    SUB.L  D2,(A3)               
    SUB.L  D3,(A4)+              
    SUB.L  D4,-(A5)              
    SUB.L  D5,$6000              
    SUB.L  D6,$8000    

    MULS  D0,D0                                 
    MULS  (A1),D2               
    MULS  (A2)+,D3               
    MULS  -(A3),D4              
    MULS  $4000,D5              
    MULS  $A000,D6              
    MULS  #$70,D7                
    MULS  #$7000,D0          

    DIVU  D0,D0                                 
    DIVU  (A1),D2               
    DIVU  (A2)+,D3               
    DIVU  -(A3),D4              
    DIVU  $4000,D5              
    DIVU  $A000,D6              
    DIVU  #$70,D7                
    DIVU  #$7000,D0   
                           
    LEA (A1),A2                            
    LEA $4000,A5               
    LEA $A000,A6         
    
    CLR.B  D1                         
    CLR.B  (A3)              
    CLR.B  (A4)+             
    CLR.B  -(A5)              
    CLR.B  $6000              
    CLR.B  $8000             
    CLR.B  $A000

    CLR.W  D1                         
    CLR.W  (A3)              
    CLR.W  (A4)+             
    CLR.W  -(A5)              
    CLR.W  $6000              
    CLR.W  $8000             
    CLR.W  $A000     
    
    CLR.L  D1                         
    CLR.L  (A3)              
    CLR.L  (A4)+             
    CLR.L  -(A5)              
    CLR.L  $6000              
    CLR.L  $8000             
    CLR.L  $A000
    
    AND.B  D0,D0                 
    AND.B  (A1),D2                
    AND.B  (A2)+,D3              
    AND.B  -(A3),D4               
    AND.B  $4000,D5              
    AND.B  $A000,D6               
    AND.B  #$70,D7               
    
    AND.B  D0,D1                 
    AND.B  D2,(A3)                
    AND.B  D3,(A4)+               
    AND.B  D4,-(A5)               
    AND.B  D5,$6000              
    AND.B  D6,$8000              
    
    AND.W  D0,D0                                 
    AND.W  (A1),D2                
    AND.W  (A2)+,D3               
    AND.W  -(A3),D4               
    AND.W  $4000,D5               
    AND.W  $A000,D6               
    AND.W  #$70,D7               
    AND.W  #$7000,D0              
    
    AND.W  D0,D1                                 
    AND.W  D2,(A3)               
    AND.W  D3,(A4)+               
    AND.W  D4,-(A5)              
    AND.W  D5,$6000              
    AND.W  D6,$8000              
    
    AND.L  D0,D0                                
    AND.L  (A1),D2               
    AND.L  (A2)+,D3               
    AND.L  -(A3),D4              
    AND.L  $4000,D5              
    AND.L  $A000,D6              
    AND.L  #$70,D7                
    AND.L  #$7000,D0              
    AND.L  #$70000000,D1         
    
    AND.L  D0,D1                                  
    AND.L  D2,(A3)               
    AND.L  D3,(A4)+              
    AND.L  D4,-(A5)              
    AND.L  D5,$6000              
    AND.L  D6,$8000
    
    OR.B  D0,D0                 
    OR.B  (A1),D2                
    OR.B  (A2)+,D3              
    OR.B  -(A3),D4               
    OR.B  $4000,D5              
    OR.B  $A000,D6               
    OR.B  #$70,D7               
    
    OR.B  D0,D1                 
    OR.B  D2,(A3)                
    OR.B  D3,(A4)+               
    OR.B  D4,-(A5)               
    OR.B  D5,$6000              
    OR.B  D6,$8000              
    
    OR.W  D0,D0                                
    OR.W  (A1),D2                
    OR.W  (A2)+,D3               
    OR.W  -(A3),D4               
    OR.W  $4000,D5               
    OR.W  $A000,D6               
    OR.W  #$70,D7               
    OR.W  #$7000,D0              
    
    OR.W  D0,D1                              
    OR.W  D2,(A3)               
    OR.W  D3,(A4)+               
    OR.W  D4,-(A5)              
    OR.W  D5,$6000              
    OR.W  D6,$8000              
    
    OR.L  D0,D0                                  
    OR.L  (A1),D2               
    OR.L  (A2)+,D3               
    OR.L  -(A3),D4              
    OR.L  $4000,D5              
    OR.L  $A000,D6              
    OR.L  #$70,D7                
    OR.L  #$7000,D0              
    OR.L  #$70000000,D1         
    
    OR.L  D0,D1                             
    OR.L  D2,(A3)               
    OR.L  D3,(A4)+              
    OR.L  D4,-(A5)              
    OR.L  D5,$6000              
    OR.L  D6,$8000
    
    CMP.B  D0,D0                 
    CMP.B  (A1),D2                
    CMP.B  (A2)+,D3              
    CMP.B  -(A3),D4               
    CMP.B  $4000,D5              
    CMP.B  $A000,D6               
    CMP.B  #$70,D7                         
    
    CMP.W  D0,D0                 
    CMP.W  A0,D1                 
    CMP.W  (A1),D2                
    CMP.W  (A2)+,D3               
    CMP.W  -(A3),D4               
    CMP.W  $4000,D5               
    CMP.W  $A000,D6               
    CMP.W  #$70,D7               
    CMP.W  #$7000,D0                        
    
    CMP.L  D0,D0                  
    CMP.L  A0,D1                 
    CMP.L  (A1),D2               
    CMP.L  (A2)+,D3               
    CMP.L  -(A3),D4              
    CMP.L  $4000,D5              
    CMP.L  $A000,D6              
    CMP.L  #$70,D7                
    CMP.L  #$7000,D0              
    CMP.L  #$70000000,D1              
    
    ASL     (A0)
    ASR     (A1)+
    ASL     -(A2)
    ASR     $4000
    ASL     $A000
    
    ASL.B   #$7,D0
    ASL.W   #$8,D1
    ASL.L   D3,D2
    
    LSL     (A3)
    LSR     (A4)+
    LSL     -(A5)
    LSR     $4000
    LSL     $A000
    
    LSL.B   #$7,D0
    LSL.W   #$8,D1
    LSL.L   D5,D1
    
    ROL     (A6)
    ROR     (A0)+
    ROL     -(A1)
    ROR     $4000
    ROL     $A000
    
    ROL.B    #$7,D0
    ROL.W    #$8,D1
    ROL.L    D7,D1
    
    BCC     ROCKBOTTOM
    BGT     THETOP
    BLE     GOINUP
    
GOINDOWN
    
    JSR     ROCKBOTTOM
    JSR     $A000
    JSR     $4000
    
    RTS
ROCKBOTTOM
    *MOVE.B  #9,D8
    *TRAP    #15
    
    SIMHALT             
    END    THETOP



















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
