/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000CDAB",
    "X1": "0x00000000000000CD"
  }
}
*/
// Test: STURB Wt, [Xn, #simm] - Store Register Byte (unscaled)
// Store the least significant byte of Wt to memory

.text
.global _start
_start:
    // Setup: allocate stack space
    sub sp, sp, #32
    
    // Test 1: STURB with offset 0
    mov w0, #0xAB
    sturb w0, [sp, #0]    // Store byte 0xAB at sp[0]
    
    // Test 2: STURB with offset 1
    mov w1, #0xCD
    sturb w1, [sp, #1]    // Store byte 0xCD at sp[1]
    
    // Verify: load back and check
    ldr w2, [sp]
    mov w0, w2
    lsr w1, w2, #8        // X0 = 0xAB, X1 = 0xCD
    
    add sp, sp, #32

    brk #0
