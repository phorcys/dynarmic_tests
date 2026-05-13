/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001111",
    "X1": "0x0000000000002222",
    "X3": "0x0000000000001111",
    "X4": "0x0000000000002222",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: LDP - post-index
// x2 is stack-dependent, not checked

.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1111
    mov x1, #0x2222
    stp x0, x1, [sp]
    mov x2, sp
    ldp x3, x4, [x2], #16
    // x3 = 0x1111, x4 = 0x2222, x2 = sp + 16 (not verified)
    mov x5, #0
    mov x6, #0
    mov x7, #0
    add sp, sp, #32

    brk #0
