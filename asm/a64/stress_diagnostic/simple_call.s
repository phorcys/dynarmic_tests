/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000001" }
}
*/
.text
.global _start
_start:
    mov x0, #0
    bl increment
    brk #0

increment:
    add x0, x0, #1
    ret
