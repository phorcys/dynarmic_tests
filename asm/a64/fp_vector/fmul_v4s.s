/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000404000004040"
  }
}
*/
// Test: FMUL - Floating-point Multiply (4S)

.text
.global _start
_start:
    // V0 = {2.0, 2.0}
    movi v0.4s, #0
    mov w8, #0x4000
    movk w8, #0x0000, lsl #16
    ins v0.s[0], w8
    ins v0.s[1], w8
    
    // V1 = {3.0, 3.0}
    mov w9, #0x4040
    movk w9, #0x0000, lsl #16
    ins v1.s[0], w9
    ins v1.s[1], w9
    
    // FMUL: 2.0 * 3.0 = 6.0
    fmul v0.4s, v0.4s, v1.4s
    
    fmov x0, d1

    brk #0
