/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000001",
    "X2": "0x8000000000000001",
    "X3": "0xFFFFFFFFFFFFFFFF",
    "X4": "0x0000000000000002",
    "X5": "0x0000000080000000",
    "X6": "0x00000000FFFFFFFF",
    "X7": "0x0000000000000004"
  }
}
*/
// ADD shifted-register edge cases across 32-bit and 64-bit widths.

.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    add x2, x0, x1, lsl #63     // 1 + (1 << 63)

    movn x3, #0                 // x3 = -1
    add x4, x1, x3, lsr #63     // 1 + 1 = 2

    mov w5, #0x80000000
    add w6, wzr, w5, asr #31    // 0 + (-1)

    mov w7, #3
    add w7, w7, w5, lsr #31     // 3 + 1 = 4

    brk #0
