/* $xilinx_legal_disclaimer */
#define   EPN_V_TS_I   0x0290
#define   EPN_V_TS_D   0x0390
#define   RPN_ERPN     0x043F
#define   TS_BIT       0x0100

.file "boot.S"

.section .boot0,"ax"
.global _boot0

_boot0:
  li      0,0
  dccci   0,0                    // invalidate D-Cache, operands not used, see table
  lis     2,  0x00200000@h       // set CCR0: DSTG DTB? DAPUIB?
  ori     2,2,0x00200000@l      
  mtspr   0x3b3,2                // set CCR0
  mtspr   0x378,0                // clear CCR1
  mtspr   0x3b2,0                // clear MMUCR
  iccci   0,0
  mtcrf   0xff,0                 // need for simulation
  mtxer   0
  mtctr   0

  // setup register constants (6,7), page index (5), address variable (4), EPN_V_TS bits (3)
  li	  7,RPN_ERPN              // set up !(U0-3),!W,I,!M,!G,!E,UX,UW,UR,SX,SW,SR constant
  lis     6,  0x10000000@h        // 256MB page constant
  ori     6,6,0x10000000@l
  mr      5,0                     // TLB entry index
  mr      4,0                     // RPN
	
  // setup TLB pages
  // two entries are setup for the same 256MB page -
  // one for instruction memory and the other for data
  // memory. (TS bit=0 for instructions)
  //
tlbloop:
  mr     3,4
  ori    3,3,EPN_V_TS_I
  tlbwe  3,5,0              // set up EPN,V,TS=0(Instruction),SIZE=256MB,TID=0
  tlbwe  4,5,1              // set up RPN,ERPN (r4 contains RPN)
  tlbwe  7,5,2              // set up !(U0-3),!W,I,!M,!G,!E,UX,UW,UR,SX,SW,SR
  xori   3,3,TS_BIT	    // set TS bit to 1
  addi   5,5,1              // next page
  tlbwe  3,5,0              // set up EPN,V,TS=1(Data),SIZE=256MB,TID=0
  tlbwe  4,5,1              // set up RPN,ERPN (r4 contains RPN)
  tlbwe  7,5,2              // set up !(U0-3),!W,I,!M,!G,!E,UX,UW,UR,SX,SW,SR
  add    4,4,6		    // set R4 to next 256MB block
  addi   5,5,1              // next page
  cmpwi  5,32
  bne    tlbloop
tlbzero:                    // zero out index 32-63 TLB entries
  tlbwe  0,5,0
  tlbwe  0,5,1
  tlbwe  0,5,2
  addi   5,5,1
  cmpwi  5,64
  bne    tlbzero
	
  lis    1,   _start@h
  ori    1,1,_start@l
  mtsrr0 1                  // program execution will resume at r1
  li     1,0x00000010@l     // MSR[IS]=0 MSR[DS]=1
  mtsrr1 1                  // SRR1 copied into MSR
  rfi                       // done to allow EA and/or MSR to change for
                            // rest of initialization sequence

.section .boot,"ax"
.global _boot

_boot:
  b _boot0
