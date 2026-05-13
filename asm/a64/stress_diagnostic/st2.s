/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000000000000000000000400000001"
}
*/
// Test: ST2 {Vt.2S, Vt2.2S}, [Xn] - Store 2 vectors with interleaving

.text
.global _start
_start:
    // Setup: create two vectors
    // V0.2S = [1, 2]
    // V1.2S = [3, 4]
    mov w0, #1
    mov v0.s[0], w0
    mov w0, #2
    mov v0.s[1], w0
    mov w0, #3
    mov v1.s[0], w0
    mov w0, #4
    mov v1.s[1], w0
    
    sub sp, sp, #32
    
    // ST2: Store interleaved
    // Memory: [1, 3, 2, 4]
    st2 {v0.2s, v1.2s}, [sp]
    
    // Load back to verify
    ldr q0, [sp]
    // Q0 = [1, 3, 2, 4] = 0x00000004000000030000000200000001

    add sp, sp, #32

    brk #0
