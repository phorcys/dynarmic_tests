/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000060000000",
    "X2": "0x0000000090000000"
  }
}
*/
// CMN 32-bit boundary coverage: zero, carry-out, signed overflow.

.text
.global _start
_start:
    mov w10, #0
    cmn w10, #0
    mrs x0, nzcv

    movn w10, #0
    cmn w10, #1
    mrs x1, nzcv

    mov w10, #1
    lsl w10, w10, #31
    sub w10, w10, #1          // 0x7FFFFFFF
    cmn w10, #1
    mrs x2, nzcv

    brk #0
