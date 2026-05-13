/* CONFIG
{
  "Match": "All",
  "RegData": {
    "S0": "0x0000000041800000",
    "S1": "0x0000000040800000"
  }
}
*/
// Test: FSQRT Sd, Sn - scalar floating-point square root

.text
.global _start
_start:
    // Load S0 with 16.0
    mov w0, #0x0000
    movk w0, #0x4180, lsl #16
    fmov s0, w0
    
    // FSQRT: sqrt(16.0) = 4.0 = 0x40800000
    fsqrt s1, s0

    brk #0
