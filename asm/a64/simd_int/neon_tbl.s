/* CONFIG
{
  "Match": "All",
  "Q0": "0x04030201040302010403020104030201"
}
*/
// Test: TBL Vd.16B, {Vn.16B}, Vm.16B - Table Lookup
// Uses indices in Vm to look up bytes in table Vn

.text
.global _start
_start:
    // Setup: v0 = table [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    //        v1 = indices [0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
    movi v0.16b, #0
    movi v2.16b, #0
    
    // Build table: v0 = [0,1,2,...,15]
    mov w0, #1
    ins v0.b[1], w0
    add w0, w0, #1
    ins v0.b[2], w0
    add w0, w0, #1
    ins v0.b[3], w0
    add w0, w0, #1
    ins v0.b[4], w0
    add w0, w0, #1
    ins v0.b[5], w0
    add w0, w0, #1
    ins v0.b[6], w0
    add w0, w0, #1
    ins v0.b[7], w0
    add w0, w0, #1
    ins v0.b[8], w0
    add w0, w0, #1
    ins v0.b[9], w0
    add w0, w0, #1
    ins v0.b[10], w0
    add w0, w0, #1
    ins v0.b[11], w0
    add w0, w0, #1
    ins v0.b[12], w0
    add w0, w0, #1
    ins v0.b[13], w0
    add w0, w0, #1
    ins v0.b[14], w0
    add w0, w0, #1
    ins v0.b[15], w0
    
    // Build indices: v1 = [0,1,2,3,0,1,2,3,...]
    mov w1, #0
    ins v1.b[0], w1
    mov w1, #1
    ins v1.b[1], w1
    mov w1, #2
    ins v1.b[2], w1
    mov w1, #3
    ins v1.b[3], w1
    mov w1, #0
    ins v1.b[4], w1
    mov w1, #1
    ins v1.b[5], w1
    mov w1, #2
    ins v1.b[6], w1
    mov w1, #3
    ins v1.b[7], w1
    mov w1, #0
    ins v1.b[8], w1
    mov w1, #1
    ins v1.b[9], w1
    mov w1, #2
    ins v1.b[10], w1
    mov w1, #3
    ins v1.b[11], w1
    mov w1, #0
    ins v1.b[12], w1
    mov w1, #1
    ins v1.b[13], w1
    mov w1, #2
    ins v1.b[14], w1
    mov w1, #3
    ins v1.b[15], w1
    
    // TBL: table lookup
    tbl v0.16b, {v0.16b}, v1.16b
    
    brk #0
