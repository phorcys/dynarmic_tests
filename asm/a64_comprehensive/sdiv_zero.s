/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000"
  }
}
*/

.text
.global _start
_start:
    mov x0, #42
    mov x1, #0
    sdiv x0, x0, x1   // 除零 = 0
    brk #0

