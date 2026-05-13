/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000"
  }
}
*/
// Test: CMP with extended register - flags verification

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0x100
    mov w2, #0x80
    
    // CMP X1, W2, SXTW = CMP 0x100, 0x80 (sign-extended to 0x80)
    // 0x100 - 0x80 = 0x80 > 0, no borrow
    // N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    cmp x1, w2, sxtw
    
    // Read NZCV
    mrs x0, nzcv
    // Expected: 0x20000000 (C=1)
    
    brk #0