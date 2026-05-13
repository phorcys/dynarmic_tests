/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000001000000040000000100000004",
  "Q1": "0x00000002000000050000000200000005",
  "Q2": "0x00000003000000060000000300000006"
}
*/
// Test: LD3R Vt.T, [Xn] - Load 3-element structure and replicate

.text
.global _start
_start:
    // Setup memory: three 32-bit values = [1, 2, 3]
    sub sp, sp, #16
    mov w0, #1
    str w0, [sp]
    mov w0, #2
    str w0, [sp, #4]
    mov w0, #3
    str w0, [sp, #8]
    
    // LD3R: load three elements and replicate to all lanes
    ld3r {v0.4s, v1.4s, v2.4s}, [sp]
    
    add sp, sp, #16
    
    brk #0
