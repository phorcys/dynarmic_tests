/* CONFIG
{
  "Match": "All",
  "X0": "0x3FF0000000000000",
  "X1": "0x4000000000000000"
}
*/
// Test: STP Dt1, Dt2, [Xn] - Store Pair SIMD&FP
// Stores two 64-bit floating-point values

.text
.global _start
_start:
    sub sp, sp, #32
    
    // Setup
    fmov d0, #1.0
    fmov d1, #2.0
    
    // STP SIMD: store pair
    stp d0, d1, [sp]
    
    // Load back to verify
    ldp x0, x1, [sp]
    
    brk #0
