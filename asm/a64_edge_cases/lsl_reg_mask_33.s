/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x000000002468ACF0"
  }
}
*/
// Edge case test: lsl_reg_mask_33

.text
.global _start
_start:

    mov w0, #0x5678
    movk w0, #0x1234, lsl #16   // w0 = 0x12345678
    mov w1, #33
    lsl w2, w0, w1              // w2 = w0 << (33 & 31) = w0 << 1 = 0x2468ACF0


    brk #0
