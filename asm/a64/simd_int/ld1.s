/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000004000000030000000200000001"
}
*/
// Test: LD1 {Vt.4S}, [Xn] - Load single 128-bit register from memory

.text
.global _start
_start:
    sub sp, sp, #32
    
    // Setup: store 4 words
    mov x0, #1
    mov x1, #2
    mov x2, #3
    mov x3, #4
    stp x0, x1, [sp]
    stp x2, x3, [sp, #16]
    
    // LD1: load single 128-bit register
    ld1 {v0.4s}, [sp]
    
    brk #0
