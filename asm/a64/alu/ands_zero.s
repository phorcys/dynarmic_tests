/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000000"
  }
}
*/
// Test: ANDS - result zero sets Z flag

.text
.global _start
_start:
    mov x0, #0xFF
    mov x1, #0
    ands x0, x0, x1       // 0xFF & 0 = 0, Z=1, C=0
    mov x1, #0
    adc x1, xzr, xzr      // Get C flag (should be 0)

    brk #0
