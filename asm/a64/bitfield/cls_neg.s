/* CONFIG
{
  "RegData": {
    "X0": "0x000000000000003E"
  }
}
*/
// CLS negative

.text
.global _start
_start:
    mov x0, #-2
    cls x0, x0            // 62 sign bits match (all 1s except MSB pair)
    brk #0
