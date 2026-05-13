/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000040000000",
    "X1": "0x0000000080000000",
    "X2": "0x0000000040000000"
  }
}
*/
// TST 32-bit boundary coverage: zero result, negative result, disjoint masks.

.text
.global _start
_start:
    mov w10, #0
    tst w10, w10
    mrs x0, nzcv

    mov w10, #1
    lsl w10, w10, #31
    tst w10, w10
    mrs x1, nzcv

    mov w10, #0xF0
    mov w11, #0x0F
    tst w10, w11
    mrs x2, nzcv

    brk #0
