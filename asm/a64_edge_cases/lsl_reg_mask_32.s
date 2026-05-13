/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000012345678"
  }
}
*/
// Edge case test: lsl_reg_mask_32

.text
.global _start
_start:

    mov w0, #0x5678
    movk w0, #0x1234, lsl #16   // w0 = 0x12345678
    mov w1, #32
    lsl w2, w0, w1              // w2 = w0 << (32 & 31) = w0 << 0 = w0


    brk #0
