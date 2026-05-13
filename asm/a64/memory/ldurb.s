/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x00000000000000BE",
    "X1": "0x00000000000000EF"
  }
}
*/
// Test: LDURB Wt, [Xn, #simm] - Load Register Byte (unscaled)
// Load a byte from memory, zero-extend to 32 bits

.text
.global _start
_start:
    // Setup: store test data on stack
    sub sp, sp, #32
    
    // Store bytes manually: 0xBE at offset 0, 0xEF at offset 1
    mov w2, #0xBE
    strb w2, [sp, #0]
    mov w2, #0xEF
    strb w2, [sp, #1]
    
    // Test 1: LDURB with offset 0
    ldurb w0, [sp, #0]    // Load byte at sp[0] = 0xBE
    // X0 = 0xBE (zero-extended)
    
    // Test 2: LDURB with offset 1
    ldurb w1, [sp, #1]    // Load byte at sp[1] = 0xEF
    // X1 = 0xEF (zero-extended)
    
    add sp, sp, #32

    brk #0
