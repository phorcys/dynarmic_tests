/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x80000000",
    "X1": "0x60000000",
    "X2": "0x20000000",
    "X3": "0x30000000",
    "X4": "0x80000000",
    "X5": "0x60000000",
    "X6": "0x20000000",
    "X7": "0x30000000"
  },
  "VecData": {}
}
*/
.arch armv8.4-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // FCMP single precision tests
    // ========================================

    // Test 1: FCMP S0 < S1 (1.0 < 2.0) -> Less
    mov w10, #0x3F800000      // 1.0 in IEEE 754
    mov w11, #0x40000000      // 2.0 in IEEE 754
    fmov s0, w10
    fmov s1, w11
    fcmp s0, s1               // 1.0 < 2.0 -> Less
    mrs x0, nzcv              // Expected: 0x80000000 (N=1)

    // Test 2: FCMP S0 == S0 (1.0 == 1.0) -> Equal
    fcmp s0, s0               // 1.0 == 1.0 -> Equal
    mrs x1, nzcv              // Expected: 0x60000000 (Z=1, C=1)

    // Test 3: FCMP S1 > S0 (2.0 > 1.0) -> Greater
    fcmp s1, s0               // 2.0 > 1.0 -> Greater
    mrs x2, nzcv              // Expected: 0x20000000 (C=1)

    // Test 4: FCMP with NaN -> Unordered
    mov w12, #0x7FC00000      // quiet NaN
    fmov s2, w12
    fcmp s2, s0               // NaN vs 1.0 -> Unordered
    mrs x3, nzcv              // Expected: 0x30000000 (C=1, V=1)

    // ========================================
    // FCMP double precision tests
    // ========================================

    // Test 5: FCMP D3 < D4 (1.5 < 3.0) -> Less
    mov x10, #0x3FF8000000000000   // 1.5 in IEEE 754 double
    mov x11, #0x4008000000000000   // 3.0 in IEEE 754 double
    fmov d3, x10
    fmov d4, x11
    fcmp d3, d4               // 1.5 < 3.0 -> Less
    mrs x4, nzcv              // Expected: 0x80000000

    // Test 6: FCMP D3 == D3 -> Equal
    fcmp d3, d3               // 1.5 == 1.5 -> Equal
    mrs x5, nzcv              // Expected: 0x60000000

    // Test 7: FCMP D4 > D3 -> Greater
    fcmp d4, d3               // 3.0 > 1.5 -> Greater
    mrs x6, nzcv              // Expected: 0x20000000

    // Test 8: FCMP with NaN (double) -> Unordered
    mov x12, #0x7FF8000000000000   // quiet NaN double
    fmov d5, x12
    fcmp d5, d3               // NaN vs 1.5 -> Unordered
    mrs x7, nzcv              // Expected: 0x30000000

    brk #0
