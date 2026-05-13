/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000003"
  }
}
*/
// Test: ADC Xd, Xn, Xm - Add with Carry
// Xd = Xn + Xm + C (carry flag)

.text
.global _start
_start:
    // Set carry flag
    cmp xzr, xzr       // Sets C=1
    
    mov x0, #1
    mov x1, #1
    
    // ADC: X0 = X0 + X1 + C = 1 + 1 + 1 = 3
    adc x0, x0, x1

    brk #0
