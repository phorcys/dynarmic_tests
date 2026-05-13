/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #1
    subs xzr, x0, #1  // Set C=1
    sbc x0, x0, x0    // x0 = 1 - 1 - (1-C) = 0
    brk #0

