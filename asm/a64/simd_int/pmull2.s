/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000310000000000000031"
}
*/
// Test: PMULL2 Vd.8H, Vn.16B, Vm.16B - Polynomial Multiply Long (upper)
// Uses upper half of 16B vectors

.text
.global _start
_start:
    // Setup: v0.16b and v1.16b with values in upper half
    mov w0, #0x07
    ins v0.b[8], w0
    ins v0.b[9], w0
    ins v0.b[10], w0
    ins v0.b[11], w0
    ins v0.b[12], w0
    ins v0.b[13], w0
    ins v0.b[14], w0
    ins v0.b[15], w0
    
    mov w0, #0x0B
    ins v1.b[8], w0
    ins v1.b[9], w0
    ins v1.b[10], w0
    ins v1.b[11], w0
    ins v1.b[12], w0
    ins v1.b[13], w0
    ins v1.b[14], w0
    ins v1.b[15], w0
    
    // PMULL2: polynomial multiply long (upper 8B -> 8H)
    pmull2 v0.8h, v0.16b, v1.16b
    
    brk #0
