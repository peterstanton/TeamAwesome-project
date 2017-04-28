*-----------------------------------------------------------
* Program    :Memory test program
* Description: This is a program to test memory from byte address $2000 to byte address $6000. 
* It uses four test patterns, 00, $FF. $AA, $55 and 
* it can store up to 10 bad address locations

*-----------------------------------------------------------

* System Equates
*
end_test	EQU 	$11 	* Test pattern terminator
test1    	EQU 	00  	* First Test Pattern
test2    	EQU 	$FF 	* Second test pattern
test3    	EQU 	$55 	* Third Test Pattern
test4    	EQU 	$AA 	* Fourth test pattern
st_addr	 	EQU	$2000	* Starting Address of Test
end_addr	EQU	$2010	* Ending address of test
stack		EQU	$7000	* Stack location
maxcnt		EQU	10	* Maximum number of bad addresses

		ORG	$400		* Start of program
start		LEA	stack,SP	* Initialize the stack pointer
                CLR.B	D0		* Initialize D0
		CLR.B	bad_cnt		* Initialize the bad address counter
		LEA	tests,A2	* A2 points to the test patterns
		LEA	bad_addr,A3	* Pointer to bad count storage
test_loop	MOVE.B	(A2)+,D6	* Let D6 test the patterns for done
		CMPI.B	#end_test,D6	* Are we done?
		BEQ	done		* Yes, quit
		LEA	st_addr,A0	* Set up the starting address in A0
		LEA	end_addr,A1	* Set up the ending address in A1
		JSR	do_test		* Go to the test
                MOVE.B  bad_cnt,D7      * Get the current count
                CMPI.B  #maxcnt,D7      * Have we max'ed out yet?
                BLT     test_loop       * Quit or keep going?
done            STOP    #$2700  * Return to the simulator


****************************************************************
*
* Subroutine do_test
*
* This subroutine does the actual testing.
* A0 holds the starting address.
* A1 holds the ending address. A2 points to the test pattern to use in
* this test.
* Registers A5,D1 and D7 are used internally by the subroutine and are
* saved.
* This routine will test the memory locations from A0 to A1 and put the
* address of any failed memory locations in bad_addr and will also
* increment the count in bad_cnt. If the count exceeds 10
* the test will stop
*
***********************************************************************
do_test         MOVEM.W         A3/D1/D7,-(SP)          * Save the registers
check_loop      MOVE.B          (A2),(A0)               * Write the byte
                MOVE.B          (A0),D1         * D1 holds the value written
                CMP.B           (A2),D1         * Do the comparison
                BNE             error_byte      * Update counter
                BRA             next_test       * OK, test again
error_byte      MOVE.W          A0,(A3)+        * Store address and increment ptr
                ADDI.B          #01,bad_cnt     * Increment bad count location
                MOVE.B          bad_cnt,D7      * Have we maxed out?
                CMPI.B          #maxcnt,D7      * Check it
                BGE             exit            * Return, we're done.
next_test       ADDA.W          #01,A0          * Increment A0

                CMPA.W          A0,A1           * Test if we're done
                BGE             check_loop      * go back and test the next addr
exit            MOVEM.W        (SP)+,   A3/D1/D7  * Restore the registers
                RTS                             * return to test program

* Data storage region
tests           DC.B  test1,test2,test3,test4,end_test        * tests
padding         DC.B  00                        * filler
bad_cnt         DS.W  1                * counter for bad locations
bad_addr        DS.W  10 * save space for 10 locations       
                END     $400 * end of program and load address








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
