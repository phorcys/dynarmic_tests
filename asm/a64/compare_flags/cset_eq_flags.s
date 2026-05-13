/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000060000000",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: CSET - Conditional Set
// CSET Xd, cond: Xd = 1 if cond true, else 0

.text
.global _start
_start:
    // First set up flags: 0 == 0 -> Z=1
    mov x2, #0
    mov x3, #0
    cmp x2, x3
    
    // CSET X1, EQ: X1 = 1 because Z=1 (equal)
    cset x1, eq
    
    // NZCV = 0x60000000 (Z=1, C=1 from CMP)
    mrs x0, nzcv
    
    brk #0