/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000000000001",
  "X1": "0x0000000000000002"
}
*/
// Test: STP X0, X1, [X2] - Store Pair of Registers

.text
.global _start
_start:
    // Setup values
    mov x0, #1
    mov x1, #2
    
    // Allocate stack space
    sub sp, sp, #32
    
    // Store pair
    stp x0, x1, [sp]
    
    // Load back to verify
    ldp x0, x1, [sp]
    
    // Restore stack
    add sp, sp, #32
    
    brk #0
