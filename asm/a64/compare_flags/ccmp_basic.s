/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000000A",
    "X1": "0x0000000080000000",
    "X2": "0x0000000000000000",
    "X3": "0x0000000000000000",
    "X4": "0x0000000000000000",
    "X5": "0x0000000000000000",
    "X6": "0x0000000000000000",
    "X7": "0x0000000000000000"
  }
}
*/
// Test: CCMP - conditional compare

.text
.global _start
_start:
    mov x0, #10
    cmp x0, #5
    // N=0, Z=0, C=1, V=0 (10 > 5)
    ccmp x0, #15, #0, gt
    // Since 10 > 5, compare 10 vs 15
    // N=1, Z=0, C=0, V=0 (10 < 15)
    mrs x1, nzcv
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
