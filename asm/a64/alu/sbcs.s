/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000002",
    "X1": "0x0000000000000004",
    "X2": "0xFFFFFFFFFFFFFFF9"
  }
}
*/
// Test: SBCS - Subtract with Carry and Set flags
// SBCS Xd, Xn, Xm: Xd = Xn - Xm - !C, sets flags

.text
.global _start
_start:
    // Test 1: SBCS with C=1 (no borrow)
    // X0 = 5 - 3 - 0 = 2
    cmp xzr, xzr      // Sets C=1 (no borrow: 0 >= 0)
    mov x0, #5
    mov x1, #3
    sbcs x2, x0, x1   // X2 = 5 - 3 - 0 = 2
    mov x0, x2        // X0 = 2
    
    // Test 2: SBCS with C=0 (borrow)
    // When C=0: subtract 1 more
    // X1 = 10 - 5 - 1 = 4
    mov x10, #0
    cmp x10, #1       // Sets C=0 (borrow: 0 < 1)
    mov x3, #10
    mov x4, #5
    sbcs x5, x3, x4   // X5 = 10 - 5 - 1 = 4
    mov x1, x5        // X1 = 4
    
    // Test 3: SBCS producing negative result
    // X2 = 3 - 10 - 0 = -7 = 0xFFFFFFFFFFFFFFF9
    cmp xzr, xzr      // C=1
    mov x6, #3
    mov x7, #10
    sbcs x2, x6, x7   // X2 = 3 - 10 - 0 = -7

    brk #0
