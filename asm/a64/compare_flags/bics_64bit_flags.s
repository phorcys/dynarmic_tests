/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: BICS - Bit Clear and Set Flags
// BICS Xd, Xn, Xm: Xd = Xn & ~Xm, sets N, Z

.text
.global _start
_start:
    mov x2, #0xFFFFFFFFFFFFFFFF
    mov x3, #0
    
    // BICS X1, X2, X3 = 0xFFFFFFFFFFFFFFFF & ~0 = 0xFFFFFFFFFFFFFFFF
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    
    bics x1, x2, x3
    
    mrs x0, nzcv
    
    brk #0