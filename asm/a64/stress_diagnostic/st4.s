/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000005000000040000000300000002"
}
*/
// Test: ST4 {Vt.2S, Vt2.2S, Vt3.2S, Vt4.2S}, [Xn] - Store 4 vectors with interleaving

.text
.global _start
_start:
    // Setup: create four vectors
    // V0.2S = [1, 5]
    // V1.2S = [2, 6]
    // V2.2S = [3, 7]
    // V3.2S = [4, 8]
    mov w0, #1
    mov v0.s[0], w0
    mov w0, #5
    mov v0.s[1], w0
    mov w0, #2
    mov v1.s[0], w0
    mov w0, #6
    mov v1.s[1], w0
    mov w0, #3
    mov v2.s[0], w0
    mov w0, #7
    mov v2.s[1], w0
    mov w0, #4
    mov v3.s[0], w0
    mov w0, #8
    mov v3.s[1], w0
    
    sub sp, sp, #48
    
    // ST4: Store interleaved
    // Memory: [1, 2, 3, 4, 5, 6, 7, 8]
    st4 {v0.2s, v1.2s, v2.2s, v3.2s}, [sp]
    
    // Load back first 16 bytes to verify
    ldr q0, [sp]
    // Q0 = [1, 2, 3, 4] = 0x00000004000000030000000200000001

    add sp, sp, #48

    brk #0
