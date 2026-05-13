/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// Test: TST with shifted register - flags verification

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0xFF00
    mov x2, #0xFF
    
    // TST X1, X2, LSL #8 = TST 0xFF00, 0xFF00
    // 0xFF00 AND 0xFF00 = 0xFF00 (non-zero, positive)
    // N=0, Z=0, C=0, V=0 -> NZCV = 0x00000000
    tst x1, x2, lsl #8
    
    // Read NZCV
    mrs x0, nzcv
    
    brk #0