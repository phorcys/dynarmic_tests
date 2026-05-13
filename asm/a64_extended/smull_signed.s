/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFF9A"
  }
}
*/

.text
.global _start
_start:
    mov w0, #-100
    mov w1, #1
    smull x0, w0, w1
    brk #0

