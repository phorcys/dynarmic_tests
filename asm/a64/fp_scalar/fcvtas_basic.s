/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000011"
  }
}
*/
// FCVTAS round to nearest

.text
.global _start
_start:
    fmov s0, #17.0
    fcvtas x0, s0
    brk #0
