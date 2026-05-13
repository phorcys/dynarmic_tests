/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000000000000"
  }
}
*/
// Test: ANDS with LSR shift - AND with flag set
// ANDS Xd, Xn, Xm, LSR #amount: Xd = Xn & (Xm >> amount), sets N, Z

.text
.global _start
_start:
    mov x2, #0
    mov x3, #0xFFFFFFFFFFFFFFFF
    
    // ANDS X1, X2, X3, LSR #1 = 0 & (0xFFFFFFFFFFFFFFFF >> 1) = 0 & 0x7FFFFFFFFFFFFFFF = 0
    // N=0, Z=1 -> NZCV = 0x40000000
    
    ands x1, x2, x3, lsr #1
    
    mrs x0, nzcv
    
    brk #0
