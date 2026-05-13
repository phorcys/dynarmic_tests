/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000BEEF",
    "X1": "0x000000000000CAFE"
  }
}
*/
// Test: LDURH Wt, [Xn, #simm] - Load Register Halfword (unscaled)
// Load a halfword from memory, zero-extend to 32 bits

.text
.global _start
_start:
    // Setup: store test data on stack
    sub sp, sp, #32
    mov w2, #0xBEEF
    movk w2, #0xCAFE, lsl #16   // w2 = 0xCAFEBEEF
    str w2, [sp]
    
    // Test 1: LDURH with offset 0
    ldurh w0, [sp, #0]    // Load halfword at sp[0] = 0xBEEF
    // X0 = 0xBEEF (zero-extended)
    
    // Test 2: LDURH with offset 2
    ldurh w1, [sp, #2]    // Load halfword at sp[2] = 0xCAFE
    // X1 = 0xCAFE (zero-extended)
    
    add sp, sp, #32

    brk #0
