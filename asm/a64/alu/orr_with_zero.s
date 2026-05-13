/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// ORR with zero

.text
.global _start
_start:
    mov x0, #-1
    mov x1, #0
    orr x0, x0, x1        // -1 | 0 = -1
    brk #0
