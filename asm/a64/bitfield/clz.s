/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000003A"
  }
}
*/
// Test: CLZ Xd, Xn - Count Leading Zeros
// Count the number of leading zero bits

.text
.global _start
_start:
    // Count leading zeros in 42 (0b101010)
    // 42 = 0x2A = 0b...00000000000000000000000000101010
    // 64-bit: 0x000000000000002A
    // Leading zeros = 58 = 0x3A
    
    mov x0, #42
    clz x0, x0
    // X0 = 58 = 0x3A

    brk #0
