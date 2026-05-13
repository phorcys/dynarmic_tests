/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000008",
    "X1": "0x0000000000000002",
    "X2": "0x0000000000000002"
  }
}
*/
// Test: ROR Xd, Xn, Xm - rotate right by register

.text
.global _start
_start:
    mov x0, #8
    mov x1, #2
    ror x2, x0, x1       // rotate 8 right by 2 bits = 2

    brk #0
