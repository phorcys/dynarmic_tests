/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000001000000030000000100000003",
  "Q1": "0x00000002000000040000000200000004"
}
*/
// Test: LD2R Vt.T, [Xn] - Load 2-element structure and replicate

.text
.global _start
_start:
    // Setup memory: two 32-bit values = [1, 2]
    sub sp, sp, #16
    mov w0, #1
    str w0, [sp]
    mov w0, #2
    str w0, [sp, #4]
    
    // LD2R: load two elements and replicate to all lanes
    ld2r {v0.4s, v1.4s}, [sp]
    
    add sp, sp, #16
    
    brk #0
