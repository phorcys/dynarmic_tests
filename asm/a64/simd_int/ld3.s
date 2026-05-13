/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000003000000000000000200000000"
}
*/
// Test: LD3 {Vt.2S, Vt2.2S, Vt3.2S}, [Xn] - Load 3 vectors (64-bit each)
// Loads 3 registers from memory with deinterleaving

.text
.global _start
_start:
    // Setup: store 6 32-bit values: 0,1,2,3,4,5
    // These will be deinterleaved into 3 vectors (64-bit each):
    // V0.2S = [0, 3]
    // V1.2S = [1, 4]  
    // V2.2S = [2, 5]
    
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
    
    // LD3.2S: Load and deinterleave 3 registers
    ld3 {v0.2s, v1.2s, v2.2s}, [sp]
    
    // V0.2S = [0, 3] = 0x0000000300000000

    add sp, sp, #32

    brk #0