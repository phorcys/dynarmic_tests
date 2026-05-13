/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000F0",
    "X1": "0x0000000000000000"
  }
}
*/
// Test: BICS - Bit Clear and set flags

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0x0F
    bics x0, x0, x1       // 0xFF & ~0x0F = 0xF0
    mov x1, #0
    adc x1, xzr, xzr      // Get C flag

    brk #0
