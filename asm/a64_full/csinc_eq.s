/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000AA"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xAA
    cmp xzr, xzr
    csinc x0, x0, xzr, eq  // if Z=1: x0 = x0
    brk #0

