/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000000000",
    "X2": "0x0000000060000000",
    "X3": "0x00000000FFFFFFFF",
    "X4": "0x0000000080000000",
    "X5": "0x0000000080000000",
    "X6": "0x0000000090000000"
  }
}
*/
// NEGS 32-bit coverage for zero, negative one, and signed overflow.

.text
.global _start
_start:
    mov w0, #0
    negs w1, w0
    mrs x2, nzcv

    mov w0, #1
    negs w3, w0
    mrs x4, nzcv

    mov w0, #1
    lsl w0, w0, #31
    negs w5, w0
    mrs x6, nzcv

    brk #0
