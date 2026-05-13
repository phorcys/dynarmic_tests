/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000400000004"
  }
}
*/

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    sshl v0.4s, v0.4s, v1.4s
    mov x0, v0.d[0]
    brk #0

