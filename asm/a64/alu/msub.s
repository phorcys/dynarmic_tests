/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFFC"
  }
}
*/
// Test: MSUB Xd, Xn, Xm, Xa - Multiply-Subtract
// Xd = Xa - Xn * Xm

.text
.global _start
_start:
    // 2 - 3 * 2 = -4
    mov x1, #3       // multiplicand
    mov x2, #2       // multiplier
    mov x3, #2       // accumulator
    
    msub x0, x1, x2, x3   // X0 = 2 - 3 * 2 = -4

    brk #0