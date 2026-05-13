/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000100000002",
  "X1": "0x0000000300000004"
}
*/
// Test: LDNP Xt1, Xt2, [Xn] - Load Pair Non-temporal
// Loads two registers from memory with non-temporal hint

.text
.global _start
_start:
    // Setup data on stack
    mov x2, #1
    mov x3, #2
    mov x4, #3
    mov x5, #4
    stp x2, x3, [sp, #-32]!
    stp x4, x5, [sp, #16]
    
    // LDNP: load pair non-temporal
    ldnp x0, x1, [sp]
    
    brk #0
