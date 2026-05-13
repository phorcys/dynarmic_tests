/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000CAFEBEEF",
    "X1": "0x000000000000CAFE"
  }
}
*/
// Test: STURH Wt, [Xn, #simm] - Store Register Halfword (unscaled)
// Store the least significant halfword of Wt to memory

.text
.global _start
_start:
    // Setup: allocate stack space
    sub sp, sp, #32
    
    // Test 1: STURH with offset 0
    mov w0, #0xBEEF
    sturh w0, [sp, #0]    // Store halfword 0xBEEF at sp[0]
    
    // Test 2: STURH with offset 2
    mov w1, #0xCAFE
    sturh w1, [sp, #2]    // Store halfword 0xCAFE at sp[2]
    
    // Verify: load back and check
    ldr w2, [sp]
    mov w0, w2            // X0 = 0xBEEF (low halfword)
    lsr w1, w2, #16       // X1 = 0xCAFE (high halfword)
    
    add sp, sp, #32

    brk #0
