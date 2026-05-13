/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0xFFFFFFFFFFFFFFFB"
  }
}
*/
// Test: NEG Xd, Xn - negate

.text
.global _start
_start:
    mov x0, #5
    neg x1, x0            // -5 = 0xFFFFFFFFFFFFFFFB

    brk #0
