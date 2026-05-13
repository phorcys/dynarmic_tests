/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/
// Test: SUBS (immediate) - basic immediate subtraction with flags

.text
.global _start
_start:
    mov x0, #10
    subs x0, x0, #7
    brk #0
