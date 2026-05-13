/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x7FFFFFFFFFFFFFFF",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000003",
    "X3": "0x0000000001000000"
  }
}
*/
// UDIV 64-bit edge coverage: max values, divide-by-zero, truncation, large quotient.

.text
.global _start
_start:
    mov x0, #-1
    mov x4, #2
    udiv x0, x0, x4             // overlap: max_u64 / 2

    mov x1, #123
    mov x4, #0
    udiv x1, x1, x4             // divide by zero -> 0

    mov x2, #10
    mov x4, #3
    udiv x2, x2, x4             // 3

    mov x3, #1
    lsl x3, x3, #32
    mov x4, #0x100
    udiv x3, x3, x4             // 2^32 / 256 = 2^24

    brk #0
