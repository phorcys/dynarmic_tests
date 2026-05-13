/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// CLS count leading sign - bits matching bit 63

.text
.global _start
_start:
    mov x0, #-1
    lsr x0, x0, #1        // 0x7FFFFFFFFFFFFFFF (sign bit = 0, bit 62 = 1, different)
    cls x0, x0            // count leading sign bits = 0
    brk #0
