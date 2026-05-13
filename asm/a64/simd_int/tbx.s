/* CONFIG
{
  "Match": "All",
  "Q0": "0x03020100FF0000000302010000000000"
}
*/
// Test: TBX Vd.16B, {Vn.16B}, Vm.16B - Table Lookup Extension
// Uses each byte in Vm as index, preserves original value if index >= 16

.text
.global _start
_start:
    // Setup: v0 = initial values [0xFF, 0xFF, ...] (will be preserved for indices >= 16)
    movi v0.16b, #0xFF
    
    // v1 = table [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
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
    
    // v2 = indices [0,1,2,3,16,17,18,19,0,1,2,3,20,21,22,23]
    // Indices >= 16 preserve original value
    mov w0, #0
    ins v2.b[0], w0
    ins v2.b[8], w0
    mov w0, #1
    ins v2.b[1], w0
    ins v2.b[9], w0
    mov w0, #2
    ins v2.b[2], w0
    ins v2.b[10], w0
    mov w0, #3
    ins v2.b[3], w0
    ins v2.b[11], w0
    mov w0, #16
    ins v2.b[4], w0
    mov w0, #17
    ins v2.b[5], w0
    mov w0, #18
    ins v2.b[6], w0
    mov w0, #19
    ins v2.b[7], w0
    mov w0, #20
    ins v2.b[12], w0
    mov w0, #21
    ins v2.b[13], w0
    mov w0, #22
    ins v2.b[14], w0
    mov w0, #23
    ins v2.b[15], w0
    
    // TBX: table lookup extension
    tbx v0.16b, {v1.16b}, v2.16b
    
    brk #0
