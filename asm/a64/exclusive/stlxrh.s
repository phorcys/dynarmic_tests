/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x000000000000002A"
  }
}
*/
// Test: STLXRH Ws, Wt, [Xn] - Store-Release Exclusive Register Halfword
// Store halfword with release and exclusive semantics

.text
.global _start
_start:
    // Store a halfword on stack
    mov w1, #42
    strh w1, [sp, #-8]!
    
    // Load exclusive
    ldaxrh w1, [sp]
    
    // Store release exclusive
    // W0 = status (0 = success)
    stlxrh w0, w1, [sp]

    brk #0