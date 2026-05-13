/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000000000002"
  }
}
*/
// Test: CINC - Conditional Increment
// CINC Xd, Xn, cond: Xd = Xn + 1 if cond true, else Xn

.text
.global _start
_start:
    // Set up flags: 0 == 0 -> Z=1
    mov x2, #0
    mov x3, #0
    cmp x2, x3
    
    // CINC X1, X2, EQ: X1 = X2 + 1 = 0 + 1 = 1 if Z=1
    // But wait, EQ is true, so X1 = X2 + 1 = 1
    mov x2, #1
    cinc x1, x2, eq
    
    // NZCV = 0x60000000 (Z=1, C=1)
    mrs x0, nzcv
    
    brk #0
