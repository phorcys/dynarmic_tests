/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0006000600060006"
  }
}
*/

.text
.global _start
_start:
    movi v0.8h, #2
    movi v1.8h, #3
    mul v0.8h, v0.8h, v1.8h
    mov x0, v0.d[0]
    brk #0

