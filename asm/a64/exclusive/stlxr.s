/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000001",
    "X1": "0x0000000000005678"
  }
}
*/
// Test: STLXR Ws, Xt, [Xn] - store-release exclusive register

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #32
    
    // Store-release exclusive (will fail without matching LDAXR)
    mov x1, #0x5678
    stlxr w0, x1, [sp]
    
    add sp, sp, #32

    brk #0
