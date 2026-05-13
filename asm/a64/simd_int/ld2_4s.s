/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000000000000020000000000000000",
    "Q1": "0x00000000000000030000000000000001"
  }
}
*/
// Test: LD2 {Vt.2D, Vt2.2D}, [Xn] - load 2-element structure

.text
.global _start
_start:
    // Allocate stack space and store interleaved data
    sub sp, sp, #64
    
    // Store interleaved [0, 1], [2, 3] as 2D pairs
    mov x0, #0
    str x0, [sp, #0]
    mov x1, #1
    str x1, [sp, #8]
    mov x2, #2
    str x2, [sp, #16]
    mov x3, #3
    str x3, [sp, #24]
    
    // LD2: Load 2x 2D into Q0, Q1
    ld2 {v0.2d, v1.2d}, [sp]
    
    add sp, sp, #64

    brk #0
