/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x123456789ABCDEF0"
  }
}
*/
// Edge case test: lsl64_reg_mask_64

.text
.global _start
_start:

    mov x0, #0xDEF0
    movk x0, #0x9ABC, lsl #16
    movk x0, #0x5678, lsl #32
    movk x0, #0x1234, lsl #48
    mov x1, #64
    lsl x2, x0, x1              // x2 = x0 << (64 & 63) = x0 << 0 = x0


    brk #0
