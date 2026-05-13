/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x3F80000040000000"
  }
}
*/
// Test: FSQRT - Float Square Root (vector)
// sqrt(4.0) = 2.0 (0x40000000), sqrt(1.0) = 1.0 (0x3F800000)

.text
.global _start
_start:
    // V0 = {4.0, 1.0} = {0x40800000, 0x3F800000}
    movz x8, #0x0000
    movk x8, #0x4080, lsl #16
    movk x8, #0x0000, lsl #32
    movk x8, #0x3F80, lsl #48
    fmov d0, x8
    
    fsqrt v0.2s, v0.2s
    
    fmov x0, d0

    brk #0
