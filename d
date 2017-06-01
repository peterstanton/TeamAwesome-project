[1mdiff --git a/OP_EA.X68 b/OP_EA.X68[m
[1mindex c595519..0a5e4be 100644[m
[1m--- a/OP_EA.X68[m
[1m+++ b/OP_EA.X68[m
[36m@@ -1,18 +1,15 @@[m
 [m
 TEST  ORG $1000                                                 [m
[31m-    MOVEQ       #127,D1[m
[31m-    MOVEQ       #0,D4[m
[31m-    MOVEQ       #1,D7[m
[31m-    MOVEQ       #-127,D2[m
[31m-    MOVEQ       #-1,D2[m
[31m-    MOVEQ       #7,D2[m
[31m-    MOVEQ       #2,D5[m
[31m-    MOVEQ       #5,D3[m
[31m-    MOVEQ       #1,D1[m
[31m-    MOVEQ       #5,D3[m
[31m-    MOVEQ       #0,D6[m
[31m-    MOVEQ       #3,D1[m
[31m-     [m
[32m+[m[41m   [m
[32m+[m[32m    ADDA.W  D0,A0[m[41m                [m
[32m+[m[32m    ADDA.W  A0,A1[m[41m                 [m
[32m+[m[32m    ADDA.W  (A1),A2[m[41m               [m
[32m+[m[32m    ADDA.W  (A2)+,A3[m[41m             [m
[32m+[m[32m    ADDA.W  -(A3),A4[m[41m              [m
[32m+[m[32m    ADDA.W  $4000,A5[m[41m             [m
[32m+[m[32m    ADDA.W  $A000,A6[m[41m             [m
[32m+[m[32m    ADDA.W  #$70,A7[m[41m              [m
[32m+[m[32m    ADDA.W  #$7000,A0[m[41m         [m
 [m
 START  ORG $6000[m
                MOVEA.L #$1000,A2 ** TEST START ADDRESS[m
[36m@@ -345,9 +342,38 @@[m [mADDA_BUFFER[m
                MOVE.B   #'D', (A6)+[m
                MOVE.B   #'A', (A6)+[m
                JSR      GETSIZE_ADDA[m
[32m+[m[41m     [m
[32m+[m[41m               [m
[32m+[m[32m               ;Okay, the directionality bit in D6 should determine which order we should process bits in?[m[41m[m
[32m+[m[32m               JSR      ADDA_SRC[m[41m[m
[32m+[m[32m               MOVE.B   #',', (A6)+[m[41m[m
                MOVE.B   #' ', (A6)+[m
[32m+[m[32m               JSR      ADDA_DEST[m[41m[m
                RTS[m
[31m-           [m
[32m+[m[41m             [m
[32m+[m[32mADDA_SRC[m[41m[m
[32m+[m[32m                CLR.L   D7[m[41m[m
[32m+[m[32m                JSR     bits14to16[m[41m[m
[32m+[m[32m                MOVE.B  D3,D7 ** need to know if immediate or absolute[m[41m[m
[32m+[m[32m                JSR     bits11to13  ** mode to jump with[m[41m [m
[32m+[m[32m                MOVE.B  D3,D4[m[41m[m
[32m+[m[32m                LEA     jmp_mode,A0  *Index into the table[m[41m[m
[32m+[m[32m                MULU    #6,D3[m[41m[m
[32m+[m[32m                JSR     0(A0,D3)[m[41m [m
[32m+[m[32m                JSR     bits14to16 ** register number if not absolute or immediate[m[41m[m
[32m+[m[32m                CMP.B   #$FF,D7[m[41m[m
[32m+[m[32m                BNE     NUM_INSERT[m[41m    [m
[32m+[m[32m                RTS[m[41m[m
[32m+[m[32mADDA_DEST[m[41m[m
[32m+[m[32m                MOVE.W #%001,D3     ;Can only have a ADDRESS register.[m[41m[m
[32m+[m[32m                MOVE.W   D3,D4[m[41m[m
[32m+[m[32m                LEA     jmp_mode,A0    *Index into the table[m[41m[m
[32m+[m[32m                MULU    #6,D3       *Form offset[m[41m     [m
[32m+[m[32m                JSR     0(A0,D3)   *Jump indirect with index[m[41m[m
[32m+[m[32m                JSR     bits5to7[m[41m[m
[32m+[m[32m                JSR     insert_num[m[41m[m
[32m+[m[32m                RTS[m[41m[m
[32m+[m[41m[m
 *********************************************      [m
 MOVEA_W[m
         JSR     MOVE_BUFFER[m
[36m@@ -1103,24 +1129,64 @@[m [mCMP_BUFFER[m
 ************************************************               [m
               [m
 ************************************************               [m
[31m-              [m
[32m+[m[32m*ADD[m[41m    [m
[32m+[m[32m*               JSR     ADD_BUFFER[m[41m[m
[32m+[m[32m*               RTS[m[41m[m
[32m+[m[32m*[m[41m                [m
[32m+[m[32m*ADD_BUFFER[m[41m[m
[32m+[m[32m*               MOVE.B   #'A',(A6)+[m[41m[m
[32m+[m[32m*               MOVE.B   #'D', (A6)+[m[41m  [m
[32m+[m[32m*               MOVE.B   #'D', (A6)+[m[41m[m
[32m+[m[32m*               JSR      GETSIZE_ADD[m[41m[m
[32m+[m[32m*[m[41m               [m
[32m+[m[32m*               ;Okay, the directionality bit in D6 should determine which order we should process bits in?[m[41m[m
[32m+[m[32m*[m[41m               [m
[32m+[m[32m*               CMP      #1,D6[m[41m[m
[32m+[m[32m*               BNE      ADD_DIRECTION_REVERSED[m[41m[m
[32m+[m[32m*               JSR      ADD_SRC[m[41m[m
[32m+[m[32m*               MOVE.B   #',', (A6)+[m[41m[m
[32m+[m[32m*               MOVE.B   #' ', (A6)+[m[41m[m
[32m+[m[32m*               JSR      ADD_DEST[m[41m[m
[32m+[m[32m*               RTS[m[41m[m
[32m+[m[32m*[m[41m               [m
[32m+[m[32m*[m[41m               [m
[32m+[m[32m*ADD_DIRECTION_REVERSED[m[41m[m
[32m+[m[32m*               CLR.L      D6[m[41m[m
[32m+[m[32m*               JSR      ADD_DEST[m[41m[m
[32m+[m[32m*               MOVE.B   #',', (A6)+[m[41m[m
[32m+[m[32m*               MOVE.B   #' ', (A6)+[m[41m[m
[32m+[m[32m*               JSR      ADD_SRC[m[41m      [m
[32m+[m[32m*               RTS[m[41m       [m
[32m+[m[32m*               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN[m[41m [m
[32m+[m[32m*                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA>[m[41m [m
[32m+[m[32m*[m[41m               [m
[32m+[m[32m*ADD_SRC[m[41m[m
[32m+[m[32m*                CLR.L   D7[m[41m[m
[32m+[m[32m*                JSR     bits14to16[m[41m[m
[32m+[m[32m*                MOVE.B  D3,D7 ** need to know if immediate or absolute[m[41m[m
[32m+[m[32m*                JSR     bits11to13  ** mode to jump with[m[41m [m
[32m+[m[32m*                MOVE.B  D3,D4[m[41m[m
[32m+[m[32m*                LEA     jmp_mode,A0  *Index into the table[m[41m[m
[32m+[m[32m*                MULU    #6,D3[m[41m[m
[32m+[m[32m*                JSR     0(A0,D3)[m[41m [m
[32m+[m[32m*                JSR     bits14to16 ** register number if not absolute or immediate[m[41m[m
[32m+[m[32m*                CMP.B   #$FF,D7[m[41m[m
[32m+[m[32m*                BNE     NUM_INSERT[m[41m    [m
[32m+[m[32m*                RTS[m[41m [m
[32m+[m[32m*ADD_DEST[m[41m[m
[32m+[m[32m*                MOVE.W #%000,D3     ;Can only have a data register.[m[41m[m
[32m+[m[32m*                MOVE.W   D3,D4[m[41m[m
[32m+[m[32m*                LEA     jmp_mode,A0    *Index into the table[m[41m[m
[32m+[m[32m*                MULU    #6,D3       *Form offset[m[41m     [m
[32m+[m[32m*                JSR     0(A0,D3)   *Jump indirect with index[m[41m[m
[32m+[m[32m*                JSR     bits5to7[m[41m[m
[32m+[m[32m*                JSR     insert_num[m[41m[m
[32m+[m[32m*                RTS[m[41m[m
[32m+[m[32m*****************************[m[41m             [m
 MULS[m
                 JSR     MULS_BUFFER  ;returns with size bits in D3[m
[31m-                CMP     #%000,D3[m
[31m-                BNE     MULS_MAIN_SIZENOTWORD[m
[31m-                CLR.L     D3[m
[31m-                JSR     MULS_ISWORD[m
[31m-                BRA     MULS_DONE[m
[31m-                [m
[31m-MULS_MAIN_SIZENOTWORD[m
[31m-                CLR.L     D3[m
[31m-                JSR     MULS_ISLONG[m
[31m-                BRA     MULS_DONE[m
[31m-                [m
[31m-                ;go to word, long, etc.[m
[31m-                [m
[31m-MULS_DONE                [m
[31m-                RTS                     ;BRA     PRINT_BUFFER[m
[32m+[m[32m                RTS[m[41m[m
[32m+[m[41m[m
 [m
 [m
 MULS_BUFFER[m
[36m@@ -1130,67 +1196,19 @@[m [mMULS_BUFFER[m
                MOVE.B   #'S', (A6)+[m
                JSR      GETSIZE_MULS[m
                MOVE.B   #' ', (A6)+[m
[31m-               RTS[m
[32m+[m[32m               CLR.L      D6[m[41m[m
[32m+[m[32m               JSR      ADD_SRC[m[41m[m
[32m+[m[32m               MOVE.B   #',', (A6)+[m[41m[m
[32m+[m[32m               MOVE.B   #' ', (A6)+[m[41m[m
[32m+[m[32m                JSR      ADD_DEST[m[41m     [m
[32m+[m[32m               RTS[m[41m   [m
[32m+[m[41m [m
 [m
 [m
 [m
[31m-MULS_ISWORD[m
[31m-               CLR.L      D3[m
[31m-               CLR.L      D4[m
[31m-               JSR      bits11to13[m
[31m-               CMP      #%001,D3[m
[31m-               BEQ      INVALID_EA[m
[31m-               MOVE     D3,D4[m
[31m-               LEA     jmp_mode,A0    *Index into the table[m
[31m-               MULU    #6,D3       *Form offset     [m
[31m-               JSR     0(A0,D3)   *Jump indirect with index  [m
[31m-               CLR.L     D3[m
[31m-               JSR     bits14to16[m
[31m-               JSR     insert_num[m
[31m-               [m
[31m-               MOVE.B  #',',(A6)+[m
[31m-               MOVE.B  #' ',(A6)+[m
[31m-               MOVE.B  #'D',(A6)+[m
[31m-               [m
[31m-               JSR     bits5to7[m
[31m-               JSR     insert_num[m
[31m-               CLR.L     D3[m
[31m-               CLR.L     D4[m
[31m-               RTS[m
                [m
 [m
 [m
[31m-MULS_ISLONG[m
[31m-[m
[31m-                CLR.L   D7[m
[31m-                JSR     bits14to16[m
[31m-                MOVE.B  D3,D7 ** need to know if immediate or absolute[m
[31m-                [m
[31m-                [m
[31m-               CLR.L      D3[m
[31m-               CLR.L      D4[m
[31m-               JSR      bits11to13[m
[31m-               JSR      bits11to13[m
[31m-               CMP      #%001,D3[m
[31m-               MOVE     D3,D4[m
[31m-               LEA     jmp_mode,A0    *Index into the table[m
[31m-               MULU    #6,D3       *Form offset     [m
[31m-               JSR     0(A0,D3)   *Jump indirect with index  [m
[31m-               CLR.L     D3[m
[31m-               JSR     bits14to16[m
[31m-               [m
[31m-                CMP.B   #$FF,D7[m
[31m-                BNE     NUM_INSERT    [m
[31m-               [m
[31m-               MOVE.B  #',',(A6)+[m
[31m-               MOVE.B  #' ',(A6)+[m
[31m-               MOVE.B  #'D',(A6)+[m
[31m-               [m
[31m-               MOVE.B  #%100,D3[m
[31m-               JSR     insert_num[m
[31m-               CLR.L     D3[m
[31m-               CLR.L     D4[m
[31m-               RTS[m
 [m
 ************************************************    [m
 [m
[36m@@ -1201,29 +1219,28 @@[m [mMULS_ISLONG[m
 [m
 [m
 ************************************************               [m
[31m-[m
 AND    [m
                JSR     AND_BUFFER[m
[31m-                                             ;Okay, the directionality bit in D6 should determine which order we should process bits in?[m
[31m-               CMP      #1,D6[m
[31m-               BNE      CMP_DIRECTION_REVERSED  ;?????[m
[31m-               CLR.L      D6[m
[31m-               JSR      CMP_SRC[m
[31m-               MOVE.B   #',', (A6)+[m
[31m-               MOVE.B   #' ', (A6)+[m
[31m-               JSR      CMP_DEST[m
                RTS[m
                 [m
 AND_BUFFER[m
                MOVE.B   #'A',(A6)+[m
                MOVE.B   #'N', (A6)+  [m
                MOVE.B   #'D', (A6)+[m
[31m-               MOVE.B   #'.', (A6)+[m
[31m-               ** TODO: ADD SIZE BASED ON BITS 8 TO 10[m
[31m-               ** VALID SIZES ARE B (000) , W (001) ,L (010) ---> <EA> + DN --> DN [m
[31m-                               ** B (100) , W (101) ,L (110) --->  DN + <EA> --> <EA> [m
[32m+[m[32m               JSR      GETSIZE_ADD[m[41m[m
[32m+[m[41m               [m
[32m+[m[32m               ;Okay, the directionality bit in D6 should determine which order we should process bits in?[m[41m[m
[32m+[m[41m               [m
[32m+[m[32m               CMP      #1,D6[m[41m[m
[32m+[m[32m               BNE      ADD_DIRECTION_REVERSED[m[41m[m
[32m+[m[32m               JSR      ADD_SRC[m[41m[m
[32m+[m[32m               MOVE.B   #',', (A6)+[m[41m[m
                MOVE.B   #' ', (A6)+[m
[31m-               RTS    [m
[32m+[m[32m               JSR      ADD_DEST[m[41m[m
[32m+[m[32m               RTS[m[41m[m
[32m+[m[41m               [m
[32m+[m[41m               [m
[32m+[m[41m  [m
 [m
 [m
 **************************************************[m
[36m@@ -2285,7 +2302,7 @@[m [mGETSIZE_ADD[m
             CLR.L   D6[m
             ****[m
             JSR     SIZEISBYTE[m
[31m-            MOVE    #1,D6[m
[32m+[m[32m            MOVE    #1, D6[m[41m[m
             CLR.L    D3[m
             RTS[m
         [m
[36m@@ -2472,6 +2489,9 @@[m [mBUFFER DC.L 1[m
 [m
 >>>>>>> d55ff32b3e77f68eccfd3618fa1977b3d64590fe[m
 [m
[32m+[m[41m[m
[32m+[m[41m[m
[32m+[m[41m[m
 *~Font name~Courier New~[m
 *~Font size~10~[m
 *~Tab type~1~[m
[1mdiff --git a/comprehensive_test.X68 b/comprehensive_test.X68[m
[1mindex 9392c30..f9cb0fd 100644[m
[1m--- a/comprehensive_test.X68[m
[1m+++ b/comprehensive_test.X68[m
[36m@@ -514,6 +514,7 @@[m [mROCKBOTTOM[m
 [m
 [m
 [m
[32m+[m[41m[m
 *~Font name~Courier New~[m
 *~Font size~10~[m
 *~Tab type~1~[m
