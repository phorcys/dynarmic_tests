/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000001000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000FFF001",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000060000000",
    "X7": "0x0000000080000000",
    "X8": "0x0000000090000000"
  }
}
*/
// ADDS immediate boundary coverage for 64-bit and 32-bit forms.

.text
.global _start
_start:
    mov x0, #1
    adds x1, x0, #4095
    mrs x2, nzcv

    mov x0, #1
    adds x3, x0, #4095, lsl #12
    mrs x4, nzcv

    mov w0, #0xFFFFFFFF
    adds w5, w0, #1
    mrs x6, nzcv

    mov w0, #1
    lsl w0, w0, #31
    sub w0, w0, #1
    adds w7, w0, #1
    mrs x8, nzcv

    brk #0
