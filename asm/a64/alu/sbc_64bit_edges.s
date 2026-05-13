/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0xFFFFFFFFFFFFFFFF",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000004",
    "X7": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// SBC 64-bit boundary coverage including borrow and overlap.

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    mov x8, #0

    cmp x8, #1
    sbc x2, x0, x1              // 0 - 0 - 1 = -1

    cmp xzr, xzr
    sbc x3, x0, x1              // 0 - 0 - 0 = 0

    mov x4, #5
    cmp x8, #1
    sbc x4, x4, xzr             // overlap: 5 - 0 - 1 = 4

    mov x5, #0
    mov x6, #1
    cmp xzr, xzr
    sbc x7, x5, x6              // 0 - 1 - 0 = -1

    brk #0
