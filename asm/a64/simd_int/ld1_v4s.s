/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000004000000030000000200000001"
  }
}
*/
// Test: LD1 {Vt.4S}, [Xn] - load single 4-element structure

.text
.global _start
_start:
    // Use stack for memory
    sub sp, sp, #32
    
    // Store test data on stack
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    str w0, [sp, #0]
    str w1, [sp, #4]
    str w2, [sp, #8]
    str w3, [sp, #12]
    
    // LD1: load 4 words from stack
    ld1 {v0.4s}, [sp]
    
    add sp, sp, #32

    brk #0
