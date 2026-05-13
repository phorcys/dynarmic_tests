/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x00000000FFFFFF80",
    "X3": "0x00000000FFFF8000",
    "X5": "0x0000000000000080",
    "X6": "0x0000000000008000",
    "X8": "0xFFFFFFFF80000000"
  }
}
*/
// 32-bit destination and overlap coverage for SXTB/SXTH/SXTW/UXTB/UXTH.

.text
.global _start
_start:
    mov w0, #0x80
    sxtb w1, w0

    mov w2, #0x8000
    sxth w3, w2

    movz w4, #0x5680
    movk w4, #0x1234, lsl #16
    uxtb w5, w4

    movz w6, #0x8000
    movk w6, #0x1234, lsl #16
    uxth w6, w6

    mov w7, #1
    lsl w7, w7, #31
    sxtw x8, w7

    brk #0
