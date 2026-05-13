/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x0000000000001234",
    "X2": "0x0000000000005678"
  }
}
*/
// Test: STLXP - Store-Release Exclusive Pair

.text
.global _start
_start:
    sub sp, sp, #32
    
    // Load exclusive pair (to set exclusive monitor)
    ldaxp x0, x1, [sp]
    
    // Store-release exclusive pair
    mov x1, #0x1234
    mov x2, #0x5678
    stlxp w0, x1, x2, [sp]  // w0 = status (0 = success)
    
    add sp, sp, #32

    brk #0
