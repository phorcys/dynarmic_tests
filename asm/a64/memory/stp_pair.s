/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001111",
    "X1": "0x0000000000002222",
    "X2": "0x0000000000001111",
    "X3": "0x0000000000002222"
  }
}
*/
// Test: STP Xn, Xm, [Xa] - store pair

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #32
    
    // Store two values
    mov x0, #0x1111
    mov x1, #0x2222
    stp x0, x1, [sp]
    
    // Load pair back to verify
    ldp x2, x3, [sp]
    
    add sp, sp, #32

    brk #0
