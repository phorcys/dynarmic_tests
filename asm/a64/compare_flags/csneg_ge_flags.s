/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: CSNEG - Conditional Select Negate
// CSNEG Xd, Xn, Xm, cond: Xd = Xn if cond true, else -Xm

.text
.global _start
_start:
    // Set up flags: 0 < 1 -> LT true
    mov x2, #0
    mov x3, #1
    cmp x2, x3
    
    // CSNEG X1, X2, X3, GE: X1 = -X3 = -(-1) = 1 if GE false
    mov x2, #0
    mov x3, #0xFFFFFFFFFFFFFFFF
    csneg x1, x2, x3, ge
    
    // NZCV = 0x80000000 (N=1)
    mrs x0, nzcv
    
    brk #0
