/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000000000000"
  }
}
*/
// Test: ANDS 64-bit - flags verification
// ANDS Xd, Xn, Xm: Xd = Xn & Xm, sets N, Z

.text
.global _start
_start:
    mov x2, #0x80000000
    movk x2, #0x8000, lsl #16  // x2 = 0x8000800000000000
    
    // ANDS with mask to get sign bit
    mov x3, #1
    lsl x3, x3, #63  // x3 = 0x8000000000000000
    
    ands x1, x2, x3
    
    // x2 = 0x0000800000000000 (low 32 bits are 0x80000000)
    // x3 = 0x8000000000000000
    // AND = 0 (bit 63 is 0 in x2)
    // N=0, Z=1, C=0, V=0 -> NZCV = 0x40000000
    
    mrs x0, nzcv
    
    brk #0