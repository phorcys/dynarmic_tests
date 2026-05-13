/* CONFIG
{
  "RegData": {
    "X0": "0x0808080808080808"
  }
}
*/
// CNT count bits per byte

.text
.global _start
_start:
    movi v0.16b, #0xFF
    cnt v0.16b, v0.16b    // each byte: 8 set bits
    mov x0, v0.d[0]
    brk #0
