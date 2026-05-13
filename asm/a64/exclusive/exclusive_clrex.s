/* CONFIG
{
  "Match": "All",
  "RegData": { "X0": "0x0000000000000001" }
}
*/
// Test: CLREX followed by STXR should fail

.text
.global _start
_start:
    sub sp, sp, #16

    // Setup: Store a value
    mov x2, #42
    str x2, [sp]

    // Load exclusive
    ldxr x3, [sp]

    // Clear exclusive monitor
    clrex

    // Store exclusive should fail (monitor was cleared)
    mov x4, #99
    stxr w0, x4, [sp]     // w0 should be 1 (fail)

    add sp, sp, #16

    brk #0
