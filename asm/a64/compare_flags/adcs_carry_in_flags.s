/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000002"
  }
}
*/
// Test: ADCS with carry-in set (C=1)
// ADCS Xd, Xn, Xm: Xd = Xn + Xm + C

.text
.global _start
_start:
    // Set C=1 using CMP (1 > 0, no borrow, C=1)
    mov x2, #1
    cmp x2, #0          // 1 - 0 = 1, N=0, Z=0, C=1, V=0
    
    // ADCS with C=1
    mov x3, #1
    mov x4, #0
    
    // 1 + 0 + 1 = 2
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    adcs x1, x3, x4
    
    mrs x0, nzcv
    
    brk #0