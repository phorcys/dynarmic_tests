/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFF2",
    "X2": "0x00000000000000F2",
    "X4": "0x00000000FFFFFFF2",
    "X6": "0x00000000000000F2",
    "X7": "0x000000008ABCDEF0"
  }
}
*/
// 32-bit SBFM/SBFX/UBFM/UBFX/EXTR coverage.

.text
.global _start
_start:
    mov w1, #0xF20
    sbfm w0, w1, #4, #11

    mov w3, #0xF20
    ubfm w2, w3, #4, #11

    mov w5, #0xF20
    sbfx w4, w5, #4, #8
    ubfx w6, w5, #4, #8

    movz w8, #0x5678
    movk w8, #0x1234, lsl #16
    movz w9, #0xEF01
    movk w9, #0xABCD, lsl #16
    extr w7, w8, w9, #4

    brk #0
