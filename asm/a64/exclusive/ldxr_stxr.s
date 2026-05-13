/* CONFIG
{
  "Match": "All",
  "RegData": {
    "X0": "0x0000000000000000",
    "X1": "0x1234567890ABCDEF"
  }
}
*/
// Test: LDXR/STXR - load/store exclusive

.text
.global _start
_start:
    // Allocate stack space
    sub sp, sp, #32

    // Store test value
    mov x1, #0xCDEF
    movk x1, #0x90AB, lsl #16
    movk x1, #0x5678, lsl #32
    movk x1, #0x1234, lsl #48
    str x1, [sp]

    // Clear registers
    mov x1, #0
    mov x0, #0

    // Load exclusive
    ldxr x1, [sp]

    // Store exclusive (should succeed, W0 = 0)
    stxr w0, x1, [sp]

    // X0 (status) should be 0 (success)
    // X1 should have the loaded value

    add sp, sp, #32

    brk #0