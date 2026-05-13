/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000002F0",
    "X1": "0x0000000000000280",
    "X2": "0x00000000000002F8",
    "X3": "0x00000000000000F8"
  }
}
*/
// SUB variants using SP as base and destination.

.text
.global _start
_start:
    mov x9, sp

    add sp, sp, #0x300
    sub x10, sp, #0x10

    mov w11, #0x80
    sub x12, sp, w11, uxtb

    sub sp, sp, #0x8
    mov x13, sp

    sub sp, sp, w11, uxtw #2
    mov x14, sp

    sub x0, x10, x9
    sub x1, x12, x9
    sub x2, x13, x9
    sub x3, x14, x9

    mov sp, x9
    brk #0
