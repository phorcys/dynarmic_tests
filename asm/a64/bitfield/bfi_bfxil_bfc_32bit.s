/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFF3400",
    "X2": "0x00000000AAAA5523",
    "X4": "0x00000000FFFFF00F"
  }
}
*/
// 32-bit BFI/BFXIL/BFC coverage.

.text
.global _start
_start:
    movn w0, #0xFFFF           // 0xFFFF0000
    mov w1, #0x1234
    bfi w0, w1, #8, #8

    movz w2, #0x5555
    movk w2, #0xAAAA, lsl #16
    bfxil w2, w1, #4, #8

    movn w4, #0
    bfc w4, #4, #8

    brk #0
