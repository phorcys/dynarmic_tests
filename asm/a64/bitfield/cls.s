/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000039"
  }
}
*/
// Test: CLS Xd, Xn - Count Leading Sign bits
// Count the number of leading sign bits (excluding the sign bit itself)

.text
.global _start
_start:
    // Count leading sign bits in positive number
    // 42 = 0x2A, sign bit = 0
    // CLS counts leading bits that match the sign bit, excluding the sign bit
    // 42 has bit 63 = 0, bits 62-6 = 0 (57 zeros)
    // So CLS(42) = 57 = 0x39
    
    mov x0, #42
    cls x0, x0
    // X0 = 57 = 0x39

    brk #0
