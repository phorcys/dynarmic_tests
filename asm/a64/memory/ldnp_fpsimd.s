/* CONFIG
{
  "Match": "All",
  "Q0": "0x3FF00000000000003FF0000000000000",
  "Q1": "0x40000000000000004000000000000000"
}
*/
// Test: LDNP Dt1, Dt2, [Xn] - Load Pair Non-temporal SIMD&FP
// Loads two 128-bit SIMD values with non-temporal hint

.text
.global _start
_start:
    sub sp, sp, #64
    
    // Setup: store two doubles 1.0 and 2.0
    fmov d0, #1.0
    fmov d1, #2.0
    stp d0, d1, [sp]
    
    // Clear registers
    mov x0, #0
    mov x1, #0
    fmov d0, x0
    fmov d1, x1
    
    // LDNP SIMD: load pair non-temporal
    ldnp d0, d1, [sp]
    
    brk #0
