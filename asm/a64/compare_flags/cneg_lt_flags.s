/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: CNEG - Conditional Negate
// CNEG Xd, Xn, cond: Xd = -Xn if cond true, else Xn

.text
.global _start
_start:
    // Set up flags: 0 < 1 -> LT true
    mov x2, #0
    mov x3, #1
    cmp x2, x3
    
    // CNEG X1, X2, LT: X1 = -X2 = -(-1) = 1 if LT true (N!=V)
    // Actually X2 = -1, so -X2 = 1
    mov x2, #0xFFFFFFFFFFFFFFFF
    cneg x1, x2, lt
    
    // NZCV = 0x80000000 (N=1)
    mrs x0, nzcv
    
    brk #0
