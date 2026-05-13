/* CONFIG
{
  "Match": "All",
  "X0": "0x3FF0000000000000",
  "X1": "0x4000000000000000"
}
*/
// Test: STNP Dt1, Dt2, [Xn] - Store Pair Non-temporal SIMD&FP
// Stores two 64-bit floating-point values with non-temporal hint

.text
.global _start
_start:
    sub sp, sp, #32
    
    // Setup
    fmov d0, #1.0
    fmov d1, #2.0
    
    // STNP SIMD: store pair non-temporal
    stnp d0, d1, [sp]
    
    // Load back to verify
    ldp x0, x1, [sp]
    
    brk #0
