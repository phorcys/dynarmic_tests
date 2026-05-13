/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// AND all ones

.text
.global _start
_start:
    mov x0, #-1
    mov x1, #-1
    and x0, x0, x1        // -1 & -1 = -1
    brk #0
