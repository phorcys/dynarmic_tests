/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x000000007FC00000",
    "X2": "0x000000007FC00000",
    "X3": "0x000000007FC00000",
    "X4": "0x000000007FC00000"
  }
}
*/
// Test: FDIV with special values (NaN, Infinity, Zero)
// IEEE 754 rules:
// - Any operation with NaN returns NaN
// - Inf / Inf = NaN
// - x / 0 (x != 0) = Inf (with appropriate sign)
// - 0 / 0 = NaN

.text
.global _start
_start:
    // === Test 1: NaN / x = NaN ===
    ldr w8, =0x7fc00000      // Quiet NaN
    fmov s0, w8
    fmov s1, #2.0
    fdiv s2, s0, s1          // NaN / 2.0 = NaN
    fmov w1, s2
    
    // === Test 2: x / NaN = NaN ===
    fmov s0, #2.0
    ldr w8, =0x7fc00000
    fmov s1, w8
    fdiv s2, s0, s1          // 2.0 / NaN = NaN
    fmov w2, s2
    
    // === Test 3: Inf / Inf = NaN ===
    ldr w8, =0x7f800000      // +Inf
    fmov s0, w8
    fmov s1, w8
    fdiv s2, s0, s1          // Inf / Inf = NaN
    fmov w3, s2
    
    // === Test 4: 0 / 0 = NaN ===
    // Use integer register to set zero
    mov w8, #0
    fmov s0, w8
    fmov s1, w8
    fdiv s2, s0, s1          // 0.0 / 0.0 = NaN
    fmov w4, s2
    
    // X0 = 0 (marker that we reached the end)
    mov x0, #0

    brk #0