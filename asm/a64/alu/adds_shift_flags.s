/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x8000000000000001",
    "X3": "0x0000000080000000",
    "X4": "0x0000000080000000",
    "X5": "0x0000000090000000",
    "X6": "0x00000000FFFFFFFF",
    "X7": "0x0000000080000000"
  }
}
*/
// ADDS shifted-register coverage including 32-bit signed overflow.

.text
.global _start
_start:
    mov x0, #1
    mov x1, #1
    adds x2, x0, x1, lsl #63
    mrs x3, nzcv

    mov w0, #1
    lsl w0, w0, #30            // 0x40000000
    mov w1, #1
    adds w4, w0, w1, lsl #30   // 0x40000000 + 0x40000000 = 0x80000000
    mrs x5, nzcv

    mov w0, #0x80000000
    adds w6, wzr, w0, asr #31  // 0 + (-1) = -1
    mrs x7, nzcv

    brk #0
