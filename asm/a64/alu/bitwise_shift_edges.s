/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x00000000000000F0",
    "X3": "0x000000000000FFFF",
    "X4": "0x000000000000F0FF",
    "X5": "0x000000000000FFF0",
    "X6": "0xFFFFFFFFFFFFFF0F"
  }
}
*/
// Shifted-register forms for AND/ORR/EOR/BIC/ORN.

.text
.global _start
_start:
    mov x0, #0xFFFF
    mov x1, #0x0F
    and x2, x0, x1, lsl #4
    orr x3, x0, x1, lsl #8
    eor x4, x0, x1, lsl #8
    bic x5, x0, x1
    orn x6, xzr, x1, lsl #4

    brk #0
