/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: CINC with NE condition - Conditional Increment
// CINC Xd, Xn, cond: Xd = Xn + 1 if cond true, else Xn

.text
.global _start
_start:
    // Set up flags: 0 < 1 -> LT true, EQ false
    mov x2, #0
    mov x3, #1
    cmp x2, x3
    
    // CINC X1, X2, NE: X1 = X2 if NE false (Z=1 means equal, NE is false)
    // Actually Z=0 (not equal), so NE is true, X1 = X2 + 1 = 0 + 1 = 1
    mov x2, #0
    cinc x1, x2, ne
    
    // NZCV = 0x80000000 (N=1)
    mrs x0, nzcv
    
    brk #0
