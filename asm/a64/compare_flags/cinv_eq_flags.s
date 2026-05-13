/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: CINV - Conditional Invert
// CINV Xd, Xn, cond: Xd = ~Xn if cond true, else Xn

.text
.global _start
_start:
    // Set up flags: 0 == 0 -> Z=1
    mov x2, #0
    mov x3, #0
    cmp x2, x3
    
    // CINV X1, X2, EQ: X1 = ~X2 = ~0 = 0xFFFFFFFFFFFFFFFF if Z=1
    mov x2, #0
    cinv x1, x2, eq
    
    // NZCV = 0x60000000 (Z=1, C=1)
    mrs x0, nzcv
    
    brk #0