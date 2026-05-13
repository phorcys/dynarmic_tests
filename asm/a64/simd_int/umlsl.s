/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000030000000000000001"
}
*/
// Test: UMLSL Vd.4S, Vn.4H, Vm.4H - Unsigned Multiply Subtract Long
// v0 = v0 - (v1 * v2)

.text
.global _start
_start:
    // Setup: v0.4s = [5, 5, 5, 5] (accumulator)
    mov w0, #5
    dup v0.4s, w0
    
    // v1.4h = [1, 2, 3, 4]
    mov w0, #1
    dup v1.4h, w0
    mov w0, #2
    ins v1.h[1], w0
    mov w0, #3
    ins v1.h[2], w0
    mov w0, #4
    ins v1.h[3], w0
    
    // v2.4h = [1, 1, 1, 1]
    mov w0, #1
    dup v2.4h, w0
    
    // UMLSL: v0 = v0 - (v1 * v2)
    // [5, 5, 5, 5] - ([1,2,3,4] * [1,1,1,1]) = [5-1, 5-2, 5-3, 5-4] = [4, 3, 2, 1]
    umlsl v0.4s, v1.4h, v2.4h
    
    brk #0
