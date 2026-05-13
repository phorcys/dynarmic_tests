/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x000000007FFFFFFE",
    "X3": "0x0000000000000000",
    "X5": "0x00000000FFFFFFF0"
  }
}
*/
// BIC 32-bit coverage with edge values, overlap, and shifted mask.

.text
.global _start
_start:
    movn w0, #0
    mov w1, #1
    lsl w1, w1, #31
    add w1, w1, #1
    bic w2, w0, w1

    movz w3, #0x5678
    movk w3, #0x1234, lsl #16
    bic w3, w3, w3

    movn w4, #0
    mov w6, #0xF
    bic w5, w4, w6, lsl #0

    brk #0
