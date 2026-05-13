/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x0000000000000000",
    "X2": "0x0000000060000000",
    "X3": "0xFFFFFFFFFFFFFFFF",
    "X4": "0x0000000080000000",
    "X5": "0x8000000000000000",
    "X6": "0x0000000090000000"
  }
}
*/
// NEGS 64-bit coverage for zero, negative one, and signed overflow.

.text
.global _start
_start:
    mov x0, #0
    negs x1, x0
    mrs x2, nzcv

    mov x0, #1
    negs x3, x0
    mrs x4, nzcv

    mov x0, #1
    lsl x0, x0, #63
    negs x5, x0
    mrs x6, nzcv

    brk #0
