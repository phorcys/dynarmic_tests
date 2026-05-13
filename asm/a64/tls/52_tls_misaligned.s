/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000001000000",
    "X1": "0x1"
  }
}
*/
// Test: Misaligned TLS access
// ARM64 supports unaligned access, verify it works correctly
.text
.global _start
_start:
    mrs x0, tpidr_el0
    
    // Write at misaligned offset (offset 3, not 8-byte aligned)
    add x1, x0, #3
    mov w2, #1
    str w2, [x1]        // Store word at offset 3
    
    // Read back as word
    ldr w3, [x0, #3]
    
    // Read full 8 bytes starting at offset 0 to verify
    ldr x4, [x0, #0]
    // x4: bytes 0-2 are 0, bytes 3-6 are 0x01, bytes 7 is 0
    // In little-endian: byte 3 = 0x01, others = 0
    // So x4 = 0x00000000_01000000
    
    cmp w2, w3
    cset x1, eq
    
    mov x0, x4          // Return the full value
    
    brk #0
