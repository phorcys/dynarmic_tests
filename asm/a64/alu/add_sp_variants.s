/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000010",
    "X1": "0x0000000000000060",
    "X2": "0x0000000000000018",
    "X3": "0x00000000000001E8"
  }
}
*/
// ADD variants using SP as base and destination.

.text
.global _start
_start:
    mov x9, sp

    sub sp, sp, #0x20
    add x10, sp, #0x10

    mov w11, #0x80
    add x12, sp, w11, uxtb

    add sp, sp, #0x8
    mov x13, sp

    add sp, sp, w11, uxtw #2
    mov x14, sp

    sub x0, x9, x10
    sub x1, x12, x9
    sub x2, x9, x13
    sub x3, x14, x9

    mov sp, x9
    brk #0
