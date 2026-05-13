/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4000000000000000",
    "X1": "0x3FF6A09E667F3BCD"
  }
}
*/
// Test: FSQRT Dd, Dn - Floating-point Square Root
// Compute square root of floating-point value

.text
.global _start
_start:
    // FSQRT of 4.0 = 2.0
    mov x0, #0x4010000000000000   // 4.0 in double
    fmov d0, x0
    fsqrt d0, d0
    fmov x0, d0                   // X0 = 2.0
    
    // FSQRT of 2.0 ≈ 1.4142135623730951
    mov x1, #0x4000000000000000   // 2.0 in double
    fmov d1, x1
    fsqrt d1, d1
    fmov x1, d1                   // X1 = sqrt(2)

    brk #0