/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// SMULH basic

.text
.global _start
_start:
    mov x0, #0x7FFFFFFFFFFFFFFF  // max signed
    mov x1, #1
    smulh x0, x0, x1      // high 64 bits of signed multiply
    brk #0
