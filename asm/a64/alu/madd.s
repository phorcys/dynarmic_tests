/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000008"
  }
}
*/
// Test: MADD Xd, Xn, Xm, Xa - Multiply-Add
// Xd = Xa + Xn * Xm

.text
.global _start
_start:
    // 2 + 3 * 2 = 8
    mov x1, #3       // multiplicand
    mov x2, #2       // multiplier
    mov x3, #2       // accumulator
    
    madd x0, x1, x2, x3   // X0 = 2 + 3 * 2 = 8

    brk #0