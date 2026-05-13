/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: NEGS 64-bit - negate and set flags

.text
.global _start
_start:
    mov x2, #1
    
    // NEGS X3, X2 = SUBS X3, XZR, X2 = 0 - 1 = -1
    // N=1, Z=0, C=0 (borrow), V=0
    // NZCV = 0x80000000
    negs x3, x2
    
    mrs x0, nzcv
    mov x1, x3
    
    brk #0