/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: CSINV - Conditional Select Invert
// CSINV Xd, Xn, Xm, cond: Xd = Xn if cond true, else ~Xm

.text
.global _start
_start:
    // Set up flags: 0 < 1 -> LT true
    mov x2, #0
    mov x3, #1
    cmp x2, x3
    
    // CSINV X1, X2, X3, GE: X1 = ~X3 = ~0 = 0xFFFFFFFFFFFFFFFF if GE false
    mov x2, #0
    mov x3, #0
    csinv x1, x2, x3, ge
    
    // NZCV = 0x80000000 (N=1)
    mrs x0, nzcv
    
    brk #0
