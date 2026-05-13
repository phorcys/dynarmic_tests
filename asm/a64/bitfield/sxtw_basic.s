/* CONFIG
{
  "RegData": {
    "X0": "0xFFFFFFFF80000000"
  }
}
*/
// SXTW sign extend word

.text
.global _start
_start:
    mov w0, #0x80000000
    sxtw x0, w0           // sign extend word: 0x80000000 -> 0xFF...80000000
    brk #0
