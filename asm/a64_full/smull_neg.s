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
    mov w1, #0xFFFFFFF0  // -16
    mov w2, #1
    smull x0, w1, w2     // -16 * 1 = -16
    brk #0

