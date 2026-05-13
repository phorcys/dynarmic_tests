/* CONFIG
{
  "RegData": {
    "X0": "0x0000000000000010"
  }
}
*/
// FCVTMS floor

.text
.global _start
_start:
    fmov s0, #16.0
    fcvtms x0, s0
    brk #0
