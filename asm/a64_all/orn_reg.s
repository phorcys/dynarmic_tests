/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF0"
  }
}
*/

.text
.global _start
_start:
    mov x0, #0x00
    mov x1, #0x0F
    orn x0, x0, x1
    brk #0

