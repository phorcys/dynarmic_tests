/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000007",
    "X1": "0x0000000000000000"
  }
}
*/
// Test: ADDS - Add and set flags

.text
.global _start
_start:
    mov x0, #5
    adds x0, x0, #2      // 5 + 2 = 7, no carry
    mov x1, #0
    adc x1, xzr, xzr     // Get C flag (should be 0)

    brk #0
