/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// Test: SBCS with carry-in cleared (C=0)
// SBCS Xd, Xn, Xm: Xd = Xn - Xm - (1-C)

.text
.global _start
_start:
    // Set C=0 using ADDS (overflow clears C)
    mov x2, #0
    adds xzr, x2, #1    // 0 + 1 = 1, N=0, Z=0, C=0, V=0
    
    // SBCS with C=0
    mov x3, #0
    mov x4, #0
    
    // 0 - 0 - 1 = -1 (0xFFFFFFFFFFFFFFFF)
    // N=1, Z=0, C=0 (borrow), V=0 -> NZCV = 0x80000000
    sbcs x1, x3, x4
    
    mrs x0, nzcv
    
    brk #0