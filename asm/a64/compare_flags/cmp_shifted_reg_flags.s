/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000020000000"
  }
}
*/
// Test: CMP with shifted register - flags verification

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0x100
    mov x2, #2
    
    // CMP X1, X2, LSL #3 = CMP 0x100, 0x10 = 0xF0 > 0
    // N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    cmp x1, x2, lsl #3
    
    // Read NZCV
    mrs x0, nzcv
    // Expected: 0x20000000 (C=1)
    
    brk #0