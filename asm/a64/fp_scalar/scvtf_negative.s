/* CONFIG
{
  "RegData": {
    "X0": "0x00000000C1800000"
  }
}
*/
// SCVTF negative

.text
.global _start
_start:
    mov x0, #-16
    scvtf s0, x0
    fmov w0, s0
    brk #0
