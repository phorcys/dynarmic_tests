/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF55"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xAA
    mov x2, #1
    cmp x2, #0  // NE
    csinv x0, x0, xzr, ne
    brk #0

