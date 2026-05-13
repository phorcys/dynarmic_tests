/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0xFFFFFFFFFFFF8FFF",
    "X3": "0x0000000000008FFF",
    "X5": "0x0000000000000001",
    "X6": "0xFFFFFFFFFFFF0FFE"
  }
}
*/
// SUB halfword extend variants missing from the basic extend tests.

.text
.global _start
_start:
    mov x0, #0x1000
    mov w1, #0x8001
    mov w4, #0x0FFF

    sub x2, x0, w1, uxth
    sub x3, x0, w1, sxth
    sub x5, x0, w4, sxth

    mov x6, #0x1000
    sub x6, x6, w1, uxth #1

    brk #0
