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
    mov w1, #0xFFFFFFFF  // -1
    mov w2, #1
    smull x0, w1, w2
    brk #0

