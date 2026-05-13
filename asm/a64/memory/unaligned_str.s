/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x000000000000FF00",
    "X1": "0x000000FFFF000000"
  }
}
*/
.text
.global _start
_start:
    // Test unaligned store
    // ARMv8 allows unaligned STR

    sub sp, sp, #32

    // Clear the buffer
    str xzr, [sp]
    str xzr, [sp, #8]

    // Store 32-bit at offset 1 (unaligned)
    mov w2, #0xFF
    str w2, [sp, #1]        // Stores 0xFF at bytes 1-4 (little-endian: FF 00 00 00)

    // Load back and verify
    ldr x0, [sp]            // Should have 0xFF00 at byte 1

    // Store 32-bit at offset 11 (unaligned)
    mov w3, #0xFFFF
    str w3, [sp, #11]       // Stores 0xFFFF at bytes 11-14 (little-endian: FF FF 00 00)

    // Load back and verify
    ldr x1, [sp, #8]        // Should have 0xFFFF000000 at bytes 11-14

    add sp, sp, #32

    brk #0