/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000005000000040000000300000002",
  "Q1": "0x00000009000000080000000700000006"
}
*/
// Test: SDOT Vd.4S, Vn.16B, Vm.16B - Signed Dot Product
// Each 32-bit element is sum of 4 signed 8-bit products

.text
.global _start
_start:
    // v0 = [1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1] as signed bytes
    mov x0, #1
    dup v0.16b, w0
    
    // v1 = [1,2,3,4, 1,2,3,4, 1,2,3,4, 1,2,3,4] as signed bytes
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    mov v1.b[0], w0
    mov v1.b[1], w1
    mov v1.b[2], w2
    mov v1.b[3], w3
    mov v1.b[4], w0
    mov v1.b[5], w1
    mov v1.b[6], w2
    mov v1.b[7], w3
    mov v1.b[8], w0
    mov v1.b[9], w1
    mov v1.b[10], w2
    mov v1.b[11], w3
    mov v1.b[12], w0
    mov v1.b[13], w1
    mov v1.b[14], w2
    mov v1.b[15], w3
    
    // v2 = accumulator, initialized to 0
    movi v2.4s, #0
    
    // SDOT: v2.4s += v0.16b . v1.16b (signed)
    // Each 32-bit lane: sum of 4 products
    // Lane 0: 1*1 + 1*2 + 1*3 + 1*4 = 10
    sdot v2.4s, v0.16b, v1.16b
    
    // Store result to v0 for verification
    mov v0.16b, v2.16b
    // v0 = [10, 10, 10, 10]
    
    // Second test with different values
    // v3 = [2,2,2,2, ...]
    mov w0, #2
    dup v3.16b, w0
    
    // SDOT: v2.4s += v3.16b . v1.16b
    // Lane 0: 2*1 + 2*2 + 2*3 + 2*4 = 20
    sdot v2.4s, v3.16b, v1.16b
    // v2 = [30, 30, 30, 30]
    
    mov v1.16b, v2.16b
    // v1 = [30, 30, 30, 30]
    
    brk #0
