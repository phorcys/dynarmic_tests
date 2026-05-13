/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF6"
  }
}
*/

.text
.global _start
_start:
    mov x0, #10
    neg x0, x0
    brk #0

