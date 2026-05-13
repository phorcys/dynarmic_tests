/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000",
    "X1": "0x80000000",
    "X2": "0x80000000",
    "X3": "0x90000000",
    "X4": "0x00000000"
  },
  "VecData": {}
}
*/
.arch armv8.4-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // CCMN (immediate) - Conditional Compare Negative (immediate)
    // CCMN Xn, #imm, #nzcv, cond
    // If condition true: compare Xn with -imm, set NZCV
    // If condition false: set NZCV to immediate #nzcv
    // 
    // CCMN Xn, #imm = CMP Xn, -imm
    // For CMP a, -b: result = a - (-b) = a + b
    // This is equivalent to ADDS result = a + b
    // ========================================

    // Test 0: CCMN with condition true (EQ)
    // CCMN 5, #3, #0, eq -> CMP 5, -3 = 5 + 3 = 8
    // N=0, Z=0, C=0 (for adds, C is carry out), V=0
    // Result: 8, N=0, Z=0, C=0, V=0 -> 0x00000000
    mov x10, #5
    cmp x10, x10          // Sets Z=1 (equal)
    ccmn x10, #3, #0, eq  // Compare 5 with -3
    mrs x0, nzcv          // Expected: 0x00000000

    // Test 1: CCMN with condition false (NE)
    // Should set NZCV to immediate #0x8
    mov x10, #5
    cmp x10, x10          // Sets Z=1 (equal)
    ccmn x10, #3, #0x8, ne  // Condition false, use immediate
    mrs x1, nzcv          // Expected: 0x80000000

    // Test 2: CCMN with addition that produces negative
    // CCMN -10, #5, #0, eq -> CMP -10, -5 = -10 + 5 = -5
    // Result: -5, N=1, Z=0, C=0, V=0 -> 0x80000000
    mov x10, #-10
    cmp x10, x10          // Sets Z=1
    ccmn x10, #5, #0, eq  // Compare -10 with -5
    mrs x2, nzcv          // Expected: 0x80000000

    // Test 3: CCMN with GT condition false
    mov x10, #1
    lsl x10, x10, #63     // MIN_SIGNED64
    mov x11, #0
    cmp x10, x11          // MIN < 0, N=1, GT=false
    ccmn x10, #0, #0x9, gt  // Condition false, use immediate
    mrs x3, nzcv          // Expected: 0x90000000

    // Test 4: CCMN with zero immediate
    // CCMN 5, #0, #0, eq -> CMP 5, 0 = 5
    // Result: 5, N=0, Z=0, C=0, V=0 -> 0x00000000
    mov x10, #5
    cmp x10, x10          // Z=1
    ccmn x10, #0, #0, eq  // Compare 5 with 0
    mrs x4, nzcv          // Expected: 0x00000000

    brk #0