/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// UMULH basic

.text
.global _start
_start:
    mov x0, #0xFFFFFFFFFFFFFFFF  // max unsigned
    mov x1, #1
    umulh x0, x0, x1      // high 64 bits
    brk #0
