/* CONFIG
{
  "Match": "All",
  "RegData": {"X0": "0x0000000000000006"}
}
*/
.text
.global _start
_start:
    mov w0, #2
    mov w1, #3
    mul w0, w0, w1
    brk #0
