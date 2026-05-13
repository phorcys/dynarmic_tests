/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: CSET with LT condition - Conditional Set
// CSET Xd, cond: Xd = 1 if cond true, else 0

.text
.global _start
_start:
    // First set up flags: 0 < 1 -> LT true
    mov x2, #0
    mov x3, #1
    cmp x2, x3  // 0 - 1 = -1, N=1, V=0, N!=V -> LT true
    
    // CSET X1, LT: X1 = 1 because N!=V (less than)
    cset x1, lt
    
    // NZCV = 0x80000000 (N=1)
    mrs x0, nzcv
    
    brk #0