/* CONFIG
{
  "RegData": {
    "X0": "0x0000000041800000"
  }
}
*/
// FRINTN round nearest

.text
.global _start
_start:
    fmov s0, #16.0
    frintn s0, s0
    fmov w0, s0
    brk #0
