/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000041444342", "X1": "0x0000000000004342" }
}
*/
.text
.global _start
_start:
    // Test unaligned memory access
    // ARMv8 allows unaligned access for most LDR/STR instructions

    // Set up aligned buffer
    sub sp, sp, #32

    // Store "ABCDABCDABCDABCD" pattern using 64-bit stores
    ldr x2, =0x4443424144434241   // "DCBADCBA" in little-endian = "ABCDABCD"
    str x2, [sp]
    str x2, [sp, #8]

    // Load 32-bit from offset 1 (unaligned)
    ldr w0, [sp, #1]        // Loads bytes 1-4: B, C, D, A
    // w0 = 0x41444342 (A D C B in little-endian)

    // Load 16-bit from offset 1 (unaligned)
    ldrh w1, [sp, #1]       // Loads bytes 1-2: B, C
    // w1 = 0x4342 (C B in little-endian)

    // Clean up stack
    add sp, sp, #32

    brk #0
