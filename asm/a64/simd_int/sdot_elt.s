/* CONFIG
{
  "Match": "All",
  "Q0": "0x0000000A0000000A0000000A0000000A"
}
*/
// Test: SDOT Vd.4S, Vn.16B, Vm.4B[0] - Signed Dot Product by element
// Each 32-bit element is sum of 4 signed 8-bit products with indexed element

.text
.global _start
_start:
    // v0 = accumulator = [0, 0, 0, 0]
    movi v0.4s, #0
    
    // v1 = [1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1] as signed bytes
    mov w0, #1
    dup v1.16b, w0
    
    // v2 = [1,2,3,4, 5,6,7,8, 9,10,11,12, 13,14,15,16] as signed bytes
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    mov v2.b[0], w0
    mov v2.b[1], w1
    mov v2.b[2], w2
    mov v2.b[3], w3
    mov v2.b[4], w0
    mov v2.b[5], w1
    mov v2.b[6], w2
    mov v2.b[7], w3
    mov v2.b[8], w0
    mov v2.b[9], w1
    mov v2.b[10], w2
    mov v2.b[11], w3
    mov v2.b[12], w0
    mov v2.b[13], w1
    mov v2.b[14], w2
    mov v2.b[15], w3
    
    // SDOT with element: v0.4s += v1.16b . v2.4b[0]
    // Element 0 of v2 = [1,2,3,4]
    // Each 32-bit lane of v0 gets: 1*1 + 1*2 + 1*3 + 1*4 = 10
    sdot v0.4s, v1.16b, v2.4b[0]
    // v0 = [10, 10, 10, 10]
    
    brk #0
