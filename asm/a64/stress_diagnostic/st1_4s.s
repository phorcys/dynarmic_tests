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
    // Allocate stack space
    sub sp, sp, #32
    
    // Load Q0 with [1, 2, 3, 4]
    mov w0, #1
    mov v0.s[0], w0
    mov w1, #2
    mov v0.s[1], w1
    mov w2, #3
    mov v0.s[2], w2
    mov w3, #4
    mov v0.s[3], w3
    
    // ST1: Store 4 words from Q0
    st1 {v0.4s}, [sp]
    
    // Clear Q0
    movi v0.4s, #0
    
    // Load back into Q0 to verify
    ld1 {v0.4s}, [sp]
    
    add sp, sp, #32

    brk #0
