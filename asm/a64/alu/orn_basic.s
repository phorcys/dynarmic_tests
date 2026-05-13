/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// ORN basic

.text
.global _start
_start:
    mov x0, #0
    mov x1, #0
    orn x0, x0, x1        // 0 | ~0 = -1
    brk #0
