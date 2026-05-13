/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0
    cmp xzr, xzr        // Z=1
    csinc x0, x0, xzr, ne  // if Z=0: x0 = xzr + 1 = 1; else x0 = x0
    brk #0

