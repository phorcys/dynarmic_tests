/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000042",
    "X1": "0x0000000000000043"
  }
}
*/
// Test: LDP - Load Pair

.text
.global _start
_start:
    mov x0, #0x42
    mov x1, #0x43
    
    // Store pair to stack
    stp x0, x1, [sp, #-16]!
    
    // Clear registers
    mov x0, #0
    mov x1, #0
    
    // Load pair back
    ldp x0, x1, [sp]
    add sp, sp, #16

    brk #0
