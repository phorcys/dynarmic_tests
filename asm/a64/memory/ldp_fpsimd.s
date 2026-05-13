/* CONFIG
{
  "Match": "All",
  "Q0": "0x3FF00000000000003FF0000000000000",
  "Q1": "0x40000000000000004000000000000000"
}
*/
// Test: LDP Dt1, Dt2, [Xn] - Load Pair SIMD&FP
// Loads two 64-bit floating-point values

.text
.global _start
_start:
    sub sp, sp, #32
    
    // Setup: store two doubles 1.0 and 2.0
    fmov d0, #1.0
    fmov d1, #2.0
    stp d0, d1, [sp]
    
    // Clear registers
    mov x0, #0
    mov x1, #0
    fmov d0, x0
    fmov d1, x1
    
    // LDP SIMD: load pair
    ldp d0, d1, [sp]
    
    brk #0
