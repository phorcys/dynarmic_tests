/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x4344434241444342",
    "X1": "0x4144434443424144"
  }
}
*/
.text
.global _start
_start:
    // Test unaligned 64-bit load
    // ARMv8 allows unaligned LDR X

    // Set up buffer with pattern
    sub sp, sp, #32

    // Store "ABCDABCDABCDABCD" pattern
    ldr x2, =0x4443424144434241   // "DCBADCBA" = "ABCDABCD"
    str x2, [sp]
    ldr x3, =0x4544434241414443   // "EDCBAADC" pattern
    str x3, [sp, #8]

    // Load 64-bit from offset 1 (unaligned)
    ldr x0, [sp, #1]        // Loads bytes 1-8

    // Load 64-bit from offset 3 (unaligned)
    ldr x1, [sp, #3]        // Loads bytes 3-10

    // Clean up
    add sp, sp, #32

    brk #0