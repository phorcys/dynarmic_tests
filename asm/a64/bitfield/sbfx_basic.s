/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/
// SBFX basic

.text
.global _start
_start:
    mov x0, #-1
    sbfx x0, x0, #0, #8    // extract 8 bits, sign extend
    brk #0
