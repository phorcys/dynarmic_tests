/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000002000000010000000000000000",
  "Q1": "0x00000004000000030000000000000000"
}
*/
// Test: LD2 {Vt.2S, Vt2.2S}, [Xn] - Load two 64-bit registers

.text
.global _start
_start:
    sub sp, sp, #32
    
    // Setup: store interleaved data for LD2
    // LD2 de-interleaves: even elements go to Vt, odd to Vt2
    mov x0, #1
    mov x1, #2
    mov x2, #3
    mov x3, #4
    
    // Store as: [1, 2, 3, 4] = words
    stp x0, x1, [sp]
    stp x2, x3, [sp, #16]
    
    // LD2: load two 64-bit registers (2S each)
    ld2 {v0.2s, v1.2s}, [sp]
    
    // v0.2s = [1, 3] (even elements)
    // v1.2s = [2, 4] (odd elements)
    
    brk #0
