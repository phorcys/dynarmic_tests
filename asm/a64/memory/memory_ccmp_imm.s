/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000014",
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
// Test: CCMP - conditional compare immediate

.text
.global _start
_start:
    mov x0, #20
    cmp x0, #10
    // N=0, Z=0, C=1, V=0 (20 > 10)
    ccmp x0, #15, #0, le
    // Since NOT (20 <= 10), use fallback flags #0
    // NZCV = 0
    mrs x1, nzcv
    mov x2, #0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0

    brk #0
