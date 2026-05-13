/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A",
    "X1": "0x0000000000000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: CCMN - conditional compare negative

.text
.global _start
_start:
    mov x0, #10
    cmn x0, #5
    // Compare x0 + 5 = 15, N=0, Z=0, C=0, V=0
    ccmn x0, #10, #0, ne
    // Since 15 != 0, compare x0 + 10 = 20
    // N=0, Z=0, C=0, V=0
    mrs x1, nzcv
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
