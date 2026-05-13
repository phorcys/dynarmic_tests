/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x80000000",
    "X1": "0xF0000000",
    "X2": "0x60000000",
    "X3": "0x00000000",
    "X4": "0x80000000",
    "X5": "0x80000000",
    "X6": "0x60000000"
  }
}
*/
// Test: FCCMP - Floating-point Conditional Compare
// FCCMP Sn, Sm, #nzcv, cond
// If condition is true: perform FCMP Sn, Sm and set flags
// If condition is false: set NZCV to the immediate nzcv value
//
// ARM64 FP Compare flags:
// Sn < Sm: N=1, Z=0, C=0, V=0 -> 0x80000000
// Sn == Sm: N=0, Z=1, C=1, V=0 -> 0x60000000
// Sn > Sm: N=0, Z=0, C=1, V=0 -> 0x20000000
// Unordered (NaN): N=0, Z=0, C=1, V=1 -> 0x30000000

.text
.global _start
_start:
    // Setup: Load S0 = 3.0, S1 = 4.0
    mov w0, #0x4040
    movk w0, #0x0000, lsl #16    // 3.0 in IEEE 754
    fmov s0, w0
    
    mov w1, #0x4080
    movk w1, #0x0000, lsl #16    // 4.0 in IEEE 754
    fmov s1, w1
    
    // Setup: Load S2 = 3.0 (same as S0)
    fmov s2, w0

    // Test 1: FCCMP with condition true (EQ after CMP XZR, XZR)
    // 3.0 < 4.0 -> N=1 (less than)
    mov x10, #0
    msr nzcv, x10                 // Clear flags
    cmp xzr, xzr                  // Set Z=1 (EQ condition)
    fccmp s0, s1, #0, eq          // Condition true, compare 3.0 vs 4.0
    mrs x0, nzcv                  // Should be N=1 (0x80000000) because 3.0 < 4.0

    // Test 2: FCCMP with condition false (NE after CMP XZR, XZR)
    // Condition false -> use immediate nzcv = #0xF
    mov x10, #0
    msr nzcv, x10
    cmp xzr, xzr                  // Z=1, so NE is false
    fccmp s0, s1, #0xf, ne        // Condition false, set NZCV = 0xF (N=1, Z=1, C=1, V=1)
    mrs x1, nzcv                  // Should be 0x80000000 (N=1 in FCCMP result)

    // Test 3: FCCMP with equal values, condition true
    // 3.0 == 3.0 -> Z=1
    mov x10, #0
    msr nzcv, x10
    cmp xzr, xzr                  // Z=1 (EQ)
    fccmp s0, s2, #0, eq          // Compare 3.0 vs 3.0
    mrs x2, nzcv                  // Should be Z=1 (0x40000000)

    // Test 4: FCCMP with condition false (CS when C=0)
    // C=0, so CS is false
    mov x10, #0
    msr nzcv, x10
    mov x11, #1
    cmp x11, #2                   // 1 < 2, C=0 (borrow)
    fccmp s1, s0, #0x0, cs        // Condition false, NZCV = 0
    mrs x3, nzcv                  // Should be 0x00000000

    // Test 5: FCCMP with condition MI (N=1)
    mov x10, #0x80000000
    msr nzcv, x10                 // Set N=1
    fccmp s0, s1, #0x4, mi        // Condition true (N=1), compare 3.0 vs 4.0
    mrs x4, nzcv                  // N=1 (less than)

    // Test 6: FCCMP with condition PL (N=0)
    mov x10, #0                   // N=0
    msr nzcv, x10
    fccmp s0, s1, #0x6, pl        // Condition true (N=0), compare 3.0 vs 4.0
    mrs x5, nzcv                  // N=1 (less than)

    // Test 7: FCCMP with condition false, use immediate
    mov x10, #0
    msr nzcv, x10
    mov x11, #1
    cmp x11, #2                   // Set C=0 (borrow), so CS is false
    fccmp s0, s1, #0x6, cs        // Condition false, set NZCV = 0x6 (Z=1, C=1)
    mrs x6, nzcv                  // Should be 0x60000000

    brk #0
