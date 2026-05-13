/* CONFIG
{
  "Match": "All",
  "Q0": "0x00000001000000050000000100000005",
  "Q1": "0x00000002000000060000000200000006",
  "Q2": "0x00000003000000070000000300000007",
  "Q3": "0x00000004000000080000000400000008"
}
*/
// Test: LD4R Vt.T, [Xn] - Load 4-element structure and replicate

.text
.global _start
_start:
    // Setup memory: four 32-bit values = [1, 2, 3, 4]
    sub sp, sp, #32
    mov w0, #1
    str w0, [sp]
    mov w0, #2
    str w0, [sp, #4]
    mov w0, #3
    str w0, [sp, #8]
    mov w0, #4
    str w0, [sp, #12]
    
    // LD4R: load four elements and replicate to all lanes
    ld4r {v0.4s, v1.4s, v2.4s, v3.4s}, [sp]
    
    add sp, sp, #32
    
    brk #0
