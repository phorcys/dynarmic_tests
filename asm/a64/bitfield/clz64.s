/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000040",
    "X2": "0x000000000000001F"
  }
}
*/
// Test: CLZ - Count Leading Zeros (64-bit)

.text
.global _start
_start:
    // 0x8000000000000000 has 0 leading zeros in top bit
    mov x0, #1
    lsl x0, x0, #63
    clz x0, x0  // Result: 0
    
    // 0 has 64 leading zeros
    mov x1, #0
    clz x1, x1  // Result: 64
    
    // 0x0000000100000000 has 31 leading zeros
    mov x2, #1
    lsl x2, x2, #32
    clz x2, x2  // Result: 31

    brk #0
