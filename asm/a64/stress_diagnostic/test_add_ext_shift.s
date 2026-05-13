/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X1": "0x000000000000001C",
    "X2": "0x0000000000000010"
  }
}
*/
// Test: ADD X1, X2, X1, SXTB #2
// X2 = 16, X1 = 3 (byte = 3 when sign extended, then shifted left by 2 = 12)
// X1 = 16 + 12 = 28 = 0x1C

.text
.global _start
_start:
    mov x2, #16
    mov x1, #3
    add x1, x2, x1, sxtb #2
    brk #0
