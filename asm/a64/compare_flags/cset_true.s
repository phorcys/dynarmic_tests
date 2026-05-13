/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000001"
  }
}
*/
// CSET true

.text
.global _start
_start:
    mov x0, #5
    cmp x0, #3
    cset x0, gt         // if 5 > 3, set 1
    brk #0
