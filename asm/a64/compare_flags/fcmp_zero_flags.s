/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x20000000",
    "X1": "0x80000000",
    "X2": "0x60000000",
    "X3": "0x30000000",
    "X4": "0x20000000",
    "X5": "0x80000000",
    "X6": "0x60000000",
    "X7": "0x30000000"
  },
  "VecData": {}
}
*/
.arch armv8.5-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // FCMP/FCMPE with zero - Floating-point Compare with Zero
    // FCMP Sn, #0.0 - Compare with zero
    // FCMPD Sn, #0.0 - Compare double with zero
    // 
    // Result flags:
    // Less than zero:    N=1, Z=0, C=0, V=0 -> 0x80000000
    // Equal to zero:     N=0, Z=1, C=1, V=0 -> 0x60000000
    // Greater than zero: N=0, Z=0, C=1, V=0 -> 0x20000000
    // Unordered (NaN):   N=0, Z=0, C=1, V=1 -> 0x30000000
    // ========================================

    // === Single precision (32-bit) tests ===

    // Test 0: FCMP positive with zero
    // 1.5 > 0 -> Greater
    fmov s0, #1.5
    fcmp s0, #0.0
    mrs x0, nzcv          // Expected: 0x20000000 (Greater)

    // Test 1: FCMP negative with zero
    // -1.5 < 0 -> Less
    fmov s1, #-1.5
    fcmp s1, #0.0
    mrs x1, nzcv          // Expected: 0x80000000 (Less)

    // Test 2: FCMP zero with zero
    // 0.0 == 0.0 -> Equal
    movi v2.2s, #0        // Set to zero
    fcmp s2, #0.0
    mrs x2, nzcv          // Expected: 0x60000000 (Equal)

    // Test 3: FCMP NaN with zero
    // NaN vs 0 -> Unordered
    mov w21, #0x7FC00000    // Quiet NaN
    fmov s3, w21
    fcmp s3, #0.0
    mrs x3, nzcv          // Expected: 0x30000000 (Unordered)

    // === Double precision (64-bit) tests ===

    // Test 4: FCMPD positive with zero
    fmov d4, #1.5
    fcmp d4, #0.0
    mrs x4, nzcv          // Expected: 0x20000000 (Greater)

    // Test 5: FCMPD negative with zero
    fmov d5, #-1.5
    fcmp d5, #0.0
    mrs x5, nzcv          // Expected: 0x80000000 (Less)

    // Test 6: FCMPD zero with zero
    movi v6.2d, #0        // Set to zero
    fcmp d6, #0.0
    mrs x6, nzcv          // Expected: 0x60000000 (Equal)

    // Test 7: FCMPD NaN with zero
    mov x21, #0x7FF8000000000000    // Quiet NaN (double)
    fmov d7, x21
    fcmp d7, #0.0
    mrs x7, nzcv          // Expected: 0x30000000 (Unordered)

    brk #0