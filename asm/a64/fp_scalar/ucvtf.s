/* CONFIG
{
  "Match": "All",
  "Q0": "0x3FF00000000000004000000000000000"
}
*/
// Test: UCVTF Vd.2D, Vn.2D - Unsigned Convert to Floating-point
// Converts unsigned integers to floating-point (double precision)

.text
.global _start
_start:
    // Setup: v0.2d = [1, 2] as unsigned 64-bit integers
    mov x0, #1
    mov x1, #2
    ins v0.d[0], x0
    ins v0.d[1], x1
    
    // UCVTF: convert unsigned to float (double precision)
    ucvtf v0.2d, v0.2d
    // Result: [1.0, 2.0] as doubles
    
    brk #0