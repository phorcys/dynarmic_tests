/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    mov x1, #1
    subs x2, x0, #1      // Set C=0 (borrow)
    sbc x0, x0, xzr      // x0 = 0 - 0 - 1 = -1 = 0xFFFFFFFFFFFFFFFF
    sbc x1, xzr, xzr     // x1 = 0 - 0 - 1 = -1 (still borrowing)
    brk #0

