/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0xFFFFFFFFFFFFFF00"
  }
}
*/
// Test: BICS with LSL shift - Bit Clear with flag set
// BICS Xd, Xn, Xm, LSL #amount: Xd = Xn & ~(Xm << amount), sets N, Z

.text
.global _start
_start:
    mov x2, #0xFFFFFFFFFFFFFFFF
    mov x3, #0xFF
    
    // BICS X1, X2, X3, LSL #0 = 0xFFFFFFFFFFFFFFFF & ~(0xFF << 0) = 0xFFFFFFFFFFFFFFFF & 0xFFFFFFFFFFFFFF00 = 0xFFFFFFFFFFFFFF00
    // N=1, Z=0 -> NZCV = 0x80000000
    
    bics x1, x2, x3, lsl #0
    
    mrs x0, nzcv
    
    brk #0
