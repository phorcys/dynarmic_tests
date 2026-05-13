/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000000000"
  }
}
*/
// Test: ANDS - AND immediate and set flags

.text
.global _start
_start:
    mov x0, #0xFF
    ands x0, x0, #0x01    // 0xFF & 0x01 = 0x01, Z=0
    mov x1, #0
    adc x1, xzr, xzr      // Get C flag

    brk #0
