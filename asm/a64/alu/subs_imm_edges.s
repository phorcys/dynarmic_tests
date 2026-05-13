/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000000001",
    "X2": "0x0000000020000000",
    "X3": "0x0000000000000001",
    "X4": "0x0000000020000000",
    "X5": "0x00000000FFFFFFFF",
    "X6": "0x0000000080000000",
    "X7": "0x000000007FFFFFFF",
    "X8": "0x0000000030000000"
  }
}
*/
// SUBS immediate boundary coverage for 64-bit and 32-bit forms.

.text
.global _start
_start:
    mov x0, #0
    add x0, x0, #4095
    subs x1, x0, #4094
    mrs x2, nzcv

    mov x0, #1
    add x0, x0, #4095, lsl #12
    subs x3, x0, #4095, lsl #12
    mrs x4, nzcv

    mov w0, #0
    subs w5, w0, #1
    mrs x6, nzcv

    mov w0, #1
    lsl w0, w0, #31
    subs w7, w0, #1
    mrs x8, nzcv

    brk #0
