/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFE",
    "X1": "0x0000000000000001",
    "X2": "0x0000000000000002",
    "X3": "0x0000000000000000"
  }
}
*/
// UMULH edge coverage with unsigned extreme combinations.

.text
.global _start
_start:
    mov x0, #-1
    mov x4, #-1
    umulh x0, x0, x4            // high((2^64-1)^2) = 2^64-2

    mov x1, #1
    lsl x1, x1, #63
    mov x4, #2
    umulh x1, x1, x4            // high(2^63 * 2) = 1

    mov x2, #1
    lsl x2, x2, #32
    mov x4, #1
    lsl x4, x4, #33
    umulh x2, x2, x4            // high(2^32 * 2^33) = 2

    mov x3, #0xFFFF
    umulh x3, x3, x3            // small product high = 0

    brk #0
