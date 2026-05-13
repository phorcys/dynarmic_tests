/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000007"
  }
}
*/
// Test: ADDS (immediate) - basic immediate addition with flags

.text
.global _start
_start:
    mov x0, #5
    adds x0, x0, #2
    brk #0
