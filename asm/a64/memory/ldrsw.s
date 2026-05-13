/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0xFFFFFFFF80000000",
    "X1": "0x000000007FFFFFFF"
  }
}
*/
// Test: LDRSW - Load Register Signed Word

.text
.global _start
_start:
    // Store test data: 0x80000000 (-2147483648), 0x7FFFFFFF (2147483647)
    // We need to store 32-bit values
    movz w8, #0x0000
    movk w8, #0x8000, lsl #16    // w8 = 0x80000000
    
    movz w9, #0xFFFF
    movk w9, #0x7FFF, lsl #16    // w9 = 0x7FFFFFFF
    
    stp w8, w9, [sp, #-16]!
    
    // Load signed word (sign-extended)
    ldrsw x0, [sp]       // Load 0x80000000, sign-extend
    ldrsw x1, [sp, #4]   // Load 0x7FFFFFFF, sign-extend (w is 4 bytes)

    brk #0
