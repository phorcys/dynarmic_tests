/* CONFIG
{
  "Match": "All",
  "VecData": {
    "Q0": "0x00000004000000030000000200000001"
  }
}
*/
// Test: ST1 {Vt.4S}, [Xn] - store single 4-element structure

.text
.global _start
_start:
    // Use stack for memory
    sub sp, sp, #32
    
    // Load Q0 with test data
    mov w1, #1
    mov w2, #2
    mov w3, #3
    mov w4, #4
    mov v0.s[0], w1
    mov v0.s[1], w2
    mov v0.s[2], w3
    mov v0.s[3], w4
    
    // ST1: store 4 words to stack
    st1 {v0.4s}, [sp]
    
    // Clear Q0 and reload to verify
    movi v0.4s, #0
    ld1 {v0.4s}, [sp]
    
    add sp, sp, #32

    brk #0
