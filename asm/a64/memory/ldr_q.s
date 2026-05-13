/* CONFIG
{
  "Match": "All",
  "RegData": {
    "Q0": "0x00000004000000030000000200000001",
    "Q1": "0x00000004000000030000000200000001"
  }
}
*/
// Test: LDR Qt, [Xn] - load 128-bit vector

.text
.global _start
_start:
    // Allocate stack space and store test data
    sub sp, sp, #32
    
    // Store [1, 2, 3, 4] in memory
    mov w0, #1
    str w0, [sp, #0]
    mov w1, #2
    str w1, [sp, #4]
    mov w2, #3
    str w2, [sp, #8]
    mov w3, #4
    str w3, [sp, #12]
    
    // LDR: Load 128-bit into Q0
    ldr q0, [sp]
    
    // Copy to Q1 for verification
    mov v1.16b, v0.16b
    
    add sp, sp, #32

    brk #0