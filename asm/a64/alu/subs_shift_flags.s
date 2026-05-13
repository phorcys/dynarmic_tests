/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X2": "0x8000000000000000",
    "X3": "0x0000000090000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000060000000",
    "X6": "0x0000000000000001",
    "X7": "0x0000000000000000"
  }
}
*/
// SUBS shifted-register coverage including reverse-sub style edge cases.

.text
.global _start
_start:
    mov x0, #1
    subs x2, xzr, x0, lsl #63
    mrs x3, nzcv

    mov w0, #1
    mov w1, #0x80000000
    subs w4, w0, w1, lsr #31
    mrs x5, nzcv

    mov w0, #0x80000000
    subs w6, wzr, w0, asr #31
    mrs x7, nzcv

    brk #0
