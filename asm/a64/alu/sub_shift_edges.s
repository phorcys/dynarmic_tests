/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000001",
    "X2": "0x8000000000000000",
    "X3": "0xFFFFFFFFFFFFFFFF",
    "X4": "0xFFFFFFFFFFFFFFFE",
    "X5": "0x0000000080000000",
    "X6": "0x0000000000000001",
    "X7": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// SUB shifted-register edge cases across 32-bit and 64-bit widths.

.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    sub x2, x0, x1, lsl #0      // 1 - 1 = 0, then reuse x2 below

    movn x3, #0                 // x3 = -1
    sub x4, x3, x1, lsl #0      // -1 - 1 = -2

    mov w5, #0x80000000
    sub w6, wzr, w5, asr #31    // 0 - (-1) = 1

    sub x7, xzr, x1, lsl #0     // 0 - 1 = -1
    sub x2, xzr, x1, lsl #63    // 0 - (1 << 63) = 0x8000...

    brk #0
