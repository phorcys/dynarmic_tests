/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x000000000000003F",
    "X2": "0x000000000000003E"
  }
}
*/
// Test: CLS - Count Leading Sign bits (64-bit)

.text
.global _start
_start:
    // 0x8000000000000000: bit 63=1, followed by 0s
    // CLS counts sign bits (bits matching bit 63)
    // Result: 0 (no bits matching bit 63 after the first)
    mov x0, #1
    lsl x0, x0, #63
    cls x0, x0
    
    // -1 has 63 leading sign bits (all 1s)
    mov x1, #-1
    cls x1, x1  // Result: 63
    
    // 1: bit 63=0, followed by 0s until bit 0
    // CLS counts leading 0s after bit 63
    mov x2, #1
    cls x2, x2  // Result: 62

    brk #0
