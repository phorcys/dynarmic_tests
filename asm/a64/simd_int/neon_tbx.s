/* CONFIG
{
  "Match": "All",
  "Q0": "0x04030201040302010403020104030201"
}
*/
// Test: TBX Vd.16B, {Vn.16B}, Vm.16B - Table Lookup with Extend
// Uses indices in Vm to look up bytes, preserves original if index out of range

.text
.global _start
_start:
    // Setup: v0 = result buffer (initialized to 0xFF for out-of-range detection)
    //        v1 = table [0,1,2,...,15]
    //        v2 = indices [0,1,2,3,0,1,2,3,...]
    
    movi v0.16b, #0xFF  // Initialize to 0xFF (out of range)
    
    // Build table: v1 = [0,1,2,...,15]
    mov w0, #0
    ins v1.b[0], w0
    mov w0, #1
    ins v1.b[1], w0
    mov w0, #2
    ins v1.b[2], w0
    mov w0, #3
    ins v1.b[3], w0
    mov w0, #4
    ins v1.b[4], w0
    mov w0, #5
    ins v1.b[5], w0
    mov w0, #6
    ins v1.b[6], w0
    mov w0, #7
    ins v1.b[7], w0
    mov w0, #8
    ins v1.b[8], w0
    mov w0, #9
    ins v1.b[9], w0
    mov w0, #10
    ins v1.b[10], w0
    mov w0, #11
    ins v1.b[11], w0
    mov w0, #12
    ins v1.b[12], w0
    mov w0, #13
    ins v1.b[13], w0
    mov w0, #14
    ins v1.b[14], w0
    mov w0, #15
    ins v1.b[15], w0
    
    // Build indices: v2 = [0,1,2,3,0,1,2,3,...]
    mov w1, #0
    ins v2.b[0], w1
    mov w1, #1
    ins v2.b[1], w1
    mov w1, #2
    ins v2.b[2], w1
    mov w1, #3
    ins v2.b[3], w1
    mov w1, #0
    ins v2.b[4], w1
    mov w1, #1
    ins v2.b[5], w1
    mov w1, #2
    ins v2.b[6], w1
    mov w1, #3
    ins v2.b[7], w1
    mov w1, #0
    ins v2.b[8], w1
    mov w1, #1
    ins v2.b[9], w1
    mov w1, #2
    ins v2.b[10], w1
    mov w1, #3
    ins v2.b[11], w1
    mov w1, #0
    ins v2.b[12], w1
    mov w1, #1
    ins v2.b[13], w1
    mov w1, #2
    ins v2.b[14], w1
    mov w1, #3
    ins v2.b[15], w1
    
    // TBX: table lookup with extend (preserves original if out of range)
    tbx v0.16b, {v1.16b}, v2.16b
    
    brk #0
