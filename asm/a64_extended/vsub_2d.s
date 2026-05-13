/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFF"
  }
}
*/

.text
.global _start
_start:
    movi v0.2d, #1
    movi v1.2d, #2
    sub v0.2d, v0.2d, v1.2d
    mov x0, v0.d[0]
    brk #0

