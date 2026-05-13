/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF80"
  }
}
*/
// SXTB sign extend byte

.text
.global _start
_start:
    mov w0, #0x80
    sxtb x0, w0           // sign extend byte: 0x80 -> 0xFF...80
    brk #0
