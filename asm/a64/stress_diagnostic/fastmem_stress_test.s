/* CONFIG
{
  "Match": "All",
  "RegData": { 
    "X0": "0x0000000055667788",
    "X1": "0x0000000033440000",
    "X2": "0x0000000000000011"
  }
}
*/
// Fastmem stress test - tests memory access patterns that may trigger fastmem fallback
// Tests: unaligned access, store-load forwarding, multiple sizes

.text
.global _start
_start:
    // Allocate stack space for testing
    sub sp, sp, #64

    // Test 1: Store and load different sizes from same base
    ldr x0, =0x1122334455667788
    str x0, [sp]
    
    // Load as different sizes
    ldr w0, [sp]            // w0 = 0x55667788
    ldrh w1, [sp, #4]       // w1 = 0x3344 (bytes at offset 4-5)
    ldrb w2, [sp, #7]       // w2 = 0x11
    
    // Shift w1 for verification
    lsl x1, x1, #16         // x1 = 0x33440000

    // Restore stack
    add sp, sp, #64
    
    brk #0
