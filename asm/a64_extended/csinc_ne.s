/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000AB"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0xAA
    mov x2, #1
    cmp x2, #0  // NE
    csinc x0, x0, xzr, ne
    brk #0

