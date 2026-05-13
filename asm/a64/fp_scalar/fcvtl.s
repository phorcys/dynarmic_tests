/* CONFIG
{
  "Match": "All",
  "Q0": "0x40000000400000004000000040000000"
}
*/
// Test: FCVTL Vd.4S, Vn.4H - Floating-point Convert Long (half to single)
// Converts half-precision to single-precision

.text
.global _start
_start:
    mov w0, #0x4000     // 2.0 in half-precision
    dup v0.4h, w0
    
    // FCVTL: convert half to single
    fcvtl v0.4s, v0.4h
    
    brk #0
