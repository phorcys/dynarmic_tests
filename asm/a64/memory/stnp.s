/* CONFIG
{
  "Match": "All",
  "X0": "0x0000000100000002",
  "X1": "0x0000000300000004"
}
*/
// Test: STNP Xt1, Xt2, [Xn, #imm] - Store Pair Non-temporal
// Stores two registers to memory with non-temporal hint (no writeback)

.text
.global _start
_start:
    mov x0, #1
    mov x1, #2
    mov x2, #3
    mov x3, #4
    
    sub sp, sp, #32
    
    // STNP: store pair non-temporal (no writeback allowed)
    stnp x0, x1, [sp]
    stnp x2, x3, [sp, #16]
    
    // Load back to verify
    ldp x0, x1, [sp]
    
    brk #0