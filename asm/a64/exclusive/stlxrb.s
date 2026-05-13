/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x000000000000002A"
  }
}
*/
// Test: STLXRB Ws, Wt, [Xn] - Store-Release Exclusive Register Byte
// Store byte with release and exclusive semantics

.text
.global _start
_start:
    // Store a byte on stack
    mov w1, #42
    strb w1, [sp, #-8]!
    
    // Load exclusive
    ldaxrb w1, [sp]
    
    // Store release exclusive
    // W0 = status (0 = success)
    stlxrb w0, w1, [sp]

    brk #0