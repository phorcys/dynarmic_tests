/* CONFIG
{
  "Match": "All",
  "Q0": "0x03020100030201000302010003020100"
}
*/
// Test: TBL Vd.16B, {Vn.16B}, Vm.16B - Table Lookup
// Uses each byte in Vm as index into table Vn

.text
.global _start
_start:
    // Setup: v0 = table [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    mov w0, #0
    ins v0.b[0], w0
    mov w0, #1
    ins v0.b[1], w0
    mov w0, #2
    ins v0.b[2], w0
    mov w0, #3
    ins v0.b[3], w0
    mov w0, #4
    ins v0.b[4], w0
    mov w0, #5
    ins v0.b[5], w0
    mov w0, #6
    ins v0.b[6], w0
    mov w0, #7
    ins v0.b[7], w0
    mov w0, #8
    ins v0.b[8], w0
    mov w0, #9
    ins v0.b[9], w0
    mov w0, #10
    ins v0.b[10], w0
    mov w0, #11
    ins v0.b[11], w0
    mov w0, #12
    ins v0.b[12], w0
    mov w0, #13
    ins v0.b[13], w0
    mov w0, #14
    ins v0.b[14], w0
    mov w0, #15
    ins v0.b[15], w0
    
    // v1 = indices [0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3]
    mov w0, #0
    ins v1.b[0], w0
    ins v1.b[4], w0
    ins v1.b[8], w0
    ins v1.b[12], w0
    mov w0, #1
    ins v1.b[1], w0
    ins v1.b[5], w0
    ins v1.b[9], w0
    ins v1.b[13], w0
    mov w0, #2
    ins v1.b[2], w0
    ins v1.b[6], w0
    ins v1.b[10], w0
    ins v1.b[14], w0
    mov w0, #3
    ins v1.b[3], w0
    ins v1.b[7], w0
    ins v1.b[11], w0
    ins v1.b[15], w0
    
    // TBL: lookup table
    tbl v2.16b, {v0.16b}, v1.16b
    
    // Copy result
    mov v0.16b, v2.16b
    
    brk #0
