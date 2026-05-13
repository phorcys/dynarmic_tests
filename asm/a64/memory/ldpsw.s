/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000FFFFFFFF",
    "X1": "0x0000000080000000",
    "X2": "0xFFFFFFFFFFFFFFFF",
    "X3": "0xFFFFFFFF80000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: LDPSW - load pair signed word

.text
.global _start
_start:
    sub sp, sp, #32
    mov w0, #0xFFFFFFFF
    mov w1, #0x80000000
    stp w0, w1, [sp]
    ldpsw x2, x3, [sp]
    // x2 = -1, x3 = -2147483648 (sign extended)
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0
    add sp, sp, #32

    brk #0
