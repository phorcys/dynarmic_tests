/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0xFFFFFFFFFFFFFFFF"}
}
*/
.text
.global _start
_start:
    movi v0.16b, #0x0F
    movi v1.16b, #0xF0
    orr v0.16b, v0.16b, v1.16b
    mov x0, v0.d[0]
    brk #0
