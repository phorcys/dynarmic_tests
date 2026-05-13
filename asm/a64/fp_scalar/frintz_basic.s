/* CONFIG
{
  "RegData": {
    "X0": "0x0000000041800000"
  }
}
*/
// FRINTZ truncate

.text
.global _start
_start:
    fmov s0, #16.0
    frintz s0, s0
    fmov w0, s0
    brk #0
