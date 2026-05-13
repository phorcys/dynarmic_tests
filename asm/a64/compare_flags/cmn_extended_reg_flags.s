/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000090000000"
  }
}
*/
// Test: CMN with extended register - flags verification (32-bit)

.text
.global _start
_start:
    mov x0, #0
    mov w1, #0x7FFFFFFF   // 32-bit max positive
    mov w2, #1
    
    // CMN W1, W2, SXTB = CMN 0x7FFFFFFF, 1
    // 0x7FFFFFFF + 1 = 0x80000000 (negative, signed overflow)
    // N=1, Z=0, C=0, V=1 -> NZCV = 0x90000000
    cmn w1, w2, sxtb
    
    // Read NZCV
    mrs x0, nzcv
    
    brk #0
