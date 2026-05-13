/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000AAAA",
    "X1": "0x000000000000BBBB",
    "X3": "0x000000000000AAAA",
    "X4": "0x000000000000BBBB",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: STP - pre-index
// x2 is stack-dependent, not checked

.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0xAAAA
    mov x1, #0xBBBB
    mov x2, sp
    stp x0, x1, [x2, #-16]!
    ldp x3, x4, [x2]
    mov x5, #0
    mov x6, #0
    mov x7, #0
    add sp, sp, #32

    brk #0
