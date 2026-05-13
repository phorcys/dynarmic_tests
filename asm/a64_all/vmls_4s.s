/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFBFFFFFFFB"
  }
}
*/

.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    movi v2.4s, #3
    mls v0.4s, v1.4s, v2.4s
    mov x0, v0.d[0]
    brk #0

