/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x00000000FFFFFFFF"
  }
}
*/
// Edge case test: asr_reg_mask_neg

.text
.global _start
_start:

    mov w0, #0xFFFF
    movk w0, #0xFFFF, lsl #16   // w0 = 0xFFFFFFFF (negative)
    mov w1, #32
    asr w2, w0, w1              // w2 = w0 >> (32 & 31) = w0 >> 0 = w0


    brk #0
