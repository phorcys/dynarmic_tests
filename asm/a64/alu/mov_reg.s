/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x0000000000001234"
  }
}
*/
// Test: MOV Xd, Xn - move register

.text
.global _start
_start:
    movz x0, #0x1234
    mov x1, x0

    brk #0
