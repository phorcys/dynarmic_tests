/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000011223344",
    "X1": "0x0000000055667788",
    "X2": "0x0000000000000008",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000008"
  }
}
*/
// STP/LDP with W registers and indexed addressing.

.text
.global _start
_start:
    mov w0, #0x3344
    movk w0, #0x1122, lsl #16
    mov w1, #0x7788
    movk w1, #0x5566, lsl #16

    mov x5, sp
    mov x2, sp
    stp w0, w1, [x2, #8]!
    sub x2, x2, x5

    mov x3, sp
    ldp w0, w1, [x3, #8]!
    sub x4, x3, x5
    mov x3, #0

    brk #0
