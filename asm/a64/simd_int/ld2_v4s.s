/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000007000000050000000300000001",
    "Q1": "0x00000008000000060000000400000002"
  }
}
*/
// Test: LD2 {Vt.4S, Vt2.4S}, [Xn] - load 2-element structure

.text
.global _start
_start:
    // Use stack for memory
    sub sp, sp, #64
    
    // Store test data on stack: [1,2,3,4,5,6,7,8]
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    mov w4, #5
    mov w5, #6
    mov w6, #7
    mov w7, #8
    str w0, [sp, #0]
    str w1, [sp, #4]
    str w2, [sp, #8]
    str w3, [sp, #12]
    str w4, [sp, #16]
    str w5, [sp, #20]
    str w6, [sp, #24]
    str w7, [sp, #28]
    
    // LD2: deinterleave 8 words
    // Memory: [1,2,3,4,5,6,7,8]
    // Q0 gets: [1,3,5,7] (odd indices)
    // Q1 gets: [2,4,6,8] (even indices)
    ld2 {v0.4s, v1.4s}, [sp]
    
    add sp, sp, #64

    brk #0
