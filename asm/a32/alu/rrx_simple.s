/* CONFIG
{
  "Match": "All",
  "RegData": { "R0": "0x80000000" }
}
*/
.text
.global _start
_start:
    @ RRX: Rotate Right with Extend
    @ RRX Rd, Rm
    @ Rotates right by 1 bit, inserting C flag into bit 31
    
    @ First set C=1
    cmp r0, r0           @ Sets C=1 (10-10=0, no borrow)
    
    ldr r1, =0x00000001
    rrx r0, r1           @ R0 = (C << 31) | (r1 >> 1) = 0x80000000
    
    bkpt #0
.ltorg
