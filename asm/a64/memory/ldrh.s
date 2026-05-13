/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000001234",
    "X1": "0x0000000000001234"
  }
}
*/
// Test: LDRH Wt, [Xn] - load register halfword

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #32
    
    // Store value
    mov x0, #0x1234
    strh w0, [sp]
    
    // LDRH: load halfword
    ldrh w1, [sp]
    
    add sp, sp, #32

    brk #0
