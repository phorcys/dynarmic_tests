/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000",
    "X1": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: CSETM - Conditional Set Mask
// CSETM Xd, cond: Xd = ~0 if cond true, else 0

.text
.global _start
_start:
    // First set up flags: 2 > 1 -> HI true
    mov x2, #2
    mov x3, #1
    cmp x2, x3  // 2 - 1 = 1, C=1 (no borrow), Z=0
    
    // CSETM X1, HI: X1 = ~0 because C=1 && Z=0 (higher)
    csetm x1, hi
    
    // NZCV = 0x20000000 (C=1)
    mrs x0, nzcv
    
    brk #0
