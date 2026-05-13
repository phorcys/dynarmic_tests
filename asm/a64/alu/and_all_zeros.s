/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// AND all zeros

.text
.global _start
_start:
    mov x0, #-1
    mov x1, #0
    and x0, x0, x1        // -1 & 0 = 0
    brk #0
