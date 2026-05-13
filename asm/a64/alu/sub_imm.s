/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000007"
  }
}
*/
// Test: SUB (immediate) - basic immediate subtraction

.text
.global _start
_start:
    mov x0, #10
    sub x0, x0, #3
    brk #0
