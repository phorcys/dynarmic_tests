/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/

.text
.global _start
_start:
    mov x0, #5
    mov x1, #2
    sub x0, x0, x1
    brk #0

