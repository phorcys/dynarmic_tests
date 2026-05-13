/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000000006"
  }
}
*/
// Test: UMSUBL Xd, Wn, Wm, Xa - Unsigned Multiply Subtract Long
// Xd = Xa - (Wn * Wm) [zero-extended to 64-bit]

.text
.global _start
_start:
    // Test 1: 20 - (5 * 4) = 20 - 20 = 0
    mov w0, #5
    mov w1, #4
    mov x2, #20
    umsubl x3, w0, w1, x2
    mov x0, x3  // X0 = 0
    
    // Test 2: 100 - (47 * 2) = 100 - 94 = 6
    mov w4, #47
    mov w5, #2
    mov x6, #100
    umsubl x7, w4, w5, x6
    mov x1, x7  // X1 = 6

    brk #0
