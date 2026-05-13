/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000000",
    "X2": "0x00000000FFFFFFFF",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000004",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000001",
    "X7": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// SBC result-only coverage for borrow and overlap cases.

.text
.global _start
_start:
    mov w0, #0
    mov w1, #0
    mov x8, #0

    cmp x8, #1
    sbc w2, w0, w1              // 0 - 0 - 1 = 0xFFFFFFFF

    cmp xzr, xzr
    sbc w3, w0, w1              // 0 - 0 - 0 = 0

    mov w4, #5
    cmp x8, #1
    sbc w4, w4, w1              // 5 - 0 - 1 = 4

    mov x5, #0
    mov x6, #1
    cmp xzr, xzr
    sbc x7, x5, x6              // 0 - 1 - 0 = -1

    brk #0
