/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFFFFFFFFF6",
    "X1": "0x0000000000000073"
  }
}
*/
// Test: SMSUBL Xd, Wn, Wm, Xa - Signed Multiply Subtract Long
// Xd = Xa - (Wn * Wm) [sign-extended to 64-bit]

.text
.global _start
_start:
    // Test 1: 10 - (5 * 4) = 10 - 20 = -10
    mov w0, #5
    mov w1, #4
    mov x2, #10
    smsubl x3, w0, w1, x2
    mov x0, x3  // X0 = -10 (0xFFFFFFFFFFFFFFF6)
    
    // Test 2: 100 - (-5 * 3) = 100 - (-15) = 115
    mov w4, #5
    neg w4, w4   // w4 = -5
    mov w5, #3
    mov x6, #100
    smsubl x7, w4, w5, x6
    mov x1, x7  // X1 = 115 (0x73)

    brk #0
