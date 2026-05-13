/* CONFIG
{
  "Match": "All",
  "VecData": {
    "V2": ["0x4040000040400000", "0x4040000040400000"]
  }
}
*/
// Test: FMLA - Floating-point multiply-accumulate
// FMLA Vd, Vn, Vm : Vd = Vd + (Vn * Vm)

.text
.global _start
_start:
    // V0 = [1.0, 1.0, 1.0, 1.0] (float: 0x3F800000)
    mov w0, #0
    movk w0, #0x3F80, lsl #16
    ins v0.s[0], w0
    ins v0.s[1], w0
    ins v0.s[2], w0
    ins v0.s[3], w0
    
    // V1 = [2.0, 2.0, 2.0, 2.0] (float: 0x40000000)
    mov w1, #0
    movk w1, #0x4000, lsl #16
    ins v1.s[0], w1
    ins v1.s[1], w1
    ins v1.s[2], w1
    ins v1.s[3], w1
    
    // V2 = [1.0, 1.0, 1.0, 1.0] (accumulator)
    ins v2.s[0], w0
    ins v2.s[1], w0
    ins v2.s[2], w0
    ins v2.s[3], w0
    
    // FMLA V2.4S, V0.4S, V1.4S
    // V2 = 1.0 + (1.0 * 2.0) = 3.0 (0x40400000)
    fmla v2.4s, v0.4s, v1.4s

    brk #0