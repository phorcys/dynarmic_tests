/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000005",
    "X1": "0xFFFFFFFFFFFFFFFB"
  }
}
*/
// Test: NEGS Xd, Xn - negate and set flags

.text
.global _start
_start:
    mov x0, #5
    negs x1, x0           // -5 = 0xFFFFFFFFFFFFFFFB, N=1

    brk #0
