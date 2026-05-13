/* CONFIG
{
  "RegData": {
    "S0": "0x00000002"
  }
}
*/
// Denormal + Denormal

.text
.global _start
_start:
    mov w0, #1
    fmov s0, w0
    fadd s0, s0, s0
    brk #0
