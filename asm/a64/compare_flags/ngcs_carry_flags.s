/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0xFFFFFFFF80000000"
  }
}
*/
// Test: NGCS with various inputs - flags verification
// NGCS Xd, Xn = SBCS Xd, XZR, Xn (Negate with Carry)

.text
.global _start
_start:
    // Set C=0 first (0 + 1 sets C=0)
    mov x0, #0
    mov x1, #1
    adds xzr, x0, x1    // 0 + 1 = 1, C=0
    
    // Now test NGCS with C=0
    // NGCS X2, X3 = SBCS X2, XZR, X3
    // With C=0: 0 - X3 - 1
    mov x3, #0x7FFFFFFF
    
    ngcs x2, x3
    
    // Result: 0 - 0x7FFFFFFF - 1 = -0x80000000
    // 64-bit result: 0xFFFFFFFF80000000
    // N=1, Z=0, C=0, V=0 -> NZCV = 0x80000000
    
    mrs x0, nzcv
    mov x1, x2
    
    brk #0