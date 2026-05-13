/* CONFIG
{
  "Match": "All",
  "RegData": {
    "R0": "0x80000001"
  }
}
*/
.text
.arm
.global _start
_start:
    @ RRX - Rotate Right with Extend
    @ RRX Rd, Rm - Rotate Rm right by 1 bit, inserting C flag into bit 31
    @ R0 = 0x00000003, C = 1
    @ After RRX: R0 = 0x80000001 (C goes to bit 31, bit 0 goes to C)
    
    mov r0, #3
    @ Set C flag using CMP: CMP a, b sets C=1 if a >= b (unsigned)
    @ CMP r1, #0 with r1=0xFFFFFFFF: 0xFFFFFFFF >= 0 -> C=1
    mvn r1, #0            @ r1 = 0xFFFFFFFF
    cmp r1, #0            @ Sets C=1 because 0xFFFFFFFF >= 0 (unsigned)
    
    rrx r0, r0
    bkpt #0
