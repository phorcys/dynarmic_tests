/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x2468ACF13579BDE0"
  }
}
*/
// Edge case test: lsl64_reg_mask_65

.text
.global _start
_start:

    mov x0, #0xDEF0
    movk x0, #0x9ABC, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    mov x1, #65
    lsl x2, x0, x1              // x2 = x0 << (65 & 63) = x0 << 1


    brk #0
