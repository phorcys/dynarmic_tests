/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000100000002",
  "X1": "0x0000000300000004"
}
*/
// Test: STP Wt1, Wt2, [Xn] - Store Pair Word
// Stores two 32-bit values

.text
.global _start
_start:
    mov w0, #1
    mov w1, #2
    mov w2, #3
    mov w3, #4
    
    sub sp, sp, #16
    
    // STP W: store pair word (32-bit)
    stp w0, w1, [sp]
    stp w2, w3, [sp, #8]
    
    // Load back to verify (as 64-bit)
    ldp x0, x1, [sp]
    
    brk #0
