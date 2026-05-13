/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/
// NEG zero

.text
.global _start
_start:
    mov x0, #0
    neg x0, x0            // -0 = 0
    brk #0
