/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// CSET false

.text
.global _start
_start:
    mov x0, #5
    cmp x0, #10
    cset x0, gt         // if 5 > 10 (false), set 0
    brk #0
