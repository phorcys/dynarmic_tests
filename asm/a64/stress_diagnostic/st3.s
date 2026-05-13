/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000006000000030000000500000002"
}
*/
// Test: ST3 {Vt.2S, Vt2.2S, Vt3.2S}, [Xn] - Store 3 vectors with interleaving

.text
.global _start
_start:
    // Setup: create three vectors
    // V0.2S = [1, 4]
    // V1.2S = [2, 5]
    // V2.2S = [3, 6]
    mov w0, #1
    mov v0.s[0], w0
    mov w0, #4
    mov v0.s[1], w0
    mov w0, #2
    mov v1.s[0], w0
    mov w0, #5
    mov v1.s[1], w0
    mov w0, #3
    mov v2.s[0], w0
    mov w0, #6
    mov v2.s[1], w0
    
    sub sp, sp, #32
    
    // ST3: Store interleaved
    // Memory: [1, 2, 3, 4, 5, 6]
    st3 {v0.2s, v1.2s, v2.2s}, [sp]
    
    // Load back first 16 bytes to verify
    ldr q0, [sp]
    // Q0 = [1, 2, 3, 4] = 0x00000004000000030000000200000001

    add sp, sp, #32

    brk #0
