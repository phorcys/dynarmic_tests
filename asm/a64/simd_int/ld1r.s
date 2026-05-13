/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000005000000050000000500000005"
}
*/
// Test: LD1R Vt.T, [Xn] - Load 1-element structure and replicate

.text
.global _start
_start:
    // Setup memory: one 32-bit value = 5
    sub sp, sp, #16
    mov w0, #5
    str w0, [sp]
    
    // LD1R: load one element and replicate to all lanes
    ld1r {v0.4s}, [sp]
    
    add sp, sp, #16
    
    brk #0
