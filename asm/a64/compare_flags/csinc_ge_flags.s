/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: CSINC - Conditional Select Increment
// CSINC Xd, Xn, Xm, cond: Xd = Xn if cond true, else Xm + 1

.text
.global _start
_start:
    // Set up flags: 0 < 1 -> LT true
    mov x2, #0
    mov x3, #1
    cmp x2, x3
    
    // CSINC X1, X2, X3, LT: X1 = X2 = 0 if LT true
    mov x2, #0
    mov x3, #0
    csinc x1, x2, x3, lt
    
    // Wait, LT is true, so X1 = X2 = 0
    // But I want to test the else branch
    // Let me redo: CSINC X1, X2, X3, GE: X1 = X3 + 1 = 1 if GE false (LT true)
    mov x2, #0
    mov x3, #0
    csinc x1, x2, x3, ge
    
    // NZCV = 0x80000000 (N=1)
    mrs x0, nzcv
    
    brk #0
