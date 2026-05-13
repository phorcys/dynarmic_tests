/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: SUBS - Subtract and set flags

.text
.global _start
_start:
    mov x0, #5
    subs x0, x0, #2      // 5 - 2 = 3, no borrow
    mov x1, #0
    adc x1, xzr, xzr     // Get C flag (should be 1 for no borrow)

    brk #0
