/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000001"
  }
}
*/
// Test: ADDS with carry

.text
.global _start
_start:
    mov x0, #0xFFFFFFFFFFFFFFFF
    adds x0, x0, #1      // 0xFFFFFFFFFFFFFFFF + 1 = 0 with carry
    mov x1, #0
    adc x1, xzr, xzr     // Get C flag (should be 1)

    brk #0
