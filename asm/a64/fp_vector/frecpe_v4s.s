/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x7F8000007F800000"
  }
}
*/
// Test: FRECPE - Floating-point Reciprocal Estimate (4S)

.text
.global _start
_start:
    // V0 = {1.0, 1.0}
    movi v0.4s, #0
    mov w8, #0x3F80  // 1.0 in IEEE 754
    movk w8, #0x0000, lsl #16
    ins v0.s[0], w8
    ins v0.s[1], w8
    
    // FREQPE: reciprocal estimate of 1.0 = 1.0
    frecpe v0.4s, v0.4s
    
    fmov x0, d0

    brk #0
