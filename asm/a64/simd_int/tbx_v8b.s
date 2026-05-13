/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000000000000000000301",
    "Q1": "0x0f0e0d0c0b0a09080706050403020100",
    "Q2": "0xffffffffffffffffffffffffffffffff",
    "Q3": "0x00000000000000000000000000000301"
  }
}
*/
// Test: TBX Vd.8B, {Vn.16B}, Vm.8B - table lookup extension

.text
.global _start
_start:
    // Create table in Q1: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    mov w0, #0
    mov w1, #1
    mov w2, #2
    mov w3, #3
    mov w4, #4
    mov w5, #5
    mov w6, #6
    mov w7, #7
    mov v1.b[0], w0
    mov v1.b[1], w1
    mov v1.b[2], w2
    mov v1.b[3], w3
    mov v1.b[4], w4
    mov v1.b[5], w5
    mov v1.b[6], w6
    mov v1.b[7], w7
    mov w0, #8
    mov w1, #9
    mov w2, #10
    mov w3, #11
    mov w4, #12
    mov w5, #13
    mov w6, #14
    mov w7, #15
    mov v1.b[8], w0
    mov v1.b[9], w1
    mov v1.b[10], w2
    mov v1.b[11], w3
    mov v1.b[12], w4
    mov v1.b[13], w5
    mov v1.b[14], w6
    mov v1.b[15], w7
    
    // Indices in D0: [1, 3, 0, 0, ...]
    mov w0, #1
    mov w1, #3
    mov v0.b[0], w0
    mov v0.b[1], w1
    mov v0.d[1], xzr
    
    // Initial value in Q2: all 0xFF
    mov w0, #0xff
    dup v2.16b, w0
    
    // TBX: lookup bytes from table, keep original if out of range
    // Since indices are [1, 3, 0, 0, ...], and index 0 means "use table[0]"
    // Result: [table[1], table[3], table[0], table[0], ...]
    //       = [1, 3, 0, 0, ...]
    mov v3.16b, v2.16b
    tbx v3.8b, {v1.16b}, v0.8b

    brk #0
