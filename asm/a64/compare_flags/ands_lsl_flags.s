/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000080000000",
    "X1": "0x8000000000000000"
  }
}
*/
// Test: ANDS with LSL shift - AND with flag set
// ANDS Xd, Xn, Xm, LSL #amount: Xd = Xn & (Xm << amount), sets N, Z

.text
.global _start
_start:
    mov x2, #1
    mov x3, #1
    
    // ANDS X1, X2, X3, LSL #63 = 1 & (1 << 63) = 1 & 0x8000000000000000 = 0
    // Wait, that should be 0... let me reconsider
    // Actually: X2 = 1, X3 = 1
    // X3 << 63 = 0x8000000000000000
    // 1 & 0x8000000000000000 = 0
    // But wait, let me try a different approach
    
    mov x2, #0xFFFFFFFFFFFFFFFF
    mov x3, #1
    
    // ANDS X1, X2, X3, LSL #63 = 0xFFFFFFFFFFFFFFFF & (1 << 63) = 0x8000000000000000
    // N=1, Z=0 -> NZCV = 0x80000000
    
    ands x1, x2, x3, lsl #63
    
    mrs x0, nzcv
    
    brk #0
