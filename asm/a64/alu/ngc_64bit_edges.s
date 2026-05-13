/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0xFFFFFFFFFFFFFFFF",
    "X2": "0x0000000000000000",
    "X4": "0xFFFFFFFFFFFFFFFA",
    "X5": "0xFFFFFFFFFFFFFFFB",
    "X6": "0xFFFFFFFFFFFFFFFE"
  }
}
*/
// NGC 64-bit boundary coverage including carry-in behavior and overlap.

.text
.global _start
_start:
    mov x0, #0
    mov x8, #0

    cmp x8, #1
    ngc x1, x0                  // 0 - 0 - 1 = -1

    cmp xzr, xzr
    ngc x2, x0                  // 0 - 0 - 0 = 0

    mov x3, #5
    cmp x8, #1
    ngc x4, x3                  // 0 - 5 - 1 = -6

    cmp xzr, xzr
    ngc x5, x3                  // 0 - 5 - 0 = -5

    mov x6, #1
    cmp x8, #1
    ngc x6, x6                  // overlap: 0 - 1 - 1 = -2

    brk #0
