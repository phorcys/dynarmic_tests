/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FFFF",
    "X1": "0xFFFFFFFFFFFFFFFF",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: LDURSH - load signed halfword (unscaled)

.text
.global _start
_start:
    sub sp, sp, #16
    mov w0, #0xFFFF
    strh w0, [sp]
    ldursh x1, [sp]
    // x1 = -1 (sign extended)
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0
    add sp, sp, #16

    brk #0
