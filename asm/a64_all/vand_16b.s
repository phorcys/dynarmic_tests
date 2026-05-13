/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xF0F0F0F0F0F0F0F0"
  }
}
*/

.text
.global _start
_start:
    movi v0.16b, #0xFF
    movi v1.16b, #0xF0
    and v0.16b, v0.16b, v1.16b
    mov x0, v0.d[0]
    brk #0

