/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x0000000000005678"
  }
}
*/
// Test: LDAXP - Load-Acquire Exclusive Pair

.text
.global _start
_start:
    sub sp, sp, #32
    
    // Store pair of values
    mov x0, #0x1234
    mov x1, #0x5678
    stp x0, x1, [sp]
    
    // Clear registers
    mov x0, #0
    mov x1, #0
    
    // Load-acquire exclusive pair
    ldaxp x0, x1, [sp]
    
    add sp, sp, #32

    brk #0
