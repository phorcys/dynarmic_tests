/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000004",
  "X1": "0x0000000000000003"
}
*/
// Test: LDPSW Xt1, Xt2, [Xn] - Load Pair Signed Word
// Loads two 32-bit signed values, sign-extends to 64-bit

.text
.global _start
_start:
    // Setup stack with two 32-bit values: [3, 4]
    mov x2, #0
    add sp, sp, #-16
    
    mov w3, #3
    str w3, [sp]
    mov w3, #4
    str w3, [sp, #4]
    
    // LDPSW: Load pair signed word and sign-extend
    ldpsw x0, x1, [sp]
    
    add sp, sp, #16
    
    brk #0
