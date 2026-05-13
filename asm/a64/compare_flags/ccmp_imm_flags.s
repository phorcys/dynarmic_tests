/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x20000000",
    "X1": "0x80000000",
    "X2": "0x60000000",
    "X3": "0x90000000",
    "X4": "0x20000000"
  },
  "VecData": {}
}
*/
.arch armv8.4-a+crc+lse+crypto
.text
.global _start

_start:
    // ========================================
    // CCMP (immediate) - Conditional Compare (immediate)
    // CCMP Xn, #imm, #nzcv, cond
    // If condition true: compare Xn with imm, set NZCV
    // If condition false: set NZCV to immediate #nzcv
    // 
    // CMP sets flags:
    // N = Negative (result < 0)
    // Z = Zero (result == 0)
    // C = 1 if no borrow (a >= b for unsigned)
    // V = Overflow (signed)
    // ========================================

    // Test 0: CCMP with condition true (EQ)
    // CCMP 10, #5, #0, eq -> CMP 10, 5 = 10 - 5 = 5
    // N=0, Z=0, C=1, V=0 -> NZCV = 0x20000000
    mov x10, #5
    cmp x10, x10          // Sets Z=1 (equal)
    mov x10, #10
    ccmp x10, #5, #0, eq  // Condition true, compare 10 vs 5
    mrs x0, nzcv          // Expected: 0x20000000

    // Test 1: CCMP with condition false (NE)
    // Should set NZCV to immediate #0x8
    mov x10, #5
    cmp x10, x10          // Sets Z=1 (equal)
    mov x10, #10
    ccmp x10, #5, #0x8, ne  // Condition false, use immediate
    mrs x1, nzcv          // Expected: 0x80000000

    // Test 2: CCMP with zero comparison
    // CCMP 0, #0, #0, eq -> CMP 0, 0 = 0
    // N=0, Z=1, C=1, V=0 -> NZCV = 0x60000000
    mov x10, #0
    cmp x10, x10          // Sets Z=1
    ccmp x10, #0, #0, eq  // Compare 0 vs 0
    mrs x2, nzcv          // Expected: 0x60000000

    // Test 3: CCMP with GT condition false
    mov x10, #1
    lsl x10, x10, #63     // MIN_SIGNED64
    mov x11, #0
    cmp x10, x11          // MIN < 0, N=1, GT=false
    ccmp x10, #0, #0x9, gt  // Condition false, use immediate
    mrs x3, nzcv          // Expected: 0x90000000

    // Test 4: CCMP with large immediate
    // CCMP 100, #31, #0, eq -> CMP 100, 31
    // 100 - 31 = 69, N=0, Z=0, C=1, V=0
    mov x10, #5
    cmp x10, x10          // Z=1
    mov x10, #100
    ccmp x10, #31, #0, eq
    mrs x4, nzcv          // Expected: 0x20000000

    brk #0