/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x1111111111111111",
    "X1": "0x2222222222222222",
    "X2": "0x1111111111111111",
    "X3": "0x2222222222222222",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: LDP/STP - basic load/store pair

.text
.global _start
_start:
    sub sp, sp, #32
    mov x0, #0x1111111111111111
    mov x1, #0x2222222222222222
    stp x0, x1, [sp]
    ldp x2, x3, [sp]
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0
    add sp, sp, #32

    brk #0
