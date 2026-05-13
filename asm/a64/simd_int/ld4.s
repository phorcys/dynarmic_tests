/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000004000000000000000300000000"
}
*/
// Test: LD4 {Vt.2S, Vt2.2S, Vt3.2S, Vt4.2S}, [Xn] - Load 4 vectors
// Loads 4 registers from memory with deinterleaving

.text
.global _start
_start:
    // Setup: store 8 32-bit values: 0,1,2,3,4,5,6,7
    // These will be deinterleaved into 4 vectors (64-bit each):
    // V0.2S = [0, 4]
    // V1.2S = [1, 5]
    // V2.2S = [2, 6]
    // V3.2S = [3, 7]
    
    sub sp, sp, #32
    
    mov w0, #0
    str w0, [sp, #0]
    mov w0, #1
    str w0, [sp, #4]
    mov w0, #2
    str w0, [sp, #8]
    mov w0, #3
    str w0, [sp, #12]
    mov w0, #4
    str w0, [sp, #16]
    mov w0, #5
    str w0, [sp, #20]
    mov w0, #6
    str w0, [sp, #24]
    mov w0, #7
    str w0, [sp, #28]
    
    // LD4.2S: Load and deinterleave 4 registers
    ld4 {v0.2s, v1.2s, v2.2s, v3.2s}, [sp]
    
    // V0.2S = [0, 4] = 0x0000000400000000

    add sp, sp, #32

    brk #0
