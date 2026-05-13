/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFE0001"
  }
}
*/

.text
.global _start
_start:
    mov w1, #0xFFFF
    mov w2, #1
    smull x0, w1, w2   // -1 * 1 = -1 (sign extended)
    brk #0

