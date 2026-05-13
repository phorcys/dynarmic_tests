/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x0000000012345678"
  }
}
*/
// Edge case test: asr_reg_mask_pos

.text
.global _start
_start:

    mov w0, #0x5678
    movk w0, #0x1234, lsl #16   // w0 = 0x12345678 (positive)
    mov w1, #32
    asr w2, w0, w1              // w2 = w0 >> (32 & 31) = w0 >> 0 = w0


    brk #0
