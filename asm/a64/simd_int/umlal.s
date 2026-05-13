/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000050000000000000001"
}
*/
// Test: UMLAL Vd.4S, Vn.4H, Vm.4H - Unsigned Multiply Accumulate Long
// v0 = v0 + (v1 * v2)

.text
.global _start
_start:
    // Setup: v0.4s = [1, 2, 3, 4] (accumulator)
    mov w0, #1
    dup v0.4s, w0
    mov w0, #2
    ins v0.s[1], w0
    mov w0, #3
    ins v0.s[2], w0
    mov w0, #4
    ins v0.s[3], w0
    
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
    
    // UMLAL: v0 = v0 + (v1 * v2)
    // [1, 2, 3, 4] + ([1,2,3,4] * [1,1,1,1]) = [1+1, 2+2, 3+3, 4+4] = [2, 4, 6, 8]
    umlal v0.4s, v1.4h, v2.4h
    
    brk #0
