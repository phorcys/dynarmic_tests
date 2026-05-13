/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0xFFFFFFFFFFFFFFFB",
    "X3": "0x8000000000000000",
    "X4": "0xFFFFFFFFFFFFFFFF",
    "X6": "0xFFFFFFFFFFFFF001"
  }
}
*/
// Reverse-sub semantics encoded via SUB from XZR or zero-valued source.

.text
.global _start
_start:
    mov x0, #5
    sub x1, xzr, x0

    mov x2, #1
    sub x3, xzr, x2, lsl #63

    mov x4, #1
    sub x4, xzr, x4

    mov x5, #0
    sub x6, x5, #4095

    brk #0
