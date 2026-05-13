/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/

.text
.global _start
_start:
    movi v0.16b, #0xFF
    movi v1.16b, #0xFF
    eor v0.16b, v0.16b, v1.16b
    mov x0, v0.d[0]
    brk #0

