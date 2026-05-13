/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
}
*/
.text
.global _start
_start:
    movi v0.4s, #1
    movi v1.4s, #2
    sub v0.4s, v0.4s, v1.4s
    mov x0, v0.d[0]
    brk #0
